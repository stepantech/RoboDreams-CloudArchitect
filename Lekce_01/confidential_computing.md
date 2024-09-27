# Confidential Computing
V ukázce se podíváme na tři varianty běhu kontejnerů a jejich oddělenost od základního operačního systému:
- Standardní kontejner využívá sdílený kernel a s administrátorkým přístupem do podkladového VM uvidíme jak procesy v kontejneru, tak i obsah jeho paměti.
- Kata kontejner běžící v izolaci hypervisorové (např. Intel VT-X), takže administrátor přímo nevidí procesy (jsou izolované s využitím speciálních instrukcí procesoru), ale vidí obsah paměti.
- Confidential Containers spouští každý kontejner jako VM (podobně jako Kata containers), ale navíc v dedikované šifrované enklávě (Intel TDX, AMD SEC), takže ani administrátor VM nevidí obsah paměti.

Infrastrukturu najdete v [../terraform/confidential_containers](../terraform/confidential_containers) a v tomto adresáři je i demo_script.sh s dalšími instrukcemi.