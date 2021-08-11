#!/usr/bin/perl -w 

#######################
#Input1: core genome alignments
#Output: SNP position within or between clades and bases
#Usage: ./s1.SNP_density_pre.pl roseo_core_500_sorted.xmfa
#Get SNP position. Note that the strand of ref strains matters a lot !!!
#transform the position when the negative strand of ref is used!!!
#because the recombined regions will be mapped later
#######################

my $in1 = $ARGV[0];

##2. get the LCBs and corresponding sequences
my %LCB_hash; #indexed with LCB id, pointed to a inner hash (indexed with > title, pointed to sequence)
my %LCB_pos; ##indexed with LCB id, pointed to d-517 position
my %LCB_id2pos; ##indexed with LCB id, pointed to d-517 position
my %heads;  ##indexed with LCB id, pointed to an array of heads
my $ref_strain = "xm-d-517";
my $id = 1;
my $title;
my $gnm;
my @genomes; ##array of strain name in xmfa, same order with xmfa
open IN1,"$in1" || die "$!";
while(<IN1>)
{
        chomp;
        if (/#/)
	{next;}
        if(/>/)
        {
			$title = $_;
			($gnm) = $title =~ /\S+\/(\S+)\.fna/;
			push @genomes, $gnm;
			push @{$heads{$id}}, $title;
			if($gnm eq $ref_strain)
			{
				#my ($pos) = $_ =~ /\d+:(\d+\-\d+) \S/;
				my ($pos) = $_ =~ /\d+:(\d+\-\d+ [+-])/; ##the strand of refrence should be considered
				$LCB_pos{$id} = $pos;
			}
		}
        elsif($_ !~ /=/)
		{$LCB_hash{$id}{$gnm} .= $_;}
        elsif(/=/)  ##the next block will start
        {$id ++;}
}
close IN1;



open OUT,">SNP_pos_base.txt";
open OUT1,">C1_SNP_pos.txt";
open OUT2,">C2_SNP_pos.txt";
open OUT3,">C1C2_SNP_pos.txt";
my @snp_pos1; ## positions of SNPs caused by C1 strains
my @snp_pos2; ## positions of SNPs caused by C2 strains
my @snp_pos3; ## positions of SNPs caused by C1 & C2 intergration
##5. find homoplasious SNPs for each LCBs, and delete homoplasious SNP sites
foreach my $id (keys %LCB_hash)
{
	my $pos_d_517 = $LCB_pos{$id};
	my ($wgastart,$wgaend,$strand) = $pos_d_517 =~ /(\d+)-(\d+) ([+-])/;
	##transform the aln sites into string, and store this string into hash
	my @aln; ##indexed with position of sites, pointed to a string of sites for all aligned genome at that position
	my %lcb2wga;  ##indexed with the lcb position (local), pointed to wga position (universal)
	foreach my $gnm (sort(keys %{$LCB_hash{$id}})) ##gnm order is the same with the xmfa file
	{
		my @seq = split(//,$LCB_hash{$id}{$gnm});
		for(my $i=0;$i<=$#seq;$i++)  
		{
		 $aln[$i] .= $seq[$i];
		 if(($gnm eq $ref_strain)  & ($aln[$i] =~ /-/))  ##ref strain has a gap there 
		 {
			$lcb2wga{$i} = "";
		 }
		 elsif(($gnm eq $ref_strain)  & ($aln[$i] !~ /-/)){  #no gap at ref strain
		  if($strand eq "+") #the strand of ref strain matters a lot!!!
		   {
		    $wgastart++;
		    $lcb2wga{$i} = $wgastart;
		   }
		  if($strand eq "-")
		   {
		    $wgaend--;
		    $lcb2wga{$i} = $wgaend;
		   }
		 }
		}
	}
	
	for(my $i=0;$i<=$#aln;$i++)
	{
		if($aln[$i] !~ /-/) ## no gaps are found in other strains
		{
		  my @arr = split(//,$aln[$i]);
		  ## for C1 strains
		  my %h1;
                  my @unique1 = grep { !$h1{$_}++ } @arr[2,3,7];
                  if(@unique1 >= 2)
                  {
                        push @snp_pos1, $lcb2wga{$i};
                  }

		  ## for C2 strains
                  my %h2;
                  my @unique2 = grep { !$h2{$_}++ } @arr[0,1,4..6,8..15];
                  if(@unique2 >= 2)
                  {
                        push @snp_pos2, $lcb2wga{$i};
                  }
		
		  ##for C1 & C2 strains
		  my %seen;
		  my @unique = grep { !$seen{$_}++ } @arr;
		  if(@unique >= 2)
		  {
			push @snp_pos3, $lcb2wga{$i};
			print OUT $lcb2wga{$i}."\t".$aln[$i]."\n";
		  }
		}
	}
	

}


foreach my $j (sort {$a<=>$b} @snp_pos1) 
{
    print OUT1 $j."\n";
}

foreach my $j (sort {$a<=>$b} @snp_pos2) 
{
    print OUT2 $j."\n";
}

foreach my $j (sort {$a<=>$b} @snp_pos3) 
{
    print OUT3 $j."\n";
}

close OUT;
close OUT1;
close OUT2;
close OUT3;
