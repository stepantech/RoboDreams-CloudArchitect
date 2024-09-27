# Green Blue deployment s VM
V této ukázce se podíváme na primitivní variantu cloud-native práce s VM a použití green-blue metody nasazení.
- VM se neoprašují, ale při změnách se raději vytvoří nové
- "Ručně" zde řídíme přechod z green na blue úpravou parametrů Terraformu. V praxi samozřejmě použijete něco jiného, například zabudované vlastnosti přímo v cloudu jako jsou Azure Virtual Machine Scale Set nebo AWS Deployment Groups.
- V našem případě je VM prázdný Linux image a aplikace se doinstaluje skriptem při startu. Urychlit tuto dobu můžete použitím golden image, kdy se nejprve připraví pokaždé hotový obraz s předinstalovanými komponentami (například přes software Packer pro některý z cloudů) a iniciální skript VM pouze "dokonfiguruje", což mu jde rychleji.

Postup:
- Nasadíme 2 VM Green a zkoušíme přístup na 10.0.0.100 z client VM (while true; do curl 10.0.0.100; done)
- Přidáme 2 VM Blue
- Odebereme 2 VM Green