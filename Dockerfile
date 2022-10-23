FROM ruby:3.0.4-alpine
RUN apk add --no-cache make gcc musl-dev libpq-dev postgresql-client libcurl tzdata

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
