FROM centos:centos7

LABEL maintainer="Bruno Rossi <brunorossiweb@gmail.com>"
LABEL service="NGMC"
LABEL version="0.1"

ARG GITHUB_ACCESS_TOKEN
ENV GITHUB_ACCESS_TOKEN ${GITHUB_ACCESS_TOKEN}

ARG CONTENTFUL_ACCESS_TOKEN
ENV CONTENTFUL_ACCESS_TOKEN ${CONTENTFUL_ACCESS_TOKEN}

ARG NETLIFY_ACCESS_TOKEN
ENV NETLIFY_ACCESS_TOKEN ${NETLIFY_ACCESS_TOKEN}

ARG PROJECT_NAME
ENV PROJECT_NAME ${PROJECT_NAME:-ngmc_blog}

ARG PROJECT_FOLDER
ENV PROJECT_FOLDER ${PROJECT_FOLDER:-ngmc_blog}

ARG PROJECT_DESCRIPTION
ENV PROJECT_DESCRIPTION ${PROJECT_DESCRIPTION:-A blog based on NGMC stack}

ARG GITHUB_FIRST_COMMIT_MESSAGE
ENV GITHUB_FIRST_COMMIT_MESSAGE ${GITHUB_FIRST_COMMIT_MESSAGE:-First Commit}

ARG THEME_DIR_NAME
ENV THEME_DIR_NAME ${THEME_DIR_NAME:-attila}

ARG CONTENTFUL_SPACE_NAME
ENV CONTENTFUL_SPACE_NAME ${CONTENTFUL_SPACE_NAME:-ngmc_blog}

ARG CONTENTFUL_LOCALE
ENV CONTENTFUL_LOCALE ${CONTENTFUL_LOCALE:-en-US}

ARG WEB_SITE_TITLE
ENV WEB_SITE_TITLE ${WEB_SITE_TITLE:-my_website}

ARG WEB_SITE_DESCRIPTION
ENV WEB_SITE_DESCRIPTION ${WEB_SITE_DESCRIPTION:-my_website}

ARG WEB_SITE_URL
ENV WEB_SITE_URL ${WEB_SITE_URL}

ARG WEB_SITE_KEYWORDS
ENV WEB_SITE_KEYWORDS ${WEB_SITE_KEYWORDS}

ARG WEB_SITE_AUTHOR
ENV WEB_SITE_AUTHOR ${WEB_SITE_AUTHOR}

ARG WEB_SITE_EMAIL
ENV WEB_SITE_EMAIL ${WEB_SITE_EMAIL}

ARG LOCAL_WEB_SERVER_DEPLOY_FOLDER
ENV LOCAL_WEB_SERVER_DEPLOY_FOLDER ${LOCAL_WEB_SERVER_DEPLOY_FOLDER}

ARG GITHUB_FULL_NAME
ENV GITHUB_FULL_NAME ${GITHUB_FULL_NAME}

ARG GITHUB_EMAIL
ENV GITHUB_EMAIL ${GITHUB_EMAIL}

ARG GITHUB_USERNAME
ENV GITHUB_USERNAME ${GITHUB_USERNAME}

ARG GITHUB_PASSWORD
ENV GITHUB_PASSWORD ${GITHUB_PASSWORD}

RUN yum -y update
RUN yum -y install dos2unix git epel-release
RUN yum -y install nodejs jq

WORKDIR /opt

COPY install.sh install.sh

RUN chmod u+x install.sh && dos2unix install.sh && ./install.sh

WORKDIR $PROJECT_FOLDER
