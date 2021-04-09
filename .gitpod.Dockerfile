FROM jelaniwoods/appdev2021-base-ruby
USER gitpod
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import - \
    && curl -sSL https://rvm.io/pkuczynski.asc | gpg --import - \
    && curl -fsSL https://get.rvm.io | bash -s stable \
    && bash -lc " \
        rvm requirements \
        && rvm install 2.7.2 \
        && rvm use 2.7.2 --default \
        && rvm rubygems current \
        && gem install bundler --no-document \
        && gem install solargraph --no-document"

USER gitpod
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
