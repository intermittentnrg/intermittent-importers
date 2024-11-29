FROM ruby:3.3.0-alpine
RUN apk add --no-cache make gcc g++ musl-dev libpq-dev postgresql-client libcurl tzdata git mdbtools-utils ffmpeg

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
