#!/usr/bin/env perl
use strict;
use warnings;

# 
# Usage: Order the Blocks in XMFA file into FASTA format by the specified refrence strain (with closed genome)

# Input: XMFA files 

# Output:

# Assumption:
#  All genomes are present in each block in XMFA [core]


my $out = my $in = shift @ARGV;
$out =~ s/\.xmfa//;
$out = $out."_order.xmfa";

my $order_strain = "xm-d-517";
my %order_seq = ();

open(IN_F, "<", $in) or die "$in\n";
open(OUT_F, ">", $out) or die "$out\n";

my %seqs = ();

## SET custom input separator
# Read each block 
$/ = "=\n";

my $header = "";
my $strain = "";
my $start = 0;
my $each_seq = "";

while (<IN_F>) {
    chomp;
    my @lines = split /\n/;
    foreach my $e (@lines) {
	# remove the header in XMFA
	if ($e =~ /^#/) {
	    next;
	} elsif ($e =~ /^>\s\d+:(\d+)-\d+\s[-+]\s\S+\/(\S+?)\.\S+/) {
	    #> 1:2160262-2170569 - final/xm-a-104.fna
#	} elsif ($e =~ /^>\d+\|(\S+)\|(\d+)\.\.\d+\|[-+]/) {
	    #>1|xm-a-104|1864783..2320561|-
	    if ($start) {
		push( @{ $seqs{$strain} }, join("\n", $header, $each_seq) );
		if ($strain eq $order_strain) {
		    $order_seq{$start} = join("\n", $header, $each_seq);

		}
		$each_seq = "";
	    }
	    $strain = $2;
	    $start = $1;
	    print $start."\n";;
	    $header= $e;

	} else {
	    $each_seq .= $e;
	}
    }
}
# The seqeuence of the last strain
push( @{ $seqs{$strain} }, join("\n", $header, $each_seq) );
if ($strain eq $order_strain) {
    $order_seq{$start} = join("\n", $header, $each_seq);
} 
close IN_F;

## Capture the sorted index based on the specified reference strain
my @unsorted = @{ $seqs{$order_strain} };
my @order_idx = ();

foreach my $f ( sort { $a <=> $b } keys %order_seq ) {
    foreach my $i ( 0..$#unsorted ) {
	if ($unsorted[$i] ne $order_seq{$f}) {
	    next;
	} else {
	    push @order_idx, $i;
	    last;
	}
    }
}


##### XMFA
# get the number of block (minus 1)
my $block = $#order_idx;
foreach my $i (0 .. $block) {
    foreach my $k (sort( keys %seqs)) {
	my @temp_strain_seqs = @{ $seqs{$k} };
	my @ordered = @temp_strain_seqs[@order_idx];

	print OUT_F $ordered[$i], "\n";
    }
    print OUT_F "=", "\n";
}

close OUT_F;
