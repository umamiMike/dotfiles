# fd

> A fast alternative to `find`.

- Find all mp4s larger than 50MB:

`fd . --extension mp4 --size +50M`

- Find and move large mp4s to a directory:

`fd . --extension mp4 --size +50M --exec mv '{}' {{/path/to/destination}} \;`

- Print the first 6 lines of every markdown file:

`fd '.md$' -x sed -n '1,6p' {}`

- Pipe fd results with null delimiter into xargs:

`fd -0 {{pattern}} {{dir}} | xargs -0 {{command}}`

- Extract first line of all markdown files via xargs:

`fd --extension md | xargs -I _ sh -c 'sed 1q "_"'`
