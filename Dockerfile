FROM debian:testing-20240612-slim

VOLUME /app
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8
RUN apt-get update && apt-get upgrade -y curl && apt-get install -y gnupg
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 843C48A565F8F04B
RUN wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | gpg --dearmor | tee /etc/apt/trusted.gpg.d/adoptium.gpg > /dev/null
RUN echo "deb https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
RUN apt update && apt install -y temurin-21-jdk && apt-get clean
WORKDIR /app
RUN echo 'java -Xms4G -Xmx4G -jar paper.jar --nogui' > start.sh
RUN chmod +x /app/start.sh
CMD ["/bin/bash", "-c", "/app/start.sh"]
EXPOSE 25565
EXPOSE 8123
EXPOSE 19132