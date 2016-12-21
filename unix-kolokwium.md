### Kolokwium

- Pobrac maszyne wirtualna ubuntu-kol.ova z adresu 155.158.206.23 za pomoca polecenia

```bash
scp unixman@155.158.206.23:/home/unixman/VMs/ubuntu-kol.ova .
```

- Korzystajac z trybu `single-user` zmienic hasla uzytkownikow `root` oraz `unixman` na nastepujace:

user: root
haslo: root123

user: unixman
haslo: unixman123

- Wykorzystujac wolne miejsce na dysku stworzyc dwie dodatkowe partycje logiczne o rozmiarze 2 GB kazda.

- Na nowych partycjach utworzyc systemy plikow ReiserFS oraz XFS.

- Dodac odpowiednie wpisy do `/etc/fstab`, tak aby nowe partycje byly permanentnie montowane w punktach `/mnt/reiser` oraz `/mnt/xfs`. 

- W katalogu `/mnt/reiser` utworzyc 50 katalogow o nazwach `reiser-1`,...,`reiser-50`. W kazdym z katalogow `reiser-1`,...,`reiser-50` utworzyc trzy pliki tekstowe o nazwach `reiser-1-1`, `reiser-1-2`, `reiser-1-3`, itd. zawierajace 100 dowolnych znakow ASCII. 

- W katalogu `/mnt/xfs` utworzyc 50 katalogow o nazwach `xfs-1`,...,`xfs-50`. W kazdym z katalogow `xfs-1`,...,`xfs-50` utworzyc trzy pliki tekstowe o nazwach `xfs-1-1`, `xfs-1-2`, `xfs-1-3`, itd. zawierajace 100 dowolnych znakow ASCII. 

- Przekopiowac katalogi `reiser-1`,...,`reiser-50` do katalogu `/mnt/xfs`, a nastepnie przekopiowac katalogi `xfs-1`,...,`xfs-50` do katalogu `/mnt/reiser`. 

- Dodac dwoch nowych uzytkownikow `koluser1` oraz `koluser2` oraz nowa grupe `kol`:

user: koluser1
haslo: koluser1123

user: koluser2
haslo: koluser2123

Dodac uzytkownikow `koluser1` oraz `koluser2` do grupy `kol`.

- Wymusic wygasniecie hasla dla uzytkownika `koluser2` i zmiane hasla po zalogowaniu.

- Skonfigurowac interfejs sieciowy `enp0s9` w trybie sieci `host-only`. Przypisac mu  statyczny adres IP `192.168.56.109`.

- Sprawdzic czy komunikacja sieciowa pomiedzy maszyna wirtualna a hostem przebiega poprawnie. 

- Zainstalowac program `htop` oraz serwer www `nginx`. Zmodyfikowac plik konfiguracyjny `nginx`, tak aby pod adresem http://192.168.56.109 w przegladarce internetowej pojawial sie napis: `NGINX zainstalowany w trakcie kolokwium.`

- Korzystajac z `ufw` skonfigurowac zapore sieciowa, tak aby mozliwe bylo nawiazanie polaczenia przychodzacego tylko z adresu 192.168.56.1 poprzez protokol `http` lub `ssh`. 

- Wyeksportowac maszyne wirtualna zapisujac ja w katalogu domowym w formacie nazwisko.ova:

```bash
VirtualBox > Plik > Eksportuj jako urzadzenie wirtualne...
```

- Skopiowac plik nazwisko.ova do `155.158.206.23:/home/unixman/VMs` za pomoca polecenia:

```bash
scp ~/nazwisko.ova unixman@155.158.206.23:/home/unixman/VMs/
```
