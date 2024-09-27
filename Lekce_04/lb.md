# Load Balancing demo
Po nasazení zdrojů dostaneme s Terraform výstup s FQDN (adresou) všech endpointů pro L4, L7 a DNS balancing a to regionálních i globálních.

Příklad výstupu je tady (ve vašem případě bude jiný):

```json
endpoints = {
  "dns_global_fqdn" = "traf-rd-lb-oxcg.trafficmanager.net"
  "l4_global_fqdn" = "rd-lb-oxcg-lbglobal.westeurope.cloudapp.azure.com"
  "l4_ip_fqdn" = "rd-lb-oxcg-swc-l4.swedencentral.cloudapp.azure.com"
  "l7_global_fqdn" = "fde-rd-lb-oxcg-buc9e3angwgvcmh8.b01.azurefd.net"
  "l7_ip_fqdn" = "rd-lb-oxcg-swc-l7.swedencentral.cloudapp.azure.com"
}
```

## L4 Balancing
Vyzkoušejme regionální i globální endpointy.

## L7 regionální balancing
Podívejme se na L7 pravidla, kdy máme dva různé typy backend serverů a klient může přistupovat na jediný endpoint. Podle URL cesty (L7) se rozhodne, který server bude odpovídat.

Například:

```bash
curl -v http://rd-lb-oxcg-swc-l7.swedencentral.cloudapp.azure.com/
curl -v http://rd-lb-oxcg-swc-l7.swedencentral.cloudapp.azure.com/service2
```

## DNS balancing
V našem případě kombinujeme L4 regionální balancing a DNS globální balancing. Vyzkoušejte prozkoumat DNS odpověď při přístupu na globální FQDN.

```bash
# Windows
nslookup  -debug traf-rd-lb-oxcg.trafficmanager.net

# Linux
dig traf-rd-lb-oxcg.trafficmanager.net
```

Probereme možnosti health checku a balancování na základě vzdálenosti nebo zátěže.

## Dynamická CDN, distribuované L7 řešení
Ukážeme si na příkladu Azure Front Door. Řešení typicky obsahuje:
- Můžete použít svůj vlastní FQDN, ale k tomu musíte prokázat vlastnictví domény (např. TXT záznam v DNS) a nasměrovat uživatele na FQDN vaší CDN instance, což obvykle nelze přes IP adresu (CDN nepodporuje A záznam, aby měla flexibilitu IP změnit, pokud by taková potřeba vznikla). Musí to být tedy CNAME, což není dostupné pro holou doménu (například www.tomaskubica.cz je OK, tomaskubica.cz ne, protože CNAME se nesnese s jiným záznamem a v rootu musíte mít SOA). To se dá řešit přes DNS chaising (někdy se tomu říká aliasing), kdy DNS vede něco jako dynamicky se měnící A záznam.
- CDN obvykle směruje FQDN na anycast IP, často ale přes řetěz CNAME. Jde o speciální případ IP adresy, která není jen na jednom místě a odpoví na ni nejbližší lokalita (například CloudFlare používá 1.1.1.1 či 1.0.0.1)
- Součástí je obvykle DDoS ochrana před volumetrickými útoky (např. SYN flood, UDP flood, amplification atd.) a za příplatek WAF (ochrana na aplikační úrovni, např. SQL injection, XSS, CSRF, DDoS na aplikační úrovni, zneužití API atd.)
- Obvykle jde o desítky či nižší stovky POP lokalit po celém světě. Nabírání provozu přímo v místě klienta má obvykle dramatický vliv na uživatelskou zkušenost v oblastech s horším připojením (např. Latinská Amerika, Afrika, Asie).

V našem příkladě si ukážeme využití pravidla podle HTTP hlavičky, kterým můžeme "rozsvítit" testovací verzi aplikace.

```bash
curl https://fde-rd-lb-oxcg-buc9e3angwgvcmh8.b01.azurefd.net/
curl -H "Beta-Tester: true" https://fde-rd-lb-oxcg-buc9e3angwgvcmh8.b01.azurefd.net/
```