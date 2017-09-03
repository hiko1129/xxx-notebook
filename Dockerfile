FROM jupyter/minimal-notebook

USER root

RUN apt-get update && apt-get install -yq \
    libtool \
    pkg-config \
    autoconf \
    ruby \
    ruby-dev \
    rake \
    && apt-get clean && cd ~ && \
    git clone --depth=1 https://github.com/zeromq/libzmq && \
    git clone --depth=1 https://github.com/zeromq/czmq && \
    cd libzmq && ./autogen.sh && ./configure && make && make install && \
    cd ../czmq && ./autogen.sh && ./configure && make && make install && \
    gem install cztop specific_install && \
    gem specific_install https://github.com/SciRuby/iruby.git && \
    rm -rf /var/lib/apt/lists/* && ldconfig

ADD ./notebooks /opt/notebooks

WORKDIR /opt/notebooks

RUN gem install bundler

RUN bundle install

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_USER

RUN iruby register
