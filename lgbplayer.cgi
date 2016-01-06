#!/usr/bin/perl

use strict;
use warnings;
use FindBin;
use lib "/home/ikatake/local/twlg/extlib/lib/perl5", "home/ikatake/local/twlg/extlib/lib/perl5/i386-freebsd-64int";
use CGI;
use JSON;

my $q = new CGI;
my $call = $q->param('call');

if($call eq 'reload') {
	&reload();
}
elsif($call eq 'jump') {
	my $gene = $q->param('gene');
	my $step = $q->param('step');
	&jump($gene, $step);
}
elsif($call eq 'measure') {
	&measure();
}

sub reload {
	my $data = &load_current();
	print "Content-type: application/json; charset=utf-8\n\n";
	print encode_json( $data );
}
sub jump {
	my $state_str = "";
	my $fname = '/home/ikatake/www/wetsteam/lifegamebot/stateLogs/';
	my $str = "";
	my $step = 0;
	my $gene = 0;
	my $data;
	$fname .= sprintf("%08d",$_[0]). "/";
	$fname .= sprintf("%08d",$_[1]). ".txt";
	print $fname;
	if(!(-e $fname)) { #file is not exist.
		for(my $ii = 0; $ii < 10; $ii++) {
			$state_str .= "1111111111\n";
		}
		$data = {gene => -1, step => -1,state => $state_str,};
		print "Content-type: application/json; charset=utf-8\n\n";
		print encode_json( $data );
		return;
	}
	open( my $fh, "<", $fname )
        	or die "Cannot open $fname: $!";
	while( my $line = readline($fh)) {
#	        $line = decode( 'UTF-8', $line);
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

	$data = {
		gene => $gene,
		step => $step,
		state => $state_str,
	};

	print "Content-type: application/json; charset=utf-8\n\n";
	print encode_json( $data );
}
sub measure {
	my $state_str = "";
	my $fname = "/home/ikatake/local/twlg/state.txt";
	my $step = 0;
	my $gene = 0;
	my @arlen = ();
	my $bdname = '/home/ikatake/www/wetsteam/lifegamebot/stateLogs/';
	my $dname = "";
	my $str = "";
	my @directory;
	my %hash;
	my $data = &load_current();
	$gene = $data->{gene};
	$step = $data->{step};
	
	for(my $ii = 1; $ii <= $gene; $ii++) {
		my $len;
		$dname = $bdname . sprintf("%08d",$ii) . '/';
		if(!(-e $dname)) { #file is not exist.
			$len = -1;
		}
		else {
			opendir(my $dh, $dname) or die "$dname:$!";
			@directory = grep {/\.txt$/} readdir($dh);
			closedir($dh);
			$len = @directory;
		}
		my %hash = ('gene' => $ii, 'length' => $len);
		push(@arlen, \%hash );
	}
	foreach my $tmp(@arlen) {
		foreach my $key(keys %$tmp) {
	#		print "key = $key Value = $tmp->{$key} \n";
		}
	}
	print "Content-type: application/json; charset=utf-8\n\n";
	print encode_json( \@arlen );
}
sub load_current {
	my $state_str = "";
	my $fname = "/home/ikatake/local/twlg/state.txt";
	my $str = "";
	my $step = 0;
	my $gene = 0;
	my $data;
	open( my $fh, "<", $fname )
        	or die "Cannot open $fname: $!";
	while( my $line = readline($fh)) {
#	        $line = decode( 'UTF-8', $line);
		my @column = split(/\t/, $line);
		if( $#column != 1 ) {#状態の読込み
			$state_str .= $line;
		}	
		elsif( $column[0] eq 'step' ) {
			$step = int($column[1]);
		}
		elsif( $column[0] eq 'gene' ) {
			$gene = int($column[1]);
		}			
	}
	close $fh;

	#世代交代時(status.txtが空でない)はstepを1個引く。
	if(-s "/home/ikatake/local/twlg/status.txt") {
		$step--;
	}
	
	$data = {
		gene => $gene,
		step => $step,
		state => $state_str,
	};
	return $data;
}	
