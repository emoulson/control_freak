# control_freak
A simple script to view and remove troublesome ASCII control characters from text files

## Why?
ASCII control characters have a habit of breaking things

## Usage
`ruby control_freak.rb [options]`

```
-q, --quiet                      Suppresses removed character output to the terminal
-f, --file INPUT                 The full or relative path of the file to operate on
-o, --output OUTPUT              The full or relative path of the output file
-i, --in-place                   Writes the changes to the file, in place *(Not working at the moment)*
-d, --dry-run                    Run a dry run of the characters to be deleted
-h, --help                       This script removes control characters from files
-v, --version                    Show version
```

It can currently only be used for text files (passing non-text files gives unexpected results).

## What gets removed?
ASCII characters 0-31 and 127 (aka "Control Characters"), except:
- `9` (horizontal tab, `\t`) |
- `10` (line feed, `\n`) |
- `13` (carriage return, `\r`) |

## Sample
```
ruby control_freak.rb -f ../lipsum.txt -o ../lipsum_fixed.txt
Line 1, character 247:\u0003
Line 1, character 248:\u0003
Line 1, character 249:\u0003
Line 2, character 1:\u000b
```

## To-do
- [ ] Fix `in-place` functionality
- [ ] Add option to retain characters
- [ ] Add "Nothing changed" message
- [ ] Add support for XLSX/XLSM files

## License
MIT License
