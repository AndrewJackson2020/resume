#!/bin/bash

cli_help () {
	echo "
CLI designed to facilitate resume creation.

Available commandss:
    build_resume
"
}


build_resume () {

	latexmk \
		-aux-directory="temp_latex_files" \
		-output-directory="resume" \
		-pdf \
		./resume/resume.tex

	rm -r temp_latex_files
}


cli () {
	case $1 in

		--build_resume | -b)    
			build_resume 			
			;;

		--help | -h)
			cli_help
			;;

		*)
			echo "unknown command $1"
			cli_help	
			;;
	esac
}

cli "$@"
