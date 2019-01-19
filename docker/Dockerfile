FROM ruby:2.5

RUN gem install bundler
# throw errors if Gemfile has been modified since Gemfile.lock
# RUN bundle config --global frozen 1
RUN apt-get update -qq && apt-get install -y mysql-client build-essential libpq-dev nodejs imagemagick libreoffice ffmpeg

ADD docker/fits-1.4.0 /
ENV PATH "/fits-1.4.0:$PATH"

ENV BUNDLE_PATH /usr/local/bundle
COPY docker/start-californica.sh /start-californica.sh

CMD ["sh", "/start-californica.sh"]
