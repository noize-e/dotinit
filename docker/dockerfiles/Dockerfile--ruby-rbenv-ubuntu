FROM ubuntu:latest
RUN mkdir /usr/app && cd /usr/app
WORKDIR /usr/app
COPY Gemfile /usr/app/
ENV TZ=America/Mexico_City
ENV APP=assapp
ENV VRUBY=3.0.2
RUN ["/bin/bash", "-c", "ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
&& echo $TZ > /etc/timezone \
&& apt-get -o Acquire::Max-FutureTime=86400 update \
&& apt-get install git -y \
&& apt install rbenv -y \
&& echo 'export PATH=\"$HOME/.rbenv/bin:$PATH\"' >> ~/.bashrc \
&& source ~/.bashrc \
&& mkdir -p \"$(rbenv root)\"/plugins \
&& git clone https://github.com/rbenv/ruby-build.git \"$(rbenv root)\"/plugins/ruby-build \
&& echo 'eval \"$(rbenv init -)\"' >> ~/.bashrc \
&& source ~/.bashrc \
&& rbenv init - \
&& rbenv install $VRUBY\
&& rbenv global $VRUBY \
&& rbenv local $VRUBY \
&& export RSHIMS=\"$(rbenv root)\"/shims \
&& rbenv rehash \
&& $RSHIMS/gem install bundler\
&& $RSHIMS/bundle install \
&& curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh | bash \
&& export NVM_DIR=\"$HOME/.nvm\" \
&& [ -s \"$NVM_DIR/nvm.sh\" ] && . \"$NVM_DIR/nvm.sh\" \
&& nvm install node \
&& npm install -g yarn"]
