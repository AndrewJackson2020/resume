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

	resume_type=software
	
	for i in "$@"
	do
		case $i in
			-t=*|--resume_type=*)
				resume_type="${i#*=}"
				;;
			-p=*|--phone=*)
				phone_number="${i#*=}"
				;;
			-c=*|--city=*)
				city="${i#*=}"
				;;
			-z=*|--z=*)
				zip_code="${i#*=}"
				;;
			-*|--*)
				exit 1
				;;
			*)
				exit 1
				;;
		esac
	done

	mkdir --parents ./temp
	rm ./variables.tex
	touch ./variables.tex
	cat << EOF > ./variables.tex
\\newcommand{\\resumeType}{${resume_type}}
\\newcommand{\\phoneVar}{${phone_number}}
\\newcommand{\\homeTownVar}{${city}}
\\newcommand{\\homeZipCodeVar}{${zip_code}}
EOF
	pdflatex \
		-output-dir "temp" \
		./resume.tex

	mv ./temp/resume.pdf ./
	rm -r ./temp
	rm ./variables.tex
}


cli () {
	case $1 in

		build_resume)    
			build_resume "${@:2}"
			;;

		build_resume_docker)
			build_resume_docker "$@"
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
