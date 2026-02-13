FROM ruby:3.4.7-alpine
RUN apk add --no-cache make gcc g++ musl-dev libpq-dev postgresql-client libcurl tzdata git ffmpeg yaml-dev tesseract-ocr tesseract-ocr-dev imagemagick zlib-dev && \
    wget -O /usr/share/tessdata/jpn.traineddata https://github.com/tesseract-ocr/tessdata_best/raw/main/jpn.traineddata
# alpine tesseract-ocr-data-jpn doesn't parse correctly

WORKDIR /app
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .
