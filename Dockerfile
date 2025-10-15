FROM ruby:3.4.7-alpine
RUN apk add --no-cache make gcc g++ musl-dev libpq-dev postgresql-client libcurl tzdata git mdbtools-utils ffmpeg yaml-dev

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
