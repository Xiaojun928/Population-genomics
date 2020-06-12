#!/usr/bin/perl -w

open OUT, ">dS_summary.txt";
print OUT "famid";
open IN, "dNdS/OG0000022.dNdS" || die "$!";
while(<IN>)
{
 next if(/gene/);
 my @a=split(/\t/);
 print OUT "\t$a[0]__$a[1]";
}
print OUT "\n";
close IN;

my @list = `ls dNdS/*dNdS`;
foreach my $file (@list)
{
        chomp $file;
        my ($famid)=$file=~/dNdS\/(\S+).dNdS/;
	print OUT $famid;
        open IN, $file || die "can't open $!";
        while(<IN>)
        {chomp;
         next if(/gene/);
         my @a=split(/\t/);
	 print OUT "\t$a[5]";
        }
	print OUT "\n";
        close IN;
}
close OUT;
