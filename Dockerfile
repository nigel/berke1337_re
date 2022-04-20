# sudo docker build -t system_health_check .
# sudo docker run -d -p 1024:1024 --rm -it system_health_check
FROM ubuntu:latest

RUN apt-get update

RUN useradd -d /home/ctf/ -m -p ctf -s /bin/bash ctf
RUN echo "ctf:ctf" | chpasswd
RUN apt-get install -y gcc gcc-multilib

WORKDIR /home/ctf

COPY ./src/chal1.c .
COPY ./src/chal2.c .
COPY ./src/chal3.c .
COPY ./vuln.c .
RUN gcc -fno-stack-protector -no-pie vuln.c -o vuln-64
RUN chmod +x ./vuln-64

COPY ./vuln-64 .

RUN gcc -m32 chal1.c -o chal1 -fno-stack-protector -g
RUN gcc -m32 chal2.c -o chal2 -fno-stack-protector -g
RUN gcc -m32 chal3.c -o chal3 -fno-stack-protector -g

RUN rm chal1.c
RUN rm chal2.c
RUN rm chal3.c

USER ctf
CMD ["/bin/bash"]
