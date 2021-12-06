FROM ruby:3.0.3

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
