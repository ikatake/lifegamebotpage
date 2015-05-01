#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "/home/ikatake/local/twlg/extlib/lib/perl5", "home/ikatake/local/twlg/extlib/lib/perl5/i386-freebsd-64int";
use CGI;
use JSON;

my $q = new CGI;
my $counter = $q->param('param');
my $state_str = "";
my $fname = "/home/ikatake/local/twlg/state.txt";
my $str = "";
my $step = 0;
my $gene = 0;
my $data;

open( my $fh, "<", $fname )
        or die "Cannot open $fname: $!";
while( my $line = readline($fh))
{
#        $line = decode( 'UTF-8', $line);
	my @column = split(/\t/, $line);
	if( $#column != 1 )
	{#状態の読込み
		$state_str .= $line;
	}	
	elsif( $column[0] eq 'step' )
	{
		$step = int($column[1]);
	}
	elsif( $column[0] eq 'gene' )
	{
		$gene = int($column[1]);
	}			
}
close $fh;

#世代交代時(status.txtが空でない)はstepを1個引く。
if(-s "/home/ikatake/local/twlg/status.txt"){
	$step--;
}

$data = {
	gene => $gene,
	step => $step,
	state => $state_str,
};
#foreach my $tmp( @array ) {
#	foreach my $key( keys %$tmp ) {
#		print "Key = $key Value = $tmp->{$key} \n";
#	}
#}

print "Content-type: application/json; charset=utf-8\n\n";
#print $q->header(-type =>'text/plain');
#print $state_str;
print encode_json( $data );
#print time .'+++'.$counter;
#print $str;

