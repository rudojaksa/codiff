codiff
======

> [`codiff` manpage](doc/codiff.md)  
> [comparison of color diffs](doc/comparison.md)  

Color diff that prints old and new lines with changed characters/words/blocks highlighted.  It streams the GNU diff output line by line, coloring it on the fly.  

If either file is a directory, it recursively searches for a corresponding file within that directory. GNU diff on Linux also supports file-vs-directory comparison by matching the filename within the directory, but without recursion.

If the second file is omitted, it recursively searches the current working directory for a corresponding file.

<a href=doc/codiff.png><img width=640px src=doc/codiff.png></a>

### INSTALL:

[`codiff`](codiff) is a standalone Perl script, just copy or download it and run.  Don't forget `chmod +x`.  Tested on Linux and macOS.  Requires `Algorithm::Diff`, usually already installed.

Direct link:<br>
[`curl -O https://raw.githubusercontent.com/rudojaksa/codiff/main/codiff`](https://raw.githubusercontent.com/rudojaksa/codiff/main/codiff)

<br><div align=right><i>R.Jaksa 2026 GPLv3</i></div>
