#!/bin/bash

# Source:
# http://tldp.org/LDP/abs/html/string-manipulation.html#SUBSTRREPL00

# Get filename from command line
FILE="$1"

# Sometimes the file extensions are incorrect
if [ ${FILE: -8} == ".pdf.tsd" ]
then
	echo "renaming file .pdf.tsd => .pdf.p7m.tsd"
	mv ${FILE} ${FILE/.pdf.tsd/.pdf.p7m.tsd}
	FILE=${FILE/.pdf.tsd/.pdf.p7m.tsd}
fi

# Decode .tsd
if [ ${FILE: -4} == ".tsd" ]
then
	# Decode TSD file
	echo "asn1 decoding [tsd]..."
	openssl.exe asn1parse -in ${FILE} -inform DER -i > ${FILE}.asn1decoded

	# Extract p7m from decoded asn1
	echo "extracting p7m from tsd..."
	perl extract-from-asn1.pl ${FILE} ${FILE}.asn1decoded

	# Remove temporary files
	echo "removing temp files..."
	rm ${FILE}.asn1decoded

	# Change FILE variable to simulate that it was called as .p7m
	FILE="${FILE/%.tsd/}"
fi

# Decode .p7m
if [ ${FILE: -4} == ".p7m" ]
then
	# Decode TSD file
	echo "asn1 decoding [p7m]..."
	openssl.exe asn1parse -in ${FILE} -inform DER -i > ${FILE}.asn1decoded

	# Extract p7m dump from decoded asn1
	echo "extracting pdf from p7m..."
	perl extract-from-asn1.pl ${FILE} ${FILE}.asn1decoded

	# Remove temporary files
	echo "removing temp files..."
	rm ${FILE}.asn1decoded

fi

