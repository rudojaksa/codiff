Comparison of color diffs
=========================

### OUTPUT COMPARISON:

GNU **diff**<br>
<a href=diff.png><img width=640px src=diff.png></a>

**git diff**<br>
<a href=gitdiff.png><img width=640px src=gitdiff.png></a>

**ccdiff**<br>
<a href=ccdiff.png><img width=640px src=ccdiff.png></a>

**codiff**<br>
<a href=codiff.png><img width=640px src=codiff.png></a>

Codiff is terse, it prepends line numbers, highlights particular changes, and doesn't mix old and new on a single line.

### SPEED COMPARISON:

Example run on randomly chosen data on Ubuntu:

<table>
<tr><td></td><td>to /dev/null</td><td>to terminal</td></tr>
<tr><td align=right> GNU <b>diff</b> </td><td align=right> 0.2 sec </td><td align=right> 3.8 sec </td></tr>
<tr><td align=right> <b>git diff</b> </td><td align=right> 0.4 sec </td><td align=right> 2.8 sec </td></tr>
<tr><td align=right> <b>ccdiff</b>   </td><td align=right> 8.6 sec </td><td align=right> 9.1 sec </td></tr>
<tr><td align=right> <b>codiff</b>   </td><td align=right> 5.2 sec </td><td align=right><b>6.3 sec</b></td></tr>
</table>

Codiff calls GNU diff internally, with additional Perl parsing adding a small overhead.

<br><div align=right><i>R.Jaksa 2026</i></div>
