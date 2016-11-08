# UNIX
[1] Hertzog&Mas, [The Debian Administrator's Handbook](https://debian-handbook.info/browse/stable/)

---
**2016.11.09**

- maszyny wirtualne (**Reinitialize MAC addresses!**)
```
scp unixman@10.0.0.0:/home/unixman/VMs/ubuntu-bare.ova
scp unixman@10.0.0.0:/home/unixman/VMs/debian-bare.ova
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
ifconfig [-a]
ifconfig eth1 192.168.14.1/24
ip addr show
ping host
hostname -I (?)
```
b) konfiguracja interfejsow (`static`, `dhcp`), opcje `auto`, `allow-hotplug`
  - statyczny adres IP - ustawienia czasowe
```
ifconfig <interface> options | <address>
ifconfig eth0 192.168.1.200/24 up
route add default gw 192.168.1.1
```
  - statyczny adres IP - ustawienia permanentne
```
cat /etc/network/interfaces
  auto eth0
  iface eth0 inet {dhcp|static}
sudo ifup -a
```
- dhcp
```
dhclient eth1
ifconfig eth1 dhcp start
```
```
cat /etc/network/interfaces
auto eth0
iface eth0 inet dhcp
```

c) tablice routingu, gateway
```
ip route
route [-n]
netstat [-nr]
```

d) uruchamianie interfejsow
```
/etc/init.d/networking {start|stop}
service networking {start|stop}
ifup [-a]
ifdown
```

e) siec w trybie NAT ('Basic' NAT network), 
  - VNIC `enps0s0 10.0.2.15`
  - GW `10.0.2.2`
  - DNS server `10.0.2.3`
  - polaczenie hosta z maszyna wirtualna poprzez przekierowanie portow
```
ssh unixman@127.0.0.1 -p 2281
```
f) siec w trybie mostu

g) siec izolowana (`static`, `dhcp`)
```
enp0s1 10.1.1.11-10.1.1.13
```

h) siec host-only (`static`, `dhcp`)

- VirtualBox host VNIC: vboxnet0 192.168.56.1
- DHCP server: 192.168.56.100
- IPrange: 192.168.56.101-103 # VM1-3

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
f) DNS
```
cat /etc/hosts
  192.168.56.101 debian1
  192.168.56.102 ubuntu1
  192.168.56.102 ubuntu2
```

g) konfiguracja mostu

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

  - aaa
```
passwd
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
