
FROM archlinux:latest
RUN pacman --noconfirm -Syu
RUN pacman --noconfirm -Sg texlive 
RUN pacman --noconfirm -S reflector 
RUN reflector \
	--verbose \
	--country 'United states' \
	-l 5 \
	--sort rate \
	--save /etc/pacman.d/mirrorlist

RUN pacman \
	--noconfirm \
	-S \
	perl \
	texlive-binextra \
	texlive-bin \
	texlive-basic \
	texlive-latexextra \
	texlive-latexrecommended \
	texlive-fontsextra \
	texlive-fontsrecommended

WORKDIR /root/resume
ENTRYPOINT ["/bin/bash", "./cli.sh", "-b"]
