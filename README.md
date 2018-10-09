# Control Freak
A simple script to view and remove troublesome ASCII control characters from text files

## Why?
ASCII control characters have a habit of breaking things

## Usage
`ruby control_freak.rb [input file] [options]`

```
OPTIONS:
-q, --quiet                      Suppresses removed character output to the terminal
-o, --output OUTPUT              The full or relative path of the output file
-i, --in-place                   Writes the changes to the file, in place
-d, --dry-run                    Run a dry run of the characters to be deleted
-h, --help                       Show this help text
-v, --version                    Show version
```

It can currently only be used for text files (passing non-text files gives unexpected results).
**This includes `.txt`, `.json`, and `.csv` files.**

Output files use UTF-8 encoding.

## What gets removed?
ASCII characters 0-31 and 127 (aka "Control Characters"), except:
- `9` (horizontal tab, `\t`)
- `10` (line feed, `\n`)
- `13` (carriage return, `\r`)

## Sample
```
ruby control_freak.rb ../lipsum.txt -o ../lipsum_fixed.txt
Line 1, char 223: \u0003
Line 1, char 224: \u0003
Line 1, char 225: \u0003
Line 2, char 1: \u000b
Line 2, char 2: \u000b
```

## To-do
- [x] Fix `in-place` functionality
- [x] Require input file as script argument
- [ ] Add option to retain characters
- [ ] Add "Nothing changed" message
- [ ] Add support for XLSX/XLSM files

## License
MIT License
