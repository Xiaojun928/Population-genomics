#!/usr/bin/perl -w
##As the input of cfml is a concatenated WGA of all core LCB,
##the inferred reombination regions is coordinated with local concatenated WGA.
##When mapping refcombination regions to the ref genome, positions need 
##to be transformed.
#1. Transform ref pos to local WGA pos, gaps in ref LCB should not be ignored

open OUT,">localpos_concate_LCB.txt";
open IN,"pos_coreLCB2ref.txt" || die "can't open $!";
<IN>;
my $line1 = <IN>;
chomp $line1;
my ($start,$end,$len_w_gap) = $line1 =~ /(\d+)\t(\d+)\t(\d+)/;
if($len_w_gap == ($end - $start + 1))
 {print OUT $start."\t".$end."\n";}
else{print OUT $start."\t".$len_w_gap."\n";}

my $end_local;
while(<IN>)
{
	chomp;
	my @a = split(/\t/,$_);
	my $start_local = $end + 1;
	my $len_wo_gap = $a[1] - $a[0] + 1;
	$len_w_gap = $a[2];
	if($len_wo_gap == $len_w_gap)
	{
	  $end_local = $a[1] - $a[0] + $start_local;
	  $end = $end_local;
	}
	if($len_wo_gap != $len_w_gap)
	{
          $end_local = $a[1] - $a[0] + $start_local + ($len_w_gap - $len_wo_gap);
          $end = $end_local;
	}

	print OUT $start_local."\t".$end_local."\n";
}
close IN;
close OUT;
