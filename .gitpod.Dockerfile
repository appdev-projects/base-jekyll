FROM jelaniwoods/appdev2021-base-ruby
# AppDev stuff
RUN /bin/bash -l -c "gem install rufo activesupport"
# Install Node and npm
RUN curl -fsSL https://deb.nodesource.com/setup_15.x | sudo -E bash - \
    && sudo apt-get install -y nodejs

# Install Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
    && sudo apt-get install -y yarn

# Install fuser
RUN sudo apt install -y libpq-dev psmisc lsof

WORKDIR /base-ruby
COPY Gemfile /base-ruby/Gemfile
COPY Gemfile.lock /base-ruby/Gemfile.lock
RUN /bin/bash -l -c "gem install bundler:2.2.3"
RUN /bin/bash -l -c "bundle install"

# Install heroku-cli
RUN /bin/bash -l -c "curl https://cli-assets.heroku.com/install.sh | sh"

# Hack to pre-install bundled gems
RUN echo "rvm use 2.7.2" >> ~/.bashrc
RUN echo "rvm_silence_path_mismatch_check_flag=1" >> ~/.rvmrc
