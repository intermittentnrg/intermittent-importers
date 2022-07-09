FROM ruby:3.0.3-alpine
RUN apk add --no-cache make gcc musl-dev libpq-dev postgresql-client

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
