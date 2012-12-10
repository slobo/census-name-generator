#!/usr/bin/env perl

use strict;
use warnings;
use LWP::Simple;
use Getopt::Long;
use Pod::Usage;

use constant {
    LAST_NAME_URL           => "http://www.census.gov/genealogy/www/data/1990surnames/dist.all.last",
    FIRST_NAME_FEMALE_URL   => "http://www.census.gov/genealogy/www/data/1990surnames/dist.female.first",
    FIRST_NAME_MALE_URL     => "http://www.census.gov/genealogy/www/data/1990surnames/dist.male.first",

    LAST_NAME_FILE          => "lname.dat",
    FEMALE_FIRST_NAME_FILE  => "fnamef.dat",
    MALE_FIRST_NAME_FILE    => "fnamem.dat",
};

=head1 NAME

namegen.pl - Random name generator

=head1 SYNOPSIS

  namegen.pl [options]

  Options:
  -n --names     Number of names to generate
  -d --download  Download census name data
  -r --ratio     Ratio of female vs male names as percentage (default 50)
  -? --help      Display this help and exit

=head1 DESCRIPTION

Generates random names from census data

=head1 METHODS
=cut

my $opts = {
    ratio => 50,
};
GetOptions( $opts,
    'download|d',
    'names|n=s',
    'ratio|r=s'
);

pod2usage(1) if ! $opts->{names} && ! $opts->{download};

if (!(-f LAST_NAME_FILE && -f MALE_FIRST_NAME_FILE && -f FEMALE_FIRST_NAME_FILE) && ! $opts->{download}) {
    print "First time you run this, use the -d option to download name files from the census.\n";
    exit 1;
}

if ($opts->{download}) {
    download(LAST_NAME_URL, LAST_NAME_FILE, "last name census data");
    download(FIRST_NAME_FEMALE_URL, FEMALE_FIRST_NAME_FILE, "female first name census data");
    download(FIRST_NAME_MALE_URL, MALE_FIRST_NAME_FILE, "male first name census data");
    exit;
}

my @lnames = makeNameArray(LAST_NAME_FILE);
my @fnamefs = makeNameArray(FEMALE_FIRST_NAME_FILE);
my @fnamems = makeNameArray(MALE_FIRST_NAME_FILE);

for(my $i = 0 ; $i < $opts->{names}; ++$i) {
    # Last name
    my $lname = $lnames[int(rand($#lnames + 1))];

    # Male or female?
    my $fname = (rand(1) > $opts->{ratio} / 100) ? $fnamems[int(rand($#fnamems + 1))] : $fnamefs[int(rand($#fnamefs + 1))];

    print "$fname $lname\n";
}

sub download{
    my ($url, $file, $desc)= @_;

    ++$|; #disable output buffering

    print "Downloading " . $desc . "... ";
    getstore($url, $file) or die "Unable to download " . $desc . " (" . $url . ")\n";
    print "Done.\n";
}

sub makeNameArray {
    my $file = $_[0];
    my @names;
    open(FILE, $file);
    while(<FILE>) {
        chomp;

        # First column (1-15) is the name.  Format it.
        my $name = substr $_, 0, 15;
        $name =~ s/\s//g;
        $name = ucfirst(lc($name));

        # Second column (16-20) is the % distribution of this name in the population.
        my $count = substr $_, 16, 5;
        $count = int($count * 1000 + 0.5);

        # Add name to the array in a quantity relative to the % distribution.
        for(my $i = 0 ; $i < $count ; ++$i) {
             push(@names, $name);
        }
    }
    return @names;
}
