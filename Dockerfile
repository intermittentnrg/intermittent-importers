FROM ruby:3.3.0-alpine
RUN apk add --no-cache make gcc g++ musl-dev libpq-dev postgresql-client libcurl tzdata git

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
