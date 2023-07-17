FROM alpine:3.14
RUN apk add --no-cache texlive
ENTRYPOINT ["/bin/bash"]


