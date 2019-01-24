FROM ruby:2.5

RUN gem install bundler
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1
RUN apt-get update -qq && apt-get install -y mysql-client build-essential libpq-dev nodejs imagemagick libreoffice ffmpeg unzip

RUN mkdir /fits
WORKDIR /fits
COPY https://github.com/harvard-lts/fits/releases/download/1.4.0/fits-1.4.0.zip /fits/
RUN unzip fits-1.4.0.zip -d /fits
ENV PATH "/fits:$PATH"

ENV BUNDLE_PATH /usr/local/bundle
COPY docker/start-californica.sh /start-californica.sh

WORKDIR /californica
CMD ["sh", "/start-californica.sh"]
