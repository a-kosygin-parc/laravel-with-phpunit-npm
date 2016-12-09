# PHPUnit Docker Container.
FROM ubuntu:16.04
MAINTAINER Alexandr Kosygin <kosalnik@gmail.com>

# Run some Debian packages installation.
ENV PACKAGES="php7.0 php7.0-curl php7.0-mcrypt php7.0-mbstring php7.0-mysql php7.0-xml php7.0-zip npm git"
RUN apt-get update && \
    apt-get install -yq --no-install-recommends $PACKAGES && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Run php composer installation
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php -r "if (hash_file('SHA384', 'composer-setup.php') === 'aa96f26c2b67226a324c27919f1eb05f21c248b987e6195cad9690d5c1ff713d53020a02ac8c217dbf90a7eacc9d141d') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
    && php composer-setup.php \
    && php -r "unlink('composer-setup.php');" \
    && mv ./composer.phar /usr/local/bin/composer \
    && php -m

# Run gulp installation
RUN npm install -g gulp-cli

# Goto temporary directory.
WORKDIR /tmp

# Run PHPUnit installation
RUN composer selfupdate \
    && composer require "phpunit/phpunit:~5.4.2" --prefer-source --no-interaction \
    && ln -s /tmp/vendor/bin/phpunit /usr/local/bin/phpunit

# Set up the application directory.
VOLUME ["/app"]
WORKDIR /app

# Set up the command arguments.
#ENTRYPOINT ["/usr/local/bin/phpunit"]
#CMD ["--help"]

