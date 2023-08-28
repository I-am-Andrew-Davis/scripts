#!/bin/bash
# Creator: Andrew Davis
# Last updated: 03-15-22
# purpose: moves designated files to ~/trash

while getopts 'r d' OPTION; do
	case "$OPTION" in
	 r)
		rm -rf ~/trash/*
		;;
	 d)
		mv ~/Downloads/* ~/trash/
		;;
	esac
done

if (($OPTIND == 1 )); then
	outputFile=$1;
	mv $outputFile "$@" ~/trash;
fi
