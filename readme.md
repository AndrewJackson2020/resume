
# Resume 

## Summary
This repository is used for version controlling and defining my resume in plain text. 
I use LaTeX and more specifically the ModernCV package to do much of the heavy lifting.

## How to use

Command to compile PDF resume from LaTeX configuration.
```bash
./cli.sh build_resume
```

Run in Docker container
```bash
sudo docker build \
    --tag resume \
    .
sudo docker run \
    --volume $(pwd):/root/resume \
   resume  
docker exec -it d2 /bin/bash
```

## Future development
- Possibly to create personal website and add to resume
- Dockerize

