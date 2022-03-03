FROM httpd:2.4
COPY ./public-html/ /usr/local/apache2/htdocs/

 RUN sed -i \
         -e 's/^#\(Include .*httpd-ssl.conf\)/\1/' \
         -e 's/^#\(LoadModule .*mod_ssl.so\)/\1/' \
         -e 's/^#\(LoadModule .*mod_socache_shmcb.so\)/\1/' \
         conf/httpd.conf


## Move the ssl certs some place we can easily mount the secrest
RUN sed -i \
    -e 's/^SSLCertificateFile.*/SSLCertificateFile "\/certs\/tls.crt"/' \
    -e 's/^SSLCertificateKeyFile.*/SSLCertificateKeyFile "\/certs\/tls.key"/' \
    conf/extra/httpd-ssl.conf

