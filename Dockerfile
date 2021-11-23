FROM ruby:2.7.4

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
