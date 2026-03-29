When editing CLI entry point files (main.py, cli.py, index.ts with commander/yargs, *.sh):
- Exit codes: 0 = success, 1 = usage error, 2 = runtime error
- Always print usage/help on wrong args — never silent fail
- Validate required args before doing any work (fail fast)
- Progress feedback for operations > 1s (spinner or progress bar)
- Errors to stderr, output to stdout — never mix
- Destructive operations (delete, overwrite): require --confirm flag or prompt
