FROM eboraas/apache-php
MAINTAINER Ed Boraas <ed@boraas.ca>

ARG repo=https://github.com/laravel/laravel.git
ARG env=.env
ARG htaccess=.htaccess

RUN apt-get update && apt-get -y install git curl php5-mcrypt php5-json nano && apt-get -y autoremove && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN /usr/sbin/a2enmod rewrite

ADD 000-laravel.conf /etc/apache2/sites-available/
ADD 001-laravel-ssl.conf /etc/apache2/sites-available/
RUN /usr/sbin/a2dissite '*' && /usr/sbin/a2ensite 000-laravel 001-laravel-ssl

RUN /usr/bin/curl -sS https://getcomposer.org/installer |/usr/bin/php
RUN /bin/mv composer.phar /usr/local/bin/composer

RUN git clone $repo /var/www/laravel
RUN /bin/chown www-data:www-data -R /var/www/laravel

RUN composer --working-dir=/var/www/laravel install;
ADD $env /var/www/laravel
ADD $htaccess /var/www/laravel/public

RUN cd /var/www/laravel; php artisan key:generate;
RUN cd /var/www/laravel; php artisan clear-compiled;
RUN cd /var/www/laravel; php artisan optimize;
RUN cd /var/www/laravel; php artisan cache:clear;

EXPOSE 80
EXPOSE 443

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]