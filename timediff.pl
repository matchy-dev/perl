#!/usr/bin/perl

use Time::Local 'timelocal';

sub get_epoch {
	my ( $date, $time ) = split( " ", $_[0] );
	#printf "[%s][%s]\n", $date, $time;
	my ( $year, $mon, $day );
	if( index($date, "/" ) != -1 ){
		#printf "slash![%s]\n", $date;
		( $year, $mon, $day ) = split( "/", $date );
	} else {
		# スラッシュ区切りでない場合はハイフンとみなす
		#printf "haifun![%s]\n", $date;
		( $year, $mon, $day ) = split( "-", $date );
	}
	#printf "[%d]/[%d]/[%d]\n", $year, $mon, $day;
	my ( $hour, $min, $sec ) = split( ":", $time );
	#printf "[%d]:[%d]:[%d]\n", $hour, $min, $sec;
	#printf "%d-%02d-%02d %02d:%02d:%02d->",
		#$year, $mon, $day, $hour, $min, $sec;
	my $itm = timelocal( $sec, $min, $hour, $day, $mon-1, $year-1900 );
	#printf "%d\n", $itm;
	return $itm;
}

sub get_sec {
	my ( $hour, $min, $sec ) = split( ":", $_[0] );
	my $itm = ( ( $hour * 60 ) + $min ) * 60 + $sec;
	#printf "[%d]:[%d]:[%d]->[%d]\n", $hour, $min, $sec, $itm;
	return $itm;
}

sub get_time_str {
	my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime($_[0]);
	my $time_str = sprintf "%d-%02d-%02d %02d:%02d:%02d",
		$year+1900, $mon+1, $mday, $hour, $min, $sec;
	#printf "[%s]\n", $time_str;
	return $time_str;
}

sub time_add {
	my $i_org = get_epoch( $_[0] );
	my $add_sec = get_sec( $_[1] );
	my $res_sec = $i_org + $add_sec;
	return $res_sec;
}

sub time_add_str {
	$res_sec = &time_add( $_[0], $_[1] );
	$out_str = &get_time_str( $res_sec );
	return $out_str;
}

sub diff_time {
	my $itm1 = get_epoch( $_[0] );
	my $itm2 = get_epoch( $_[1] );
	my $diff = $itm2 - $itm1;
	return $diff;
}

sub diff_time_str {
	my $diff_sec = &diff_time( $_[0], $_[1] );
	$sec = $diff_sec % 60;
	$hour = int( $diff_sec / 60 );
	$min = $hour % 60;
	$hour = int( $hour / 60 );
	$out_str = sprintf "%02d:%02d:%02d", $hour, $min, $sec;
	#printf "[%s]\n", $out_str;
	#printf "[%d]->[%d]\n", $diff_sec, &get_sec( $out_str );
	return $out_str;
}

# test code
#my $org_date = "2018/3/18	21:5";
#my $add_date = "1:2:5";
#&time_add_str( $org_date, $add_date );
#$tg_date = "2018-04-20 13:07:05";
#&diff_time_str ( $org_date, $tg_date );
