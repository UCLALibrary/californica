FROM ruby:2.5

RUN apt-get update -qq
# Add https support to apt to download yarn & newer node
RUN apt-get install -y  apt-transport-https

# Add node and yarn repos and install them along
# along with other rails deps
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq

# Install system dependencies
RUN apt-get update -qq && apt-get install -y default-libmysqlclient-dev build-essential libpq-dev nodejs yarn imagemagick libreoffice ffmpeg unzip chromium-driver

# Set up user
# RUN groupadd -r --gid 3000 docker && \
#   useradd -r --uid 3000 --gid 3000 docker
# RUN mkdir /home/docker
# RUN chown docker:docker /home/docker
# USER docker

# Install Ruby Gems
RUN gem install bundler -v '1.17.3'
ENV BUNDLE_PATH /usr/local/bundle
WORKDIR /californica
COPY Gemfile /californica/Gemfile
COPY Gemfile.lock /californica/Gemfile.lock
RUN bundle install

# Add californica
COPY / /californica
CMD ["sh", "/californica/docker/start-app.sh"]
