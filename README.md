# Docker image based on PHP alpine

Completely customizable image with Nginx and PHP FPM.

All processes start with supervisor, thus it's quite easy to add a new one, just add your supervisor configuration to the folder /etc/supervisor/configs and supervisor will take care for you to start the process.

Example configuration:
```
[program:php-fpm]
process_name=%(program_name)s_%(process_num)02d
command = php-fpm -F
autostart = true
autorestart = true
stdout_logfile = /dev/stdout
stdout_logfile_maxbytes = 0
```