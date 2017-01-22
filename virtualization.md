- sprawdzenie IP maszyny wirtualnej poprzez tablice `arp` badz ustawienia wbudowanego serwera `dhcp`

```bash
arp -n
virsh net-list
virsh net-dhcp-leases <net-name>
```

- skrypt konfiguracyjny maszyny wirtualnej `kvm-master.sh`

