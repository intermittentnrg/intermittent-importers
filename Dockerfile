FROM ruby:3.2.2-alpine
RUN apk add --no-cache make gcc g++ musl-dev libpq-dev postgresql-client libcurl tzdata

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
