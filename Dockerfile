FROM ruby:3.0.3-alpine
RUN apk add make gcc musl-dev libpq-dev

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
