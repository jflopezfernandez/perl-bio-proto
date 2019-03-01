#!/usr/bin/perl
use strict;
use warnings;

use lib "C:/Users/JoseFernandoLopezFer/Documents/perl/bio/Bio";

use Bio;

sub BooleanString {
    my ($value) = @_;

    return $value ? "True" : "False";
}

# Options
my $optionDebug = 0;
my $optionVerbose = 0;

my @files = ();
my @options = ();

sub Print {
    my ($msg) = @_;

    print $msg or die;

    return;
}

sub PrintHelp {
    Print("\n");
    Print("Usage: perl gen.pl [options] [file(s)]\n\n");
    Print("Options: \n");
    Print(" --debug    [-d]  Print debug information when executing.\n");
    Print(" --help     [-h]  Print this help menu and exit.\n");
    Print(" --verbose        Print detailed information when executing.\n");
    Print(" --version  [-v]  Print program version and exit.\n");
    Print("\n\n");

    return;
}

sub PrintVersion {
    Print("gen.pl version 0.0.1, written by Jose Fernando Lopez Fernandez.\n\n");
    
    return;
}

sub PrintConfiguration {
    my $optionDebugString = BooleanString($optionDebug);
    my $optionVerboseString = BooleanString($optionVerbose);

    Print("\nConfiguration: \n");
    Print("  - Debug: $optionDebugString\n");
    Print("  - Verbose: $optionVerboseString\n\n");

    return;
}

foreach my $arg (@ARGV) {
    if ($optionDebug) {
        Print("Arg: $arg\n");
    }

    if ($arg =~ /\-+(?<Option>.*)/sx) {
        # Option: Help
        # Usage: --help or -h
        if ($+{Option} =~ /^h(elp)?/sx) {
            # Regardless of the location of the help option in the argument
            # list, when found simply print the help menu and exit.
            PrintHelp();
            exit;
        }

        if ($+{Option} =~ /^d(ebug)?/sx) {
            $optionDebug = 1;
            next;
        }

        if ("$+{Option}" eq "verbose") {
            $optionVerbose = 1;
            next;
        }

        if ($+{Option} =~ /^v(ersion)?/sx) {
            # Having previously verified the option variable did not match
            # as verbose, we can here specify that a single letter v is enough
            # to specify version, although we obviously still check for the
            # whole thing just in case.
            PrintVersion();
            exit;
        }
    }

    # If this section is reached, it means the argument was not an option,
    # so add it to the file list.
    push @files, $arg;
}

if ($optionDebug || $optionVerbose) {
    if ($optionDebug) {
        PrintConfiguration();
    }

    # If either of the debug or verbose options have been specified, print all
    # the file names in the file list.
    foreach my $file (@files) {
        Print("File: $file\n");
    }
}

# If the file list is empty after parsing the command line, print the help
# menu and exit.
if (scalar @files == 0) {
    Print("No input files specified.\n");
    PrintHelp();
    exit;
}

# Verify the Bio library was loaded.
# Bio::Initialized() or die;

# Main program execution, performing analysis on each input file.
foreach my $file (@files) {
    # Verify each file process exists when iterating over the file list. If
    # the file does not exist, log the error to STDOUT and simply call 'next',
    # quietly moving on to the next file.
    if (not -e $file) {
        Print("$file does not exist.\n");
        
        # Proceeding quietly to the next file in the list.
        next;
    }

    open(my $input, "< :encoding(UTF-8)", $file) or die "Failed to open file: $file\n";

    my $DNASequence = "";

    # Open the file, read all of the contents into memory, and append them.
    while (my $line = readline($input)) {
        if ($line =~ /\>.*/sx) {
            next;
        }

        $DNASequence = "$DNASequence$line";
    }
    
    # Remove all new lines in the text, resulting in a single continuous
    # sequence of monomers.
    $DNASequence =~ s/\n//mxg;

    # Print the input.
    # print "\n\nText: \n\n$text\n\n";

    # Motif Find in Sequence
    # my $motif = "";
    #
    # Prompt the user for a motif. Exit if nothing submitted.
    # while (1) {
    #     Print("Please enter motif to search for in the sequence: ");
    #     $motif = <STDIN>;
    #     chomp($motif);

    #     if ($motif =~ /([Ee]xit)|([Qq]uit)/gsx || length($motif) == 0) {
    #         last;
    #     }

    #     # Search for the motif.
    #     if ($text =~ /$motif/gsx) {
    #         Print("Motif found\n");
    #     } else {
    #         Print("Motif not found in sequence.\n");
    #     }
    # }

    # Count Monomers
    # Create a copy of the text, remove any characters in the text other than
    # the base pairs (both upper and lower case, just in case), and then call
    # the length function on the resulting string.

    # my $AdeninePairsSeq = $text;
    # $AdeninePairsSeq =~ s/[^Aa]//gsx;
    # my $AdeninePairs = length($AdeninePairsSeq);

    # my $CytosinePairsSeq = $text;
    # $CytosinePairsSeq =~ s/[^Cc]//gsx;
    # my $CytosinePairs = length($CytosinePairsSeq);

    # my $GuaninePairsSeq = $text;
    # $GuaninePairsSeq =~ s/[^Gg]//gsx;
    # my $GuaninePairs = length($GuaninePairsSeq);

    # my $ThyminePairsSeq = $text;
    # $ThyminePairsSeq =~ s/[^Tt]//gsx;
    # my $ThyminePairs = length($ThyminePairsSeq);
    
    my $AdeninePairs  = ($DNASequence =~ tr/A//);
    my $CytosinePairs = ($DNASequence =~ tr/C//);
    my $GuaninePairs  = ($DNASequence =~ tr/G//);
    my $ThyminePairs  = ($DNASequence =~ tr/T//);

    print "Adenine Pairs: $AdeninePairs\n";
    print "Cytosine Pairs: $CytosinePairs\n";
    print "Guanine Pairs: $GuaninePairs\n";
    print "Thymine Pairs: $ThyminePairs\n";

    # Close the input file's file handle.
    close($input) or Print("Error closing file: $input\n");
}


# my @files = @ARGV;

# foreach my $file (@files) {
#     my $filename = "$file";
#     my $inputFile = undef;

#     open($inputFile, "< :encoding(UTF-8)", $filename) or die "[$filename] Failed to open file.\n";

#     my $line = readline($inputFile);

#     print $line;

#     close($inputFile);
# }

# my $file = "$filename";
# my $inputFile = undef;

# open($inputFile, "< :encoding(UTF-8)", $filename) or die "[$filename] Failed to open file.\n";

# my $line = readline($inputFile);

# print $line;

# close($inputFile);
