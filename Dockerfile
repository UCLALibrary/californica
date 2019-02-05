FROM ruby:2.5

# Install fits
RUN mkdir /fits
WORKDIR /fits
ADD https://github.com/harvard-lts/fits/releases/download/1.4.0/fits-1.4.0.zip /fits/
RUN unzip fits-1.4.0.zip -d /fits
ENV PATH "/fits:$PATH"

# Install system dependencies
RUN apt-get update -qq && apt-get install -y mysql-client build-essential libpq-dev nodejs imagemagick libreoffice ffmpeg unzip

# Set up user
# RUN groupadd -r --gid 3000 docker && \
#   useradd -r --uid 3000 --gid 3000 docker
# RUN mkdir /home/docker
# RUN chown docker:docker /home/docker
# USER docker

# Install Ruby Gems
RUN gem install bundler
ENV BUNDLE_PATH /usr/local/bundle
WORKDIR /californica
COPY Gemfile /californica/Gemfile
COPY Gemfile.lock /californica/Gemfile.lock
RUN bundle install --frozen

# Add californica
COPY / /californica
CMD ["sh", "/californica/docker/start-app.sh"]
