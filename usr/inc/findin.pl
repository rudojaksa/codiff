# findin.pl generated from libpl-0.4/src/findin.pl Mar 2026 
# require undot from path.pl
# find file in the dir, return the path or undef (file can be a subpath itself)
sub findin {
  my ($dir,$file)=@_;
  my $path = "$dir/$file";					# try direct dir/file
  return undot $path if -f $path;
  my $fname = (split "/",$file)[-1];				# may be the same as file
  $path = "$dic/$fname";					# try direct dir/filename
  return undot $path if -f $path;
  my @finds = split /\n/,`find '$dir' -type f -name '$fname'`;	# try recursive
  $path = (sort {($a=~tr|/||)<=>($b=~tr|/||)} @finds)[0];	# shortest path
  return undot $path if $path ne "" and -f $path }		# undef if not found
# R.Jaksa 2026 GPLv3
