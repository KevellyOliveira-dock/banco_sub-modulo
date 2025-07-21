FROM mcr.microsoft.com/mssql/server:2022-latest

USER root

ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=A!ntegr@ti0n_DB4241
ENV MSSQL_PID=Developer

RUN apt-get update && \
    apt-get install -y curl gnupg && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/debian/11/prod.list -o /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update && \
    ACCEPT_EULA=Y apt-get install -y mssql-tools && \
    ln -s /opt/mssql-tools/bin/sqlcmd /usr/bin/sqlcmd && \
    rm -rf /var/lib/apt/lists/*

COPY PIER_BASE_CONTAINER.bak /var/opt/mssql/backup/PIER_BASE_CONTAINER.bak
COPY EMISSOR_BASE_CONTAINER.bak /var/opt/mssql/backup/EMISSOR_BASE_CONTAINER.bak

COPY entrypoint.sh /entrypoint.sh
RUN sed -i 's/\r$//' /entrypoint.sh

RUN chmod +x /entrypoint.sh

USER mssql

CMD ["bash", "/entrypoint.sh"]
