FROM estebanmatias92/hhvm

MAINTAINER "Matias Esteban" <estebanmatias92@gmail.com>

RUN useradd -g users composer

# Grab gosu for easy step-down from root
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/* \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture)" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-$(dpkg --print-architecture).asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu \
    && apt-get purge -y --auto-remove curl

ENV COMPOSER_HOME /root/.composer

# Install build and runtime dependencies
RUN deps=' \
        curl \
        git \
        subversion \
        mercurial \
    ' \
    && apt-get update && apt-get install -y $deps && rm -rf /var/lib/apt/lists/*

# Copy config files
COPY config/hhvm/php.ini $PHP_INI_DIR/

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]

CMD ["composer"]
