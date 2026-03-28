our $HELP = <<EOF;

NAME
    codiff - color word/character diff

USAGE
    codiff [OPTIONS] `FILE1` `FILE2`

DESCRIPTION
    Compare two files and highlight changed characters, words or blocks.
    Streams and colors GNU `diff` output on the fly.

    If either FILE1 or FILE2 is a directory, it recursively searches for
    corresponding file within that directory.  If FILE2 is omitted, it
    searches the CWD recursively for a corresponding file.

OPTIONS
        -h  This help.
        -v  Verbose.
        -a  Print all lines.
      -NUM  Print `NUM` lines of context around each change.
  -c/w/b/l  Character/word/block/line mode (`-w` default).
       -nb  No blank lines changes.
       -ns  No whitespace amount changes.
      -nss  Ignore all whitespace changes.

LINE NUMBERS
    Red line numbers refer to `FILE1`, green and black to `FILE2`.

NOTE
    Character-mode produces the most compact output: inserting a single
    character costs one token, while word-mode would show the old word
    removed and new word added.

VERSION
    $PACKAGE-$VERSION$SUBVERSION CK($AUTHOR) CK(built $BUILT)

EOF

# ---------------------------------------------------------------------------------------- ARGV
# include colors/base.pl array.pl path.pl printhelp.pl findin.pl

sub verbose { printf STDERR "$CC_%11s:$CD_ %s $CK_%s$CD_\n",$_[0],$_[1],$_[2] }
sub error   { printf STDERR "$CR_%11s:$CD_ %s $CK_%s$CD_\n",$_[0],$_[1],$_[2]; exit }

printhelp $HELP and exit if clar \@ARGV,"-h";
$VERBOSE=1 if clar \@ARGV,"-v";

 $NOBLANK=1 if clar \@ARGV,"-nb";  # ignore blank lines
$ANYSPACE=1 if clar \@ARGV,"-ns";  # any space width
$NOSPACES=1 if clar \@ARGV,"-nss"; # ignore spaces

our $ALL=0; # 1=all_lines 0=only_changed
$ALL=1 if clar \@ARGV,"-a";

our $MODE=2; # 1=char 2=word 3=block 0=line
$MODE=1 if clar \@ARGV,"-c";
$MODE=2 if clar \@ARGV,"-w";
$MODE=3 if clar \@ARGV,"-b";
$MODE=0 if clar \@ARGV,"-l";

our $CONTEXT;
for(@ARGV) { ($CONTEXT,$_)=($1,"") and last if $_=~/^-(\d+)$/ }

our $FILE1; for(@ARGV) { ($FILE1,$_)=($_,"") and last if $_ ne "" and -e $_ }
our $FILE2; for(@ARGV) { ($FILE2,$_)=($_,"") and last if $_ ne "" and -e $_ }

# wrong arguments
our @wrong; for(@ARGV) { push @wrong,$_ if $_ ne "" }
verbose "wrong args",join(" ",@wrong) if @wrong;

# initial paths
verbose "arg 1",$FILE1 if $VERBOSE and $FILE1 and not -f $FILE1;
verbose "arg 2",$FILE2 if $VERBOSE and $FILE2 and not -f $FILE2;

# FILE1 missing => fail
# FILE2 missing => look in CWD for the same filename (direct path or recursive)
# FILE1 or FILE2 is directory => look inside (direct or recursive, GNU diff does direct one)
if(not defined $FILE1) {
  error "missing","input files" }
elsif(not defined $FILE2) {
  error "not a file",$FILE1 if not -f $FILE1;
  error "error","$FILE1 is a local file" if not $FILE1=~/^\.\.\// and not $FILE1=~/^\//;
  $FILE2 = findin ".",fname($FILE1);
  error "error","file $FILE1 not found in current working directory" if not -f $FILE2 }
elsif(-f $FILE1 and -d $FILE2) {
  $FILE2 = findin $FILE2,$FILE1;
  error "error","directory $FILE2 doesnt contain $FILE1" if not -f $FILE2 }
elsif(-d $FILE1 and -f $FILE2) {
  $FILE1 = findin $FILE1,$FILE2;
  error "error","directory $FILE1 doesnt contain $FILE2" if not -f $FILE1 }

verbose "file 1",$FILE1 if $VERBOSE;
verbose "file 2",$FILE2 if $VERBOSE;
exit if not defined $FILE1 or not defined $FILE2;

# include inc/codiff.pl
codiff $FILE1,$FILE2;

# -------------------------------------------------------------------------- R.Jaksa 2026 GPLv3
