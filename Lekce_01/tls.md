# TLS
V této ukázce jsem jednoduše zachytil komunikaci s HTTPS serverem tomaskubica.cz použitím [Wireshark](https://www.wireshark.org/). Výsledek je v souboru [tls.pcapng](tls.pcapng) a rozebereme si ho společně.

1. Vidíme sestavení TCP - SYN, SYN+ACK, ACK
2. Klient navrhuje TLS 1.0 a různé protokoly
3. Server odmítá TLS 1.0 a navrhuje TLS 1.2
4. Klient má nový návrh tentokrát na TLS 1.2 a nabízí na výběr 16 šifrovacích metod
5. Server souhlasí a vybírá jednu z metod

Další komunikace už je šifrovaná, nicméně zachytil jsem session key [sessionkey.txt](sessionkey.txt) a ten si můžeme do Wireshark nahrát (Edit, Protocols, TLS) a podívat se dovnitř paketů.