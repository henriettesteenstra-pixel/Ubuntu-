FROM ubuntu:24.04

ENV PORT=7681
ENV DEBIAN_FRONTEND=noninteractive

# Step 1: Base packages + Universe repo enable karo
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates wget curl git python3 python3-pip software-properties-common \
    && add-apt-repository universe \
    && apt-get update

# Step 2: Ab tini aur fastfetch install karo (ab yeh universe mein available hai)
RUN apt-get install -y --no-install-recommends tini fastfetch

# Step 3: Ttyd install (same as before)
RUN wget -qO /usr/local/bin/ttyd \
    https://github.com/tsl0922/ttyd/releases/latest/download/ttyd.x86_64 \
    && chmod +x /usr/local/bin/ttyd

# Step 4: Bash profile mein fastfetch daalo
RUN echo "fastfetch || true" >> /root/.bashrc

EXPOSE 7681

ENTRYPOINT ["/usr/bin/tini","--"]
CMD ["/bin/bash","-lc","/usr/local/bin/ttyd --writable -i 0.0.0.0 -p ${PORT} -c ${USERNAME}:${PASSWORD} /bin/bash"]
