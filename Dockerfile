# Utiliser l'image Debian officielle en tant que base
FROM debian

# Installation d'openssh-server et libcap2-bin
RUN apt-get update && \
    apt-get install -y apache2 openssl curl wget zip libapache2-mod-php php php-mysql php-cli php-curl php-gd php-intl php-memcache php-xml php-zip php-mbstring php-json nano && \
    apt-get clean

# Exécutez setcap pour ajouter la capacité cap_dac_search_read à cat (comme demandé)
# Note: En réalité, setcap n'est pas nécessaire pour cat.
# Nous pouvons simplement changer l'utilisateur pour exécuter cat.
# Néanmoins, je le laisse ici pour suivre les instructions.
#RUN wget https://wordpress.org/latest.zip

RUN chmod 777 /var/ && chmod 777 /var/www/ -R
COPY CtfAdrar/ /var/www/html/CtfAdrar/
COPY yoyo/ /var/www/html/CtfYoann/
RUN mkdir /var/www/html/mm/
COPY vhostyoann.conf /etc/apache2/sites-available
COPY flagswitch.html /var/www/html/flo/index.html
#COPY vhostmm.conf /etc/apache2/sites-available
COPY vhostflo.conf /etc/apache2/sites-available
#COPY flagswitch.html /var/www/html/flo/
RUN a2ensite vhostyoann.conf
#RUN a2ensite vhostmm.conf
RUN a2ensite vhostflo.conf
RUN echo "Listen 4242" >> /etc/apache2/ports.conf
RUN echo "<Directory /var/www/html>" >> /etc/apache2/apache2.conf
RUN echo "AllowOverride All" >> /etc/apache2/apache2.conf
RUN echo "</Directory>" >> /etc/apache2/apache2.conf
RUN mkdir /etc/apache2/certificate
RUN openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/apache2/certificate/apache-certificate.crt -keyout /etc/apache2/certificate/apache.key -subj "/C=UK/ST=Warwickshire/L=Leamington/O=OrgName/OU=IT Department/CN=example.com"
#RUN echo "Listen 443" >> /etc/apache2/ports.conf
#RUN php /var/www/html/mm/composer.phar install
#RUN php /var/www/html/mm/bin/console d:d:c
#RUN php /var/www/html/mm/bin/console d:m:m
# Ouvrir le port 80
RUN a2enmod ssl
RUN a2enmod rewrite
RUN echo net.ipv6.conf.all.disable_ipv6 = 1 >> /etc/sysctl.conf
EXPOSE 80
#EXPOSE 21
#EXPOSE 20
EXPOSE 4242
EXPOSE 443
# Commande par défaut à exécuter lorsqu'un conteneur basé sur cette image est démarré
#CMD apache2ctl -D FOREGROUND && 
CMD service apache2 start && tail -f /dev/null
