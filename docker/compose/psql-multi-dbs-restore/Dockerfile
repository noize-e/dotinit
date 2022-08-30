FROM postgres:13
RUN mkdir /var/lib/postgresql/dumps
COPY dumps /var/lib/postgresql/dumps
ENV POSTGRES_HOST_AUTH_METHOD=trust
ENV POSTGRES_MULTIPLE_DATABASES=dd6
