FROM ruby:2.7.4

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
