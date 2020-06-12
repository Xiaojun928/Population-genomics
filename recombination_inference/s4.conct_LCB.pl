#!/usr/bin/perl -w 

#######################
#Input: core genome alignments
#Output: concatenated core genome alignments orderd in reference genome
#Usage: ./s4.conct_LCB.pl core_500_sorted.xmfa
#######################

my $in1 = $ARGV[0];

my %LCB_hash; #indexed with gnm, pointed to concatenated sequences

my $gnm;
my @genomes; ##array of strain name in xmfa, same order with xmfa
open OUT,">concate_coreLCB.fasta";
open IN2,"$in1" || die "$!";
while(<IN2>)
{
        chomp;
        if (/#/)
		{
			next;
		}
        if(/>/)
        {
			$title = $_;
			($gnm) = $title =~ /\S+\/(\S+)\.fna/;
		}
        elsif($_ !~ /=/)
		{$LCB_hash{$gnm} .= $_;}
        elsif(/=/)  ##the next block will start
        {next;}
}
close IN2;

foreach(sort(keys %LCB_hash))
{
	print OUT ">".$_."\n".$LCB_hash{$_}."\n";
}
close OUT;
