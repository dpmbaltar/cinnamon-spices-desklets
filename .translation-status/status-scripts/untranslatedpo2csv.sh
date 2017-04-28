#!/bin/bash

cd ..

# Which spices? Get spices name
parentDirName=$(basename -- "$(dirname -- "$(pwd)")")
spices=$(echo "$parentDirName" | cut -f3 -d '-')
Spices=( $spices )
Spices="${Spices[@]^}" # first letter uppercase

# known language IDs and language names
knownLanguageIDs=status-scripts/Language-IDs.txt

spicesStatusDir=$spices-status

for spicesUUIDdir in $spicesStatusDir/*
do

	# if untranslatedDir is not empty
	untranslatedDir=$spicesUUIDdir/untranslated-po
	if [ "$(ls -A $untranslatedDir)" ]; then
		for poFile in $untranslatedDir/*.po
		do
			# get languageID
			languageID=$(echo "$poFile" | cut -f4 -d '/' | cut -f1 -d '.')
			spicesUUID=$(echo "$spicesUUIDdir" | cut -f2 -d '/')
			languageNAME=$(grep "$languageID:" $knownLanguageIDs | cut -f2 -d ':')
			
			# convert
			po2csv --columnorder=source,target $poFile $untranslatedDir/$languageID.csv
			
			# delete untranslated-po files
			rm $untranslatedDir/$languageID.po
		done
	fi

done

echo ""
echo "untranslated-po files converted to csv files"
echo ""
