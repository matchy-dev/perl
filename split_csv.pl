#!/usr/bin/perl

sub split_csv{
	my $line = @_[0];
	my $len, $st, $before, $ch, $dq_flg, $cut_str, @out;
	$len = length($line);
	$st = 0;
	$dq_flg = 0;
	@out = ();

	for(my $i=0; $i<$len; $i++){
		$ch = substr($line, $i, 1);
		#printf "%d[%s]", $i, $ch;

		if( $ch eq "," ){
			if( ! $dq_flg ){
				$cut_str = substr($line, $st, ($i-$st));
				$cut_str =~ s/^"//;
				$cut_str =~ s/"$//;
				#printf "CUT:[%s]", $cut_str;
				push( @out, $cut_str );
				$st = $i+1;
			}
			#printf "comma";
		}
		if( $ch eq "\"" ){
			if( $dq_flg ){
				$dq_flg = 0;
			} else {
				$dq_flg = 1;
			}
			#printf "dq[%d]", $dq_flg;
		}
		#printf "\n";
		$before = $ch;
	}
	$cut_str = substr($line, $st);
	$cut_str =~ s/^"//;
	$cut_str =~ s/"$//;
	#printf "CUT:[%s]\n", $cut_str;
	push( @out, $cut_str );
	return @out;
}

sub make_csv_str {
	my @data = @_;
	my $cell_data, $line;
	for( my $i=0; $i<@data; $i++ ){
		$cell_data = $data[$i];
		if( $cell_data =~ /,/ ){
			$cell_data = "\"" . $cell_data . "\"";
		}
		if( $i == 0 ){
			$line = $cell_data;
		} else {
			$line = $line . "," . $cell_data;
		}
	}
	return $line;
}

@test_data = (	"1,\"test\",\"cma,cma2\",日本語,a,,,b",
		"1,\"test\",\"cma,cma2\",日本語,a,,,"  );

foreach $line ( @test_data ){
	printf "######\n";
	printf "IN:[%s]\n", $line;
	@data = &split_csv( $line );
	printf "######\n";
	for( my $i=0; $i<@data; $i++ ){
		printf "%d[%s]\n", $i, $data[$i];
	}
	printf "######\n";
	printf "OUT[%s]\n", &make_csv_str( @data );
	printf "######\n";
}

1;

