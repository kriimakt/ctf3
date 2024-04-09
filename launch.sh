#/bin/bash
sudo chmod 777 ./configdns
read -p "(D)hcp ou (S)tatic ?" dhcp
if [ $dhcp = "D" ]; then
        IPFULL=$(ip a | grep 'dynamic ens33' | cut -d " " -f6)
        IPGOOD=${IPFULL%???}
elif [ $dhcp = "S" ]; then
        IPGOOD=192.168.15.200
else
        echo "ERREUR."
        exit 1
fi
chmod 777 ./configdns -R
chmod 777 ./recordsdns -R
chmod 777 ./cachedns -R
sed -i "208s/192\.168\.15\.200/$IPGOOD/" ./yoyo/accueil.html
echo "Votre IP : $IPGOOD"
sleep 2
echo '$ORIGIN adrar-numerique.lan.
$TTL    604800
@       IN      SOA     srvdns.adrar-numerique.lan. root.localhost. (
                              3         ; Serial
                         604800         ; Refresh
                          86400         ; Retry
                        2419200         ; Expire
                         604800 )       ; Negative Cache TTL
;
@       IN      NS      srvdns.adrar.lan.' > ./configdns/db.adrar.lan 
echo "@       IN      A       $IPGOOD
srvdns  IN      A       $IPGOOD
www     IN      A       $IPGOOD
tym     IN      A       $IPGOOD
yoann   IN      A       $IPGOOD
jeff	IN	A	$IPGOOD
mm	IN	A	$IPGOOD
flo	IN	A	$IPGOOD" >> ./configdns/db.adrar.lan

sudo docker compose up $1
