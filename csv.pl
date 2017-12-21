#!/usr/bin/perl

use Text::ParseWords;

while( <> ){
	~s/\r\n//;
	~s/\n//;

	@data = &parse_line( ",", undef, $_ );
	for($i=0; $i<@data; $i++){
		printf "%d[%s]\n", $i, $data[$i];
	}
}

