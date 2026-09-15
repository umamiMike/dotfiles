#!/usr/bin/env python3
"""Make one Gitea issue depend on another (or on a PR) via python/libraries/gitea.

Standalone -- no dependency on the Lucifer Qt app being importable, only on
python/libraries/gitea. Issues and pull requests share the same index space
in Gitea, so --depends-on may be a PR number.

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
    parser = argparse.ArgumentParser(description="Make one issue depend on another/a PR")
    parser.add_argument("--org", default=DEFAULT_ORG)
    parser.add_argument("--repo", default=DEFAULT_REPO)
    parser.add_argument("--issue", required=True, type=int, help="index of the issue that should depend on something")
    parser.add_argument("--depends-on", required=True, type=int, help="index of the issue/PR it depends on")
    args = parser.parse_args()

    _ensure_gitea_lib_importable()
    try:
        from libraries.gitea.handlers.add_issue_dependency import add_issue_dependency_request
        from libraries.gitea.handlers.process_requests import process_request
        from libraries.gitea.handlers.load_token_constants import load_token, load_api_url
    except KeyError as e:
        print(f"ERROR: missing environment variable {e} (required by the shared gitea library)", file=sys.stderr)
        sys.exit(1)

    token = load_token()
    api_url = load_api_url()
    req = add_issue_dependency_request(api_url, token, args.repo, args.issue, args.depends_on, org=args.org)
    result = process_request(req)
    print(json.dumps(result["decoded_response"]))


if __name__ == "__main__":
    main()
