#!/usr/bin/env python3
"""Open a Gitea pull request via python/libraries/gitea's existing REST client.

Standalone -- no dependency on the Lucifer Qt app being importable, only on
python/libraries/gitea. Reads {"head": ..., "base": ..., "title": ...,
"body": ...} as JSON from stdin (avoids shell-quoting problems with
arbitrary title/body text); --org/--repo are plain args since those never
contain special characters.

Mirrors submit-gitea-issue's submit_issue.py.
"""
import argparse
import json
import os
import platform
import sys
from pathlib import Path

DEFAULT_ORG = "refuge"
DEFAULT_REPO = "Lucifer"

# Mirrors Lucifer/config.py's PROD_PIPELINE_ROOT/PROD_PIPELINE_ROOT_POSIX --
# duplicated here (not imported) so this script has zero dependency on the
# Lucifer app package being importable.
_PROD_PIPELINE_ROOT = r"\\skynet\Pipeline"
_PROD_PIPELINE_ROOT_POSIX = "/skynet/Pipeline"


def _ensure_gitea_lib_importable():
    """Puts python/libraries on sys.path and fills in os.environ['refugepipeline']
    if unset -- load_token_constants.py hard-requires that lowercase env var
    (Windows os.environ lookups are case-insensitive, but not on WSL/Linux)."""
    pipeline_root = os.environ.get("REFUGEPIPELINE") or os.environ.get("refugepipeline")
    if not pipeline_root:
        pipeline_root = _PROD_PIPELINE_ROOT if platform.system() == "Windows" else _PROD_PIPELINE_ROOT_POSIX

    python_dir = str(Path(pipeline_root) / "python")
    if python_dir not in sys.path:
        sys.path.append(python_dir)
    os.environ.setdefault("refugepipeline", str(pipeline_root))


def main():
    parser = argparse.ArgumentParser(description="Open a Gitea pull request (fields read as JSON from stdin)")
    parser.add_argument("--org", default=DEFAULT_ORG)
    parser.add_argument("--repo", default=DEFAULT_REPO)
    args = parser.parse_args()

    payload = json.load(sys.stdin)
    data = {
        "head": payload["head"],
        "base": payload.get("base", "main"),
        "title": payload["title"],
        "body": payload.get("body", ""),
    }

    _ensure_gitea_lib_importable()
    try:
        from libraries.gitea.handlers.create_pull_request import create_pull_request_request
        from libraries.gitea.handlers.process_requests import process_request
        from libraries.gitea.handlers.load_token_constants import load_token, load_api_url
    except KeyError as e:
        print(f"ERROR: missing environment variable {e} (required by the shared gitea library)", file=sys.stderr)
        sys.exit(1)

    token = load_token()
    api_url = load_api_url()
    req = create_pull_request_request(api_url, token, args.repo, data, org=args.org)
    result = process_request(req)
    pr = result["decoded_response"]
    print(json.dumps({"html_url": pr.get("html_url", ""), "number": pr.get("number")}))


if __name__ == "__main__":
    main()
