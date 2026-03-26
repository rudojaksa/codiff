### NAME
codiff - color word/character diff

### USAGE
      codiff [OPTIONS] FILE1 FILE2

### DESCRIPTION
Compare two files and highlight changed characters, words or blocks.
Streams and colors GNU diff output on the fly.

### OPTIONS
          -h  This help.
          -v  Verbose.
          -a  Print all lines.
        -NUM  Print NUM lines of context around each change.
    -c/w/b/l  Character/word/block/line mode (-w default).
         -nb  No blank lines changes.
         -ns  No whitespace amount changes.
        -nss  Ignore all whitespace changes.

### LINE NUMBERS
      Red line numbers refer to FILE1, green and black to FILE2.

### NOTE
      Character-mode produces the most compact output: inserting a single
      character costs one token, while word-mode would show the old word
      removed and new word added.

### VERSION
codiff-0.2 R.Jaksa 2026 GPLv3 built Mar 2026

