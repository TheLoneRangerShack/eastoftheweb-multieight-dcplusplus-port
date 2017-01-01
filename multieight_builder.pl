#This is an implementation of a dawg
use warnings;
use strict;
use IO::File;

#Command line parameters to pass: <path to dictionary file> <number of words to build> <path to word directory> <ext of word file>

my $argc = @ARGV;
my $buildCount;
my $dictionaryFile;
my $wordDir;
my $wordFileExt;

if ( $argc == 4  ) {
	$dictionaryFile = $ARGV[0];
	$buildCount = int($ARGV[1]);
	$wordDir = $ARGV[2];
	$wordFileExt = $ARGV[3];
	
}
else {
	die "Bad arguments. Pass <path to dictionary> <number of words to build> <path to word dir> <extension of each word file>\n Eg. perl multieight_builder.pl /home/y/docs/sowpods.txt 20 /home/y/docs/words .txt";
}

#Pick up my sowpods and load a hash with the word list
my $fileHandle = IO::File->new($dictionaryFile, 'r');
my %dictionary = ();
my @eights = ();
while ( my $word = $fileHandle->getline ) {
	chomp $word;
	$word = lc($word);
	$dictionary{$word} = 1;
	
	if ( length($word) == 8 ) {
		push(@eights, $word);		
	}
}


my $globalWordCount = 0;
#my $word;
#my $total = keys %dictionary;
##my $eightcount = @eights;
#print $total." ".$eightcount;

#Generate sets for $buildCount words
foreach my $counter (1 .. $buildCount) {
	my $word = $eights[int(rand($#eights))];
	(--$counter and next) if -e "$wordDir/$word$wordFileExt";

    #List of sub words
    my %seen = ();
    perm($word, 0, \%seen);
    
    #Write these to file
	open( my $wordFile, ">", "$wordDir/$word$wordFileExt") or die("Failed to open file");
	foreach my $subWord (sort keys %seen) {
        print $wordFile "$subWord\n"
    }
	close($wordFile);
}


#perm ( $word, 0 );



#permute a given word
sub perm {
	my $word = shift;
	my $step = shift;
	my $seen = shift;
	my $size = length($word) ;

	#die "bad file handle" unless defined $wordFile;

	# We only want words >= 3 letters
	if ( $step >= 3 ) {
		my $wordSlice = substr($word, 0 , $step);
		if (exists $dictionary{$wordSlice} and not exists $seen->{$wordSlice}) {
			$seen->{$wordSlice} = 1;
		}
		if ( $step == $size ) {
			return;
		}	
	}

	for ( my $i = $step; $i < $size; $i++ ) {
		perm ( $word, $step+1, $seen);
		my $newWord = substr($word, 0, $step).substr($word, $step+1, $size-$step-1).substr($word, $step, 1);
		$word = $newWord;

	}
}

