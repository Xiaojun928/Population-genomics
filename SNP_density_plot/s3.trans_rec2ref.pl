#!/usr/bin/perl -w

##transform the recombination regions of cfml into ref genomic pos
##!!!! recregions across >2 LCBs, manually transition !!!!!###
##!!!! recregions in negative ref strands, manually transition !!!!!###

open RE,"recombined_regions.txt";
open OUT,"> rec_ref_pos.txt";
while(<RE>)
{
  chomp;
  print OUT $_;
  my @a = split(/\t/);
  	open MP,"pos_mapping.txt";
	<MP>;
	while(my $line = <MP>)
	 {
		chomp $line;
		my @b = split(/\t/,$line);
		if ($a[0] <= $b[1] && $a[0] >= $b[0])
		{
			my $ref_start = $a[0] - $b[0] + $b[2];
			print OUT "\t".$ref_start;
		}
                if ($a[1] <= $b[1] && $a[1] >= $b[0])
                {
                        my $ref_end = $a[1] - $b[0] + $b[2];
			print OUT "\t".$ref_end."\n";
                }
	 }
	close MP;
	
}

close RE;
close OUT;
