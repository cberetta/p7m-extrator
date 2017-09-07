#!/usr/bin/perl

my $filename_bin  = $ARGV[0];
my $filename_asn1 = $ARGV[1];

# Input
my $filename_in  =  $filename_bin;
# Outptut
my $filename_out =  $filename_asn1;
$filename_out    =~ s/\.(tsd|p7m)\.asn1decoded$//;

my $status="";
my $frombyte=0;
my $totalbytes=0;
while(<>) {

	# OID: 1.2.840.113549.1.9.16.1.31 = TimeStampedData content-type
	if (/OBJECT\s+:1\.2\.840\.113549\.1\.9\.16\.1\.31/) { $status = "TSD_DATA"; }

	# OID: pkcs7-signedData
	if (/OBJECT\s+:pkcs7-signedData/) { $status = "P7M_DATA"; }

	# Find data to extract (next hex-dump data)
	if (/^\s*(\d+):d=\d+\s+hl=(\d+)\s+l=(\d+)\sprim:.*\[HEX DUMP\]:[A-Z0-9]+/) {
		if (($status eq "TSD_DATA") or ($status eq "P7M_DATA")) {
			$frombyte = $1 + $2;
			$totalbytes = $3;
			#print "frombyte......: $frombyte\n";
			#print "totalbytes....: $totalbytes\n";
			#print "filename_bin..: $filename_bin\n";
			#print "filename_asn1.: $filename_asn1\n";
			#print "filename_in...: $filename_in\n";
			#print "filename_out..: $filename_out\n";
			# Use dd to extract data from binary
			`dd if=$filename_in of=$filename_out bs=1 skip=$frombyte count=$totalbytes oflag=append conv=notrunc`;
		}
	} else {
		if ($frombyte != 0) {
			$status="";
			$frombyte=0;
			$totalbytes=0;
		}
	}
}

