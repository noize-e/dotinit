#!/bin/bash

project_name="${1:?project name}"
codebase_dir=~/projects/$project_name;

[[ ! -d $codebase_dir ]] && mkdir -p $codebase_dir ;

cd $codebase_dir ;

git init && \

ignore -n && \
  
echo "# $project_name" >> $codebase_dir/README.md && \

if [[ "${2:?type}" == "django-api" ]]; then
printf """\
django
djangorestframework
pyyaml
requests 
django-cors-headers
""" >> $codebase_dir/ requirements.txt

printf """\
# syntax=docker/dockerfile:1
FROM python:3
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
WORKDIR /code
COPY requirements.txt /code/
RUN pip install -r requirements.txt
COPY . /code/
""" >> $codebase_dir/Dockerfile

printf """\
version: "3.9"
   
services:
  db:
    image: postgres
    volumes:
      - ./data/db:/var/lib/postgresql/data
    environment:
      - POSTGRES_DB=postgres
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
  web:
    build: .
    command: python manage.py runserver 0.0.0.0:4000
    volumes:
      - .:/code
    ports:
      - '4000:4000'
    environment:
      - POSTGRES_NAME=postgres
      - POSTGRES_USER=postgres
      - POSTGRES_PASSWORD=postgres
    depends_on:
      - db
""" >> $codebase_dir/docker-compose.yml
fi

git add .;

# https://httpbin.org
#oauth
# Dance
# Grants
# JWT

#API
# Resources
#	Collection:A group of resources
# Actions/Verbs
#	C
# 	R
# 	U
#	D
# Aliases
# 	Use plural nouns: GET /employees
#					  POST /employees
#					  PUT /employees
# Query
# URI Convention