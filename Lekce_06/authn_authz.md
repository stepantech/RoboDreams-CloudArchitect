# Autentizace a autorizace v aplikacích
Základní koncepty si ukážeme na aplikacích `auth_entra_api` a `authz_entra_web`. Nejprve si v Entra ID (to je identitní systém, který v ukázce použijeme, ale můžete být jakýkoli jiný OIDC provider) zaregistrujeme aplikace. 

- **main app (web)** - registrace pro náš web, která nám umožní účastnit se ověřování (tedy vyžádat si od uživatele ověření)
- **api** - registrace pro naše API, jejíž součastí je definice služeb, které toto API nabízí (tedy k čemu lze udělovat přístupy a souhlasy)
- **background** - registrace pro "neuživatelskou" identitu, která umožní se jedné aplikaci prokazovat druhé (service-to-service flow), například pro nějaké dávkové procesy na pozadí
- **apim** - registrace pro "neuživatelskou" identitu, kterou použijeme pro scénář, kdy se API Management prokazuje našemu API místo aplikace

Po nasazení přes Terraform je potřeba vzít si URL webu a zaregistrovat ji jako redirect URI pro web a api aplikaci, například `http://ca-auth-entra-web.wittycliff-692252ad.germanywestcentral.azurecontainerapps.io/auth_response`.

Přistoupíme na web a ukážeme si několik scénářů:
- Aplikace vyžaduje přihlášení uživatele
- Přístup na Graph API pro získání dalších informací z adresáře uživatele, tzn. potřebuje consent pro on-behalf-of flow, kde uživatel povolí pro naší aplikaci přístup na uživatelské informace
- Přístup na naše vlastní API s on-behalf-of flow, kde uživatel povolí pro naší aplikaci přístup na specifické pravomoce (Stuff.Read v našem případě)
- Přístup na naše vlastní API bez účasti uživatele s použitím service-to-service autentizace (web má svou vlastní identitu kterou se prokazuje)
- Přístup na naše vlastní API s on-behalf-of flow, kde se používá API Management jako passthrough v cestě, kde ale dochází k validaci tokenů (pre-autorizace)
- Přístup na naše vlastní API bez účasti uživatele s použitím service-to-service autentizace s ověřením pouze oproti API Managementu, bez ověřování v našem API (např. legacy aplikace, které neumí ověřovat tokeny)
- TBD: Uživatel a web se nemusí ověřovat, API Management pro ně provede ověření k API službě