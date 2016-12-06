# UNIX
[1] Hertzog&Mas, [The Debian Administrator's Handbook](https://debian-handbook.info/browse/stable/)


---
**2016.12.07**

- zapory sieciowe (firewall)

- instalacja ufw (Uncomplicated Firewall)

```bash
sudo apt-get install ufw
```

- wlaczenie obslugi IPv6

```bash
sudo nano /etc/default/ufw 
...
IPV6=yes
...
```

- sprawdzenie statusu zapory

 - firewall nieaktywny
 ```bash
 sudo ufw status verbose
 Output:
 Status: inactive
 ```
 
 - firewall aktywny, dozwolone polaczenie jedynie na port 22 z dowolnej lokalizacji
 ```bash
 sudo ufw status verbose
 Output:
 Status: active
 Logging: on (low)
 Default: deny (incoming), allow (outgoing), disabled (routed)
 New profiles: skip
 
 To                         Action      From
 --                         ------      ----
 22/tcp                     ALLOW IN    Anywhere
 ```

- domyslne ustawienia zapory

```bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
```
- zezwolenie na polaczenie przez SSH na porcie 22

```bash
sudo ufw allow (ssh|22)
```

- uaktywnienie i wylaczenie zapory

```bash
sudo ufw (enable|disable)
```
- zezwolenie na polaczenia HTTP, HTTPS, FTP, rsync, MySQL, PostgreSQL,...

```bash
cat /etc/services
```

```bash
sudo ufw allow (http|80)
sudo ufw allow (https|443)
sudo ufw allow (ftp|21/tcp)
sudo ufw allow from 15.15.15.0/24 to any port 873
sudo ufw allow from 15.15.15.0/24 to any port 3306
sudo ufw allow from 15.15.15.0/24 to any port 5432
```

```bash
sudo ufw allow proto tcp from any to any port 80,443
```

- zezwolenie na polaczenie na zakresie portow 6000-6007

```bash
sudo ufw allow 6000:6007/tcp
sudo ufw allow 6000:6007/udp
```

- zezwolenie na polaczenie z ustalonych adresow IP

```bash
sudo ufw allow from 15.15.15.51
sudo ufw allow from 15.15.15.51 to any port 22
sudo ufw allow from 15.15.15.0/24
sudo ufw allow from 15.15.15.0/24 to any port 22
```

- zezwolenie na polaczenie poprzez wybrany interfejs sieciowy

```bash
sudo ufw allow in on eth0 to any port 80
sudo ufw allow in on eth1 to any port 3306
```

- blokowanie polaczen w przypadku domyslnego ustawienia zapory w trybie `default allow incoming`

```
sudo ufw deny http
sudo ufw deny from 15.15.15.51
sudo ufw deny from 15.15.15.0/24
```
- usuwanie regul zapory sieciowej

 - poprzez odwolanie do numery reguly
 ```bash
 sudo ufw status numbered
 Numbered Output:
 Status: active
 
      To                         Action      From
      --                         ------      ----
 [ 1] 22                         ALLOW IN    15.15.15.0/24
 [ 2] 80                         ALLOW IN    Anywhere
 ```
 ```bash
 sudo ufw delete 2
 ```

 - poprzez usuniecie calego wpisu
 
 ```bash
 sudo ufw delete allow (http|80)
 ```

- resetowanie ustawien zapory

```bash
sudo ufw reset
```



- snort

---
**2016.11.23**

- sekwencja startowa systemu
  - `dmesg`: bootstrap, init, udev, syslogd
  - demony

- init, `/sbin/init`
  - sysvinit, `/etc/inittab`, `/etc/init.d`, `/etc/rc.d`
  - Upstart,  `/etc/init/*.conf`
  - systemd, `/etc/systemd`, `/usr/lib/systemd`, jednostki (units): uslug (service), monotowania (mount), celu (target)

- poziomy pracy
  - `runlevel`, `who -r`
  - [Debian docs](https://www.debian.org/doc/manuals/debian-reference/ch03.en.html)
  - runlevels `0-9`, `/etc/inittab`, `/etc/rc.d`,
  - zmiana poziomu pracy `telint`
  - `default.target`


- zarzadzanie uslugami w systemach inicjalizowanych przez `systemd`
  - `systemctl`
  - [RHEL7 Chapter 9](https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/pdf/System_Administrators_Guide/Red_Hat_Enterprise_Linux-7-System_Administrators_Guide-en-US.pdf)

- procesy, identyfikator procesu (PID), PPID
```bash
ps [a] [ax] [aux] [auxw] | less
```
- STAT, RSS, VSZ
```bash
man ps
```
- monitorowanie procesow, priorytety, PR, NI
```bash
top
nice
ls /proc
cat /proc/cpuinfo
cat /proc/devices
cat /proc/meminfo
cat /proc/partitions
```

---
**2016.11.16**

- sprawdzic topologie sieci NAT, sieci wewnetrznej oraz sieci host-only korzystajac z `nmap`, `traceroute`, `nslookup`
- ustalic w kazdej sieci adres bramy domyslnej (jesli istnieje), serwera DHCP oraz serwera DNS
```bash
cat /var/lib/dhcp/dhclient.eth0.leases
nmap --script broadcast-dhcp-discover -e <interface>
```
- DNAT, SNAT, przekierowanie portow
```bash
cat /proc/sys/net/ipv4/conf/default/forwarding
echo 1 > /proc/sys/net/ipv4/conf/default/forwarding
```
```bash
cat /etc/sysctl.conf
net.ipv4.conf.default.forwarding = 1
net.ipv4.conf.default.rp_filter = 1
net.ipv4.tcp_syncookies = 1
```
- ksztaltowanie ruchu sieciowego, wondershaper

```bash
wget -O /dev/null http://speedtest.dal01.softlayer.com/downloads/test100.zip
```
```bash
sudo apt-get install wondershaper
```
```bash
cat /etc/network/interfaces
  allow-hotplug enp0s3
  iface enp0s3 inet dhcp
  up /sbin/wondershaper enp0s3 500 100
  down /sbin/wondershaper enp0s3 remove
reboot
wget -O /dev/null http://speedtest.dal01.softlayer.com/downloads/test100.zip
```
- diagnostyka sieci
  - netstat [-t -u -p -a -n -c]
  - nmap [-A ] localhost
  - nmap -A 10.0.2.0/24 > nmap-10.txt
  - nmap -A 192.168.56.0/24 > nmap-192.txt

- konfiguracja GRUBa
```bash
cat /etc/default/grub
  GRUB_TIMEOUT=10
update-grub
reboot
```
```bash
cat /boot/grub/grub.cfg
```

- single-user mode
```
linux /boot/vmlinuz-4.4.0-45-generic root=UUOD=6d011cfd-267e-41b8-91d6-bcd4b35990b2 ro init=/bin/bash
Ctrl+x
mount -n -o remount,rw /
passwd
reboot -f
```
- instalacja serwera LAMP/LEMP

  - nginx
  ```bash
  apt-get install nginx
  ps -ax | grep nginx
  netstat -tupan
  http://192.168.56.102
  cat /etc/nginx/nginx.conf
  ```
  - baza danych MySQL
  ```bash
  sudo apt-get install mysql-server
  sudo mysql_secure_installation
  ```
  - PHP
  ```bash
  sudo apt-get install php-fpm php-mysql
  nano /etc/php/7.0/fpm/php.ini
    cgi.fix_pathinfo=0
  systemctl restart php7.0-fpm  
  ```
  - powiazanie `nginx` z PHP
  ```bash
  cat /etc/nginx/sites-available/default
    server {
        listen 80 default_server;
        listen [::]:80 default_server;
    
        root /var/www/html;
        index index.html index.htm index.nginx-debian.html;
    
        server_name _;
    
        location / {
            try_files $uri $uri/ =404;
        }
    }
  ```
  ```bash
  cat /etc/nginx/sites-available/default
   server {
        listen 80 default_server;
        listen [::]:80 default_server;
    
        root /var/www/html;
        index index.php index.html index.htm index.nginx-debian.html;
    
        server_name server_domain_or_IP;
    
        location / {
            try_files $uri $uri/ =404;
        }
    
        location ~ \.php$ {
            include snippets/fastcgi-php.conf;
            fastcgi_pass unix:/run/php/php7.0-fpm.sock;
        }
    
        location ~ /\.ht {
            deny all;
        }
    }
  ```
  ```bash
  nginx -t
  ```
  ```bash
  systemctl reload nginx
  ```
  - utworzenie pliku testowego PHP
  ```bash
  cat /var/www/html/info.php
    <?php
    phpinfo();
  ```
  ```bash
  http://192.168.56.102/info.php
  ```

- resetowanie klucza ssh
```bash
ssh-keygen -R <host>
ssh <host>
```

- wlaczenie logowania przez ssh na konto root

```bash
cat /etc/ssh/sshd_config
  PermitRootLogin yes
/etc/init.d/ssh restart  
```
Inna mozliwosc:
```bash
sudo sed -i 's/prohibit-password/yes/' /etc/ssh/sshd_config && systemctl restart sshd
```

---
**2016.11.09**

- maszyny wirtualne (**Reinitialize MAC addresses!**)
```
mkdir ~/VMs
scp unixman@10.0.0.0:/home/unixman/VMs/ubuntu-bare.ova ~/VMs/
scp unixman@10.0.0.0:/home/unixman/VMs/debian-bare.ova ~/VMs/
```

- zarzadzanie ustawieniami sieciowymi
- konfiguracja sieci w VirtualBoxie
  - NAT, port forwarding
  - mostek
  - siec izolowana
  - siec host-only
- wirtualizacja warstwy L1 (VNIC, VSWITCH)

a) podstawowe polecenia; nowy schemat numeracji interfejsow np. `enp0s0` 
```
hostname -I
ifconfig [-a] [<interface>]
ip addr show
ping <IP>
```
Identyfikacja hosta/hostow przez jadro
```
cat /proc/sys/kernel/hostname
cat /etc/hosts
```

b) konfiguracja interfejsow (`static`, `dhcp`), opcje `auto`, `allow-hotplug`
```
man 5 interfaces
```

  - statyczny adres IP - ustawienia czasowe
