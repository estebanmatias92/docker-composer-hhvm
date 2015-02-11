FROM estebanmatias92/hhvm

MAINTAINER "Matias Esteban" <estebanmatias92@gmail.com>

ENV COMPOSER_HOME /root/.composer

# Install build and runtime dependencies
RUN deps=' \
        curl \
        git \
        subversion \
        mercurial \
    ' \
    && apt-get -y update \
    && apt-get install -y $deps \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove -y

# Copy config files
COPY config/hhvm/php.ini $PHP_INI_DIR/

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www

ENTRYPOINT ["/usr/local/bin/composer", "--ansi"]

CMD ["--help"]
