#!/usr/bin/env perl
use strict;
use warnings;

# 
# Usage: sort the Blocks in XMFA file by the specified refrence strain (with closed genome)

# Input: XMFA files 

# Output: ordered XMFA file

# prerequisite:
#  All genomes are present in each block in XMFA [core]


my $out = my $in = shift @ARGV;
$out =~ s/\.xmfa//;
$out = $out."_sorted.xmfa";

my $ref_strain = "xm-d-517";
my %order_seq = ();

open(IN_F, "<", $in) or die "$in\n";
open(OUT_F, ">", $out) or die "$out\n";

my %LCB_hash; #indexed with LCB id, pointed to a inner hash (indexed with > title, pointed to sequence)
my %LCB_pos; ##indexed with ref strain satrt position, pointed to LCB id
my %heads;  ##indexed with LCB id, pointed to an array of heads
my $id = 1;
my $title;
my $gnm;
while(<IN_F>)
{
        chomp;
        if (/#/)
		{
			print OUT_F $_."\n"; 
			next;
		}
        if(/>/)
        	{
			$title = $_;
			($gnm) = $title =~ /(\S+)\.fna/;
			#($gnm) = $title =~ /\S+\/(\S+)\.fna/;
			push @{$heads{$id}}, $title;  ## to ensure the genome order in each LCB is same as the original xmfa
			if($gnm eq $ref_strain)
			{
				my ($start) = $_ =~ /\d+:(\d+)\-\d+ \S/;
				$LCB_pos{$start} = $id;
			}
		}
        elsif($_ !~ /=/)
        #{$LCB_hash{$id}{$title} .= $_;}
        {$LCB_hash{$id}{$gnm} .= $_;}
        elsif(/=/)  ##the next block will start
        {$id ++;}
}
close IN_F;

foreach my $start ( sort { $a <=> $b } keys %LCB_pos )
{
	my $id = $LCB_pos{$start};
	my $j=0;
	foreach my $gnm (sort(keys %{$LCB_hash{$id}}))
	{
		print OUT_F $heads{$id}[$j]."\n".$LCB_hash{$id}{$gnm}."\n";
		$j ++;
	}
	print OUT_F "=\n";
}

close OUT_F;
