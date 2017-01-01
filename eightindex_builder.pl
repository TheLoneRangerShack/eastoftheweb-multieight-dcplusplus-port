use warnings;
use strict;
use IO::File;

#Read from the command line - the word directory to scan, and the name of the file to write into
my $argc = @ARGV;
my $wordDir;
my $wordDatabase;
my $wordFileExt;
if ( $argc >=2 && $argc <=3) {
	$wordDir = $ARGV[0];
	$wordDatabase = $ARGV[1];
	$wordFileExt = $argc==2?"":$ARGV[2];
}
else {
	die "Bad arguments. Pass <word directory to scan> <file to store list of eight letter words> <word file ext>\n Eg. perl eightindex_builder.pl /home/y/docs/words eights.database .txt";
}

opendir(my $dirHandle, $wordDir);
my @files = grep(!/^\.|\.\.|$wordDatabase/, readdir($dirHandle));
closedir($dirHandle);

open(my $fileHandle, ">", "$wordDir/$wordDatabase");
foreach my $file (@files) {
	$file =~ s/$wordFileExt//;
	print $fileHandle "$file\n";
}	
close( $fileHandle);