```
/sbin/ifconfig
ifconfig <interface> options | <address>
```
Przyklad:
```
ifconfig eth0 192.168.1.200/24 up
route add default gw 192.168.1.1
```
  - statyczny adres IP - ustawienia permanentne
```
cat /etc/network/interfaces
  # The loopback network interface
  auto lo eth0
  iface lo inet loopback

  # The primary network interface
  iface eth0 inet static
  address 192.168.10.33
  netmask 255.255.255.0
  broadcast 192.168.10.255
  network 192.168.10.0
  gateway 192.168.10.254 
  dns-nameservers 192.168.10.254
```

- dhcp
```
dhclient eth0
```
```
cat /etc/network/interfaces
auto eth0
iface eth0 inet dhcp
```

c) uruchamianie interfejsow
```
/etc/init.d/networking {restart|start|stop}
service networking {restart|start|stop}
ifup [-a]
ifdown
```

d) tablice routingu, gateway
```
ip route
route [-n]
netstat [-nr]
```

e) siec w trybie NAT ('Basic' NAT network), 
  - VNIC `enp0s0 10.0.2.15`
  - GW `10.0.2.2`
  - DNS server `10.0.2.3`
  - polaczenie hosta z maszyna wirtualna poprzez przekierowanie portow
```  
VM > Ustawienia > Siec > Zaawansowane > Przekierowanie portow
Nazwa:SSH Protokol:TCP IP hosta: Port hosta: 2281 IP goscia: Port goscia: 22
```
```
ssh unixman@127.0.0.1 -p 2281
```
f) siec w trybie mostu (`static`, `dhcp`)
```
enp0s8 155.158.131.X
```

