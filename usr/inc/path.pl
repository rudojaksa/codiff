# path.pl generated from libpl-0.4/src/path.pl Mar 2026 
{ # FILESYSTEM PATHS ROUTINES

# return the dirname from the path, or undef
our sub dname {
  return undef if not $_[0] =~ /^.*\/[^\/]*\/*$/;
  return $1 eq '' ? '/' : $1 }

# return filename from path: remove trailing slashes first, then remove directory part
our sub fname {
  return undef if !defined $_[0] or $_[0] eq "" or $_[0]=~/^\/+$/; # "/" is undef, not ""
  return $_[0] =~ s/\/+$//r =~ s/^.*\///r }

# return file suffix, or undef
our sub sx {
  return undef if not defined $_[0];
  return $1 if $_[0] =~ /\.([^.]*)$/;
  return undef }

# just remove the leading "./" from the path
our sub undot {
  return undef if not defined $_[0];
  return $_[0] =~ s/^(?:\.\/)+//r }

# beautify($path,$cwd)
our sub beautify {
  my $qcwd = quotemeta $_[1];								# CWD
  my $p1=$_[1]; $p1=~s/\/*$//; $p1=~s/[^\/]*$//; $p1=~s/\/*$//; my $qp1 = quotemeta $p1;# parent
  my $p2=$p1; $p2=~s/\/*$//; $p2=~s/[^\/]*$//; $p2=~s/\/*$//; my $qp2 = quotemeta $p2;	# grandparent
  my $qh = quotemeta $ENV{HOME};							# home
  my $p = $_[0];
  $p =~ s/^$qcwd\/// if $qcwd;		# /abc/def/ghi -> ghi if cwd=/abc/def
  $p =~ s/^$qp1\//..\// if $qp1;	# /abc/def/ghi -> ../ghi if cwd=/abc/def/xyz
  $p =~ s/^$qp2\//..\/..\// if $qp2;	# /abc/def/ghi -> ../../ghi if cwd=/abc/def/xyz/ijk
  $p =~ s/^$qh\//~\// if $qh;		# /home/abc/xyz -> ~/xyz
  $p =~ s/^\.\///;			# remove the leading "./"
  return $p }

# $path = mindepth @paths; returns the path form the array which has the minimal depth
our sub mindepth {
  my $p; my $d=1000000;
  for my $f (@_) { my $n=$f=~tr/\///; $p=$f and $d=$n if $n<$d }
  return $p }

} # R.Jaksa 2024,2026 GPLv3
