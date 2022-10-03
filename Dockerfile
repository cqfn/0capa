# Dockerfile.rails
FROM ruby:2.6.8 AS rails-toolbox

RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
WORKDIR /myapp
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock
RUN gem install bundler:2.3.19
RUN bundle install

ARG USER_ID
ARG GROUP_ID

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg -o /root/yarn-pubkey.gpg && apt-key add /root/yarn-pubkey.gpg
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y --no-install-recommends nodejs yarn


ENV DATABASE_URL #DATABASE_URL
ENV TOM_DATABASE_PASSWORD #DATABASE_PASSWORD

ENV INSTALL_PATH /opt/app
RUN mkdir -p $INSTALL_PATH


WORKDIR $INSTALL_PATH
COPY . .
RUN gem install bundler:1.17.2
RUN rm -rf node_modules vendor
RUN gem install rails --version 6.1.4
RUN gem install bundler
RUN bundle install
RUN yarn install

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

#USER $USER_ID
#CMD bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]