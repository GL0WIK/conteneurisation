FROM httpd:latest

COPY ../site/index.html /usr/local/apache2/htdocs/index.html
