# UNIX
[1] Hertzog&Mas, [The Debian Administrator's Handbook](https://debian-handbook.info/browse/stable/)

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
