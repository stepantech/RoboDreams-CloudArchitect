# API Management
Vyzkoušíme na příkladu books a versionme aplikace s využitím Azure Functions pro appku a nasadíme Terraform v adresáři `terraform/books`.

## Politiky, monetizace, bezpečnost
V portálu služby si probereme jak vypadá fasáda, portál pro vývojáře a jak se dělají různé politiky a proč.

## Verzování a revize
Vyjděme z klasického semanického verzování - major.minor.patch. 
- **Major** verze znamená breaking change, tedy změnu, která může způsobit nefunkčnost klientů. To v API Management budeme řešit změnou verze, něčím, co je pro klienta jasně viditelné a nastavitelné.
- **Minor** verze znamená novou funkcionalitu, která je zpětně kompatibilní. To v API Management budeme řešit revizí, tedy něčím, co je pro klienta transparentní a automatické. Jde například o přidané políčko do odpovědi nebo nový, ale nepovinný atribut.
- **Patch** verze znamená opravu chyby, která je zpětně kompatibilní. To v API Management typicky nebudeme řešit vůbec, protože změna není navenek viditelná.

Typické způsoby **indikace verze**:
- Header - Nejsou potřeba žádné změny v cestě nebo logice zpracování či odesílání atributů, navíc formát verze je velmi flexibilní. Nicméně pro klienta a debugging to může být složitější a méně intuitivní.
- Path - API má jinou cestu, takže je potřeba do logiky přidat něco jako baseUrl+verze, nicméně je to jednoduché a intuitivní pro klienta i debugging. Nicméně může to vést na složité URL cesty a nepříjemnosti při různých formátech verzí.
- Query - API má stejnou cestu, ale je potřeba přidat parametr verze. Je to typicky jednodušší, než header, lepší pro debugging nebo caching odpovědí (v zachyceném URL je vidět verze), ale opět vede na dlouhé URL (tak jako u path) a menší intuitivnost (jaku u header) pro klienta.
  
**Formátování verze:**
- Semantické verze - major.minor.patch, ale v url často jen major například v2 (typicky Node.js, npm, Java)
- Postavené na datu - například 2024-09-01-preview (typicky Azure, OpenAI nebo Ubuntu)
- Sekvenční - například 116 (typicky Google Chrome)
- S číslem sestavení - například 1.0.0.1234 (typicky Windows nebo Android)

API VersionMe je připraveno ve dvou variantách verzování - Header nebo URL. Vyzkoušejme si. Následně přidáme ještě revizi, která bude mít politiku přepisující uri na /versionme1next