g) siec izolowana (`static`, `dhcp`)
```
enp0s9 10.1.1.11-10.1.1.13
```

h) siec host-only (`static`, `dhcp`)

- VirtualBox host VNIC: vboxnet0 192.168.56.1
- DHCP server: 192.168.56.100
- IP range: 192.168.56.101-103 # VM1-3

Statyczna konfiguracja VM1:
```
ifconfig enp0s10 192.168.56.101 netmask 255.255.255.0 up
```
```
cat /etc/network/interfaces
  # The host-only network interfaces
  # automatically brings up iface at boot time
  auto enp0s10 
  iface enp0s10 inet static
  address 192.168.56.101
  netmask 255.255.255.0
  network 192.168.56.0
  broadcast 192.168.56.255
```
i) statyczne mapowanie nazw hostow i adresow IP
```
cat /etc/hosts
  192.168.56.101 debian1
  192.168.56.102 ubuntu1
  192.168.56.102 ubuntu2
```

j)* konfiguracja mostu (bridge), agregacja laczy (link aggregation)

k) uzywane serwery DNS
```
cat /etc/resolv.conf
```
l) odpytanie serwera DNS
```
nslookup google.com
```

---
**2016.11.02**
- zarzadzanie uzytkownikami i grupami
- ustawienia globalne, ustawienia lokalne, locale
- prawa dostepu, ACL

a) ustawienie locali
```bash
locale
```

b) uzytkownicy i grupy, hasla, `/etc/passwd`, `/etc/group`, `/etc/shadow`

c) wazne polecenia zwiazane z zarzadzaniem haslami

  - ustawienia hasla, termin waznosci
```
passwd [options] [<user>]
chage -l <user>
```
  - wymuszenie wygasniecia hasla i zmiany przy zalogowaniu (expiration)
```
passwd -e <user>
```
  - zablokowanie usera (lock)
```
passwd -l <user>
```

f) dodawanie uzytkownikow i grup; adduser template `/etc/skel/`
```
adduser <user>
{addgroup|delgroup|passwd} -g <group>
adduser <user> <group>
```

g) dostepne powloki `/etc/shells`

h) ustawienia basha `/etc/bash.bashrc`

i) ustawienia opcji logowania konsoli `/etc/profile`

j) lokalne ustawienia basha, aliasy
```
cat ~/.bashrc
alias la='ls -la | less' 
```
