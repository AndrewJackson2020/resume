#!/bin/bash

cli_help () {
	echo "
CLI designed to facilitate resume creation.

Available commands:
    --build_resume | -b
	--build_resume_doocker | -bd
"
}


build_resume_docker () {

	sudo docker build \
		--tag resume \
		.

	sudo docker run \
		-it \
		--volume $(pwd):/root/resume \
	   resume  
}


build_resume () {

	pdflatex \
		-output-dir "output" \
		"\\def\\whatever{financial}  \\input{resume.tex}"

}


cli () {
	case $1 in

		--build_resume | -b)    
			build_resume 			
			# build_resume_pdf 
			;;

		--build_resume_docker | -bd)
			build_resume_docker 
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
