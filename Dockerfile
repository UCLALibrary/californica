FROM ruby:2.5

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
    default-libmysqlclient-dev \
    build-essential \
    libpq-dev \
    nodejs \
    yarn \
    imagemagick \
    libreoffice \
    ffmpeg \
    unzip \
    chromium-driver \
    zip

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
