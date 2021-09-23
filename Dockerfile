FROM php:fpm-alpine3.14

RUN \
  # Install dependencies
  apk update && apk add --no-cache nginx supervisor tzdata curl \
  && apk upgrade --no-cache \
  # Remove (some of the) default nginx config
  && rm -f /etc/nginx.conf /etc/nginx/conf.d/default.conf /etc/php7/php-fpm.d/www.conf \
  && rm -rf /etc/nginx/sites-* \
  # Ensure nginx logs, even if the config has errors, are written to stderr
  && ln -s /dev/stderr /var/log/nginx/error.log \
  # Support running supervisor under a non-root user
  && adduser nobody www-data \
  && chown -R nobody:www-data /run /var/lib/nginx /var/www

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/bin/
RUN install-php-extensions gd zip imap bcmath mcrypt redis pgsql pdo_pgsql opcache exif pcntl && \
  rm -rf /usr/bin/install-php-extensions

COPY etc/ /etc/
# user nobody, group www-data
USER nobody:www-data

# mark dirs as volumes that need to be writable, allows running the container --read-only
VOLUME /run /srv/data /tmp /var/lib/nginx/tmp

EXPOSE 8080

ENTRYPOINT ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisor.conf"]
