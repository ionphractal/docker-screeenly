# screenly
#FROM php:7-fpm
FROM php:7-apache
MAINTAINER Michael Both <both.michael@googlemail.com>
LABEL image="ionphractal/screeenly" \
  version="0.1.0" \
  description="Docker Container with Screeenly." \
  package="Screeenly" \
  package_url="https://github.com/stefanzweifel/screeenly" \
  package_version="2.1.1"

ENV PKG_NAME="screeenly" \
  PKG_VERSION="v2.1.1" \
  PKG_GIT_URL="https://github.com/gogits/gogs.git" \
  PKG_COMMIT="d17f113230943efe0c91f4c310401708f3157e8f" \
  DEBIAN_FRONTEND="noninteractive"

RUN apt update \
 && apt install -y gnupg git \
 && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
 && apt install -y nodejs npm gconf-service libasound2 libatk1.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libexpat1 libfontconfig1 libgcc1 libgconf-2-4 libgdk-pixbuf2.0-0 libglib2.0-0 libgtk-3-0 libnspr4 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libx11-6 libx11-xcb1 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 libxfixes3 libxi6 libxrandr2 libxrender1 libxss1 libxtst6 ca-certificates fonts-liberation libappindicator1 libnss3 lsb-release xdg-utils wget zip libfreetype6-dev libjpeg62-turbo-dev libpng-dev \
 && docker-php-ext-install -j$(nproc) iconv \
 && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql

RUN sed -i 's#^Listen 80#Listen 3000#' /etc/apache2/ports.conf
RUN cd /var/www \
 && chown www-data . \
 && rm -R /var/www/html \
 && git clone https://github.com/stefanzweifel/screeenly.git /var/www/html \
 && cd /var/www/html \
 && git checkout ${PKG_COMMIT}
WORKDIR /var/www/html
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

RUN npm install --global yarn envsub \
 && npm install --global --unsafe-perm puppeteer \
 && chmod -R o+rx /usr/lib/node_modules/puppeteer/.local-chromium \
 && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
 && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
 && rm composer-setup.php \
 && chown -R www-data: /var/www/html

USER www-data
RUN composer install
RUN yarn install
RUN npm install

ADD .env.template /var/www/html/
ADD entrypoint.sh /

# initial setup
CMD ["bash", "/entrypoint.sh"]
