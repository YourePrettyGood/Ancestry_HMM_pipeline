#perl! -w

if(@ARGV<4){
    print "perl run_map_v2.pl read1_list parent1_genome parent2_genome SE_or_PE\n";
}

my $infile1=shift(@ARGV); chomp $infile1;
open IN1, $infile1 or die "cannot open list of reads\n";

my $genome1=shift(@ARGV); chomp $genome1;
my $genome2=shift(@ARGV); chomp $genome2;

my $read_type=shift(@ARGV); chomp $read_type;

open OUT1, ">sam_files_mapped_to_parent1";
open OUT2, ">sam_files_mapped_to_parent2";
while(my $line1 =<IN1>){

    chomp $line1;

    if($read_type eq 'SE'){
    my $sam1 = "$line1".".par1.sam";
    my $sam2 = "$line1".".par2.sam";

    if((! -f $sam1) or (! -f $sam2)){
    my $RG1="'"."\@RG"."\\t"."ID:hyb"."\\t"."SM:tn5"."\\t"."PL:illumina"."\\t"."LB:hyblib1"."\\t"."PU:LSIslowmode"."'";
	#print "$RG1\n";
    system("bwa mem -M -R $RG1 $genome1 -t 3 $line1 > $sam1");
    system("bwa mem -M -R $RG1 $genome2 -t 3 $line1 > $sam2");
    } else{
	print "$sam1 and $sam2 exist, not overwriting\n";
    }

    print OUT1 "$sam1\n";
    print OUT2 "$sam2\n";
    }#SE reads

    if($read_type eq 'PE'){

	my @read_array=split(/\t/,$line1);

	my $read1=$read_array[0]; chomp $read1;
	my $read2=$read_array[1]; chomp $read2;

        my $sam1 = "$read1".".par1.sam";
	my $sam2 = "$read1".".par2.sam";

     if((! -f $sam1) or (! -f $sam2)){
     my $RG1="'"."\@RG"."\\t"."ID:xiphohyb"."\\t"."SM:tn5"."\\t"."PL:illumina"."\\t"."LB:hyblib1"."\\t"."PU:LSIslowmode"."'";
       print "$RG1\n";
       system("bwa mem -M -R $RG1 $genome1 -t 3 $read1 $read2 > $sam1");
       system("bwa mem -M -R $RG1 $genome2 -t 3 $read1 $read2 > $sam2");
    } else{
       print "$sam1 and $sam2 exist, not overwriting\n";
    }

    print OUT1 "$sam1\n";
    print OUT2 "$sam2\n";

    }#PE reads

}#map each read in list

