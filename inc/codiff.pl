# codiff.pl generated from codiff-0.2/src/codiff.pl Mar 2026
{ # -------------------------------------------------------------------------------- COLOR DIFF 
# our $MODE=1;     # 1=char 2=word 3=block 0=line
# our $ALL=0;      # 1=all_lines 0=only_changed
# our $CONTEXT=4;  # 4 lines of context
# our $NOBLANK=1;  # ignore blank lines
# our $ANYSPACE=1; # any space width
# our $NOSPACES=1; # ignore spaces

# use Algorithm::Diff qw(sdiff); ...choose XS version if available
eval  { require Algorithm::Diff::XS; Algorithm::Diff::XS->import(qw(sdiff)) }
or do { require Algorithm::Diff;     Algorithm::Diff->import(qw(sdiff)) };

# these are ok for programming languages, TODO: identify file type and choose appropriate ones
# TODO: don't break block at {} when it is inside "" string
my $REB = qr/[{};]/;				# blocks separators
my $REW = qr/[(){}\[\];`"'\s,+\-*\/%=&|^~!<>]/;	#  words separators

# use lookbehind/lookahead to obtain: foo(bar) => ['foo','(','bar',')']
my sub tokenise {
  my $s = $_[0];
  if   ($MODE==1) { return split //,$s }
  elsif($MODE==2) { return split /(?<=$REW)|(?=$REW)/,$s }
  elsif($MODE==3) { return split /(?<=$REB)|(?=$REB)/,$s }
  else		  { return $s }}

# i1,i2 = line numbers in file1 and file2
# @del,@add = line arrays, to delete and to add

my sub flush {
  my ($del,$add,$i1,$i2,$w) = @_;
  my $pairs = @$del < @$add ? @$del : @$add;
  for my $j (0 .. $pairs-1) {
    my @d = sdiff([tokenise($del->[$j])],[tokenise($add->[$j])]);
    my ($d,$a,$D,$A) = ("","",0,0); # d=del_rebuilt a=add_rebuilt D=d_changed A=a_changed
    for(@d) {
      my ($t,$o,$n) = @$_; # t=type o=old n=new
      if   ($t eq "u") { $d.="$CK_$o$CD_"; $a.=$n }
      elsif($t eq "c") { $d.="$CR_$o$CD_"; $a.="$CG_$n$CD_"; ($D,$A)=(1,1) }
      elsif($t eq "-") { $d.="$CR_$o$CD_"; $D=1 }
      elsif($t eq "+") { $a.="$CG_$n$CD_"; $A=1 } }
    printf "$CR_%${w}d$CD_ $CR_-$CD_ %s\n",$$i1,$d if $D; # old line with highlights
    printf "$CG_%${w}d$CD_ $CG_+$CD_ %s\n",$$i2,$a if $A; # new line with highlights
    $$i1++; $$i2++ }
  # excess old and new lines
  printf "$CR_%${w}d$CD_ $CR_-$CD_ $CR_%s$CD_\n",$$i1++,$_ for @{$del}[$pairs..$#$del];
  printf "$CG_%${w}d$CD_ $CG_+$CD_ $CG_%s$CD_\n",$$i2++,$_ for @{$add}[$pairs..$#$add]; }

our sub codiff {
  my ($file1,$file2) = @_;
  my ($i1,$i2,@del,@add) = (0,0);
  my $w = length(int((-s $file1)/35)); # line-number length (guessed for average line width 35)

  # -B ignore changes where lines are all blank
  my $o = "-u0";
     $o = "-u999999" if $ALL;
     $o = "-u$CONTEXT" if defined $CONTEXT;
     $o.= " -B" if $NOBLANK;
     $o.= " -b" if $ANYSPACE;
     $o.= " -w" if $NOSPACES;
  my $cmd = "diff $o -- \Q$file1\E \Q$file2\E";
  if($VERBOSE and defined &verbose) { verbose "call","$CM_$cmd$CD_"; print "\n" }
  open my $fh,"$cmd |";

  while (<$fh>) {
    chomp;
    if(/^---|\+\+\+/) {}				# files names
    elsif(/^@@ -(\d+)(,\d+)? \+(\d+)(,\d+)? @@/) {	# lines numbers
      flush(\@del,\@add,\$i1,\$i2,$w);
      ($i1,$i2,@del,@add)=($1,$3) }
    elsif(/^-(.*)/)  { push @del,$1 }			# deleted lines
    elsif(/^\+(.*)/) { push @add,$1 }			# added lines
    elsif(/^ (.*)/) {					# context lines
      flush(\@del,\@add,\$i1,\$i2,$w);
      printf "$CK_%${w}d$CD_   $CK_%s$CD_\n",$i2,$1;
      $i1++; $i2++; (@del,@add)=() }}
  flush(\@del,\@add,\$i1,\$i2,$w);
  close $fh }

# TODO: to ignore comments with -nc use this:
#       similarly real noindent with -ni
# - elsif(/^\+(.*)/) { push @add,$1 }
# + elsif(/^\+(.*)/) { my $a=$1; $a=~s/\h*#.*//; push @add,$a }
# use this to handle full-line comments (as preprocess)
# diff -u0 -I '^\s*#' FILE1 FILE2
} # ------------------------------------------------------------------------ R.Jaksa 2026 GPLv3
