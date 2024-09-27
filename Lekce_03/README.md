# 3. lekce: Orchestrace kontejnerů
Declarative desired state znamená, že systému řekne, jak vypadá námi požadovaný stav. Necháme na něm, aby zařídil, aby realita tomuto stavu odpovídala a pokud se realita od toho stavu odchýlí, tak aby učinil kroky, které to napraví. Je to podobné jako váš termostat v domácnosti nebo tempomat v autě. Nastavíte požadovanou teplotu nebo rychlost a systém se postará o příslušné změny v otevřenosti kohoutu nebo sešlápnutého plynu.

Proč potřebujeme orchestraci kontejnerů? Běžet na vlastním počítači je fajn, ale není to způsob, jak nabídnout zákazníkům vysoce spolehlivý škálovatelný přístup k aplikaci. Potřebujeme je běžet v clusteru, v několika nodech ideálně rozprostřených přes zóny dostupnosti. Pokažené kontejnery potřebujeme restartovat, spustit někde jinde pokud node umře, vyřešit síťařinu a balancování provozu, napojení na data a spoustu dalších věcí. Velmi používaným open source orchestrátorem je Kubernetes.

## Základy Kubernetes
Nejprve budeme potřebovat Kubernetes cluster a připojení k němu. Můžete použít Kubernetes službu v cloudu (Azure, AWS, Google), instalaci v on-premises (VMWare Tanzu, RedHat Openshift, Rancher) nebo malou implementaci na vlastním počítači či Raspberry Pi (například k3S).

Takhle to můžete udělat v Azure přes Azure CLI:

```bash
az group create --name rg-aks --location swedencentral
az aks create --resource-group rg-aks --name myaks -x -s Standard_B2s --enable-app-routing 
az aks get-credentials --resource-group rg-aks --name myaks --overwrite-existing
```

Vyzkoušejme si nejprve nahodit Pod a smazat ho.

```bash
kubectl apply -f kubernetes/intro/pod.yaml
```

Určitě budeme chtít něco nad tím. Něco co zajistí běh většího množství replik, bude je udržovat zdravé a pomůže nám vyřešit upgrady. K tomu si musíme pohrát s labely, Deploymenty a ReplicaSety. Ukážeme si naživo.

```bash
kubectl apply -f kubernetes/intro/deployment.yaml
```

Vyzkoušíme si teď vnitřní síťové balancování a pak rolling upgrade aplikace.

```bash
kubectl apply -f kubernetes/intro/service.yaml
kubectl apply -f kubernetes/intro/client.yaml
```

Přidejme a vysvětleme si readiness a liveness probe.


## Pokročilé progresivní nasazování
V předchozím případě jsme si ukázali rolling upgrade, ale techniky pozvolna postupujícího nasazování mohou být o poznání chytřejší. Oblíbenými projekty pro Kubernetes jsou pro tyto účely Argo Rollouts a Flagger. Nutným vstupním předpokladem je mít v cluster proxy řešení, které umožní chytré balancování provozu na L7 úrovni (o tom daleko více v příští lekci) a v našem případě je to jednoduchý NGINX Ingress kontroler, který jsme si nechali nainstalovat společně s AKS. Může to být ale i jiná implementace nebo service mesh (například Istio), který umožní chytré rozhodování nejen na vstupu do clusteru, ale i přímo mezi službami uvnitř.

```bash
# Install Argo Rollouts controller to cluster
kubectl create namespace argo-rollouts
kubectl apply -n argo-rollouts -f https://github.com/argoproj/argo-rollouts/releases/latest/download/install.yaml

# Install Argo Rollouts CLI

```

Nasadíme demo aplikaci a přistoupíme na ni přes IP adresu ingressu.

```bash
kubectl apply -f kube:svc:rnetes/intro/rollout.yaml
```

Po instalaci Argo CLI nastartujeme dashboard, upravíme verzi aplikace (například na red) a ukážeme se postupné nasazení.

```bash
kubectl argo rollouts dashboard
```

## Konfigurace, soubory a tajnosti
Někdy potřebujeme jednoduché konfigurace, které předáváme do kontejneru přes proměnné prostředí. Někdy jsou to složitější konstrukty, třeba komplexní konfigurační soubor. Pro oba tyto případy, kdy nejde o hesla a jiné tajnosti, můžeme použít ConfigMapy a vložit je do kontejneru při jeho spuštění a oddělit tak jejich životní cyklus.

```bash
kubectl apply -f kubernetes/intro/configmap.yaml
```

Pro tajnosti, jako jsou hesla, certifikáty a klíče, máme Secrety. Ty se ukládají v clusteru a jsou šifrované. Můžeme je předat kontejneru jako soubor nebo proměnnou prostředí. Lepší přístup je ale mít tajnosti zcela mimo cluster ve specializovaném trezoru ideálně postaveném na hardwarovém zabezpečení (HSM). Příklad je použití SecretProviderClass pro Kubernetes, která je dostpná třeba pro Azure Key Vault, GCP Secret Manager nebo HashiCorp Vault.

Pokud máte stavové aplikace, snažte se stav přesunout do cloudové služby - databáze, fronta, Redis cache, protože to vám hodně zjednoduší život. Nicméně je možné mít drivery pro storage a s tou pracovat:

```bash
kubectl apply -f kubernetes/intro/pvc.yaml
```


## Zapouzdření aplikace a DRY princip
Představme si, že uvnitř Kubernetes chceme vytvořit dvě prostředí - preprod a prod a k tomu použijeme namespace. Naší aplikaci chceme nasadit tak, abychom měli společné manifesty (předpisy), ale v preprod bylo v2 aplikace a jen 2 instance, zatímco v prod stále v1 a 3 instance.

První možností je vzít konfigurace a použít systém, který je načte a některé hodnoty pro nás přepíše podle toho, v kterém je prostředí (patch). K tomu můžeme použít Kustomize. Je to velmi elegantní, rychlé a bezestavové řešení.

```bash
kubectl create namespace preprod
kubectl create namespace prod
kubectl apply -k kustomize/web/preprod
kubectl apply -k kustomize/web/prod
```

Většina deploymentů ale potřebuje ještě více funcionality a zejména schopnost vytvářet vlastní abstrakce, oprostit se od limitů Kubernetes API a nutnosti znát názvy konkrétních atributů (tak se vytváří patch). Je možné použít templatovací jazyk, který vám umožní vytvářet vlastní abstrakce a znovupoužitelné komponenty. Jde o Helm a ten kromě toho je i stavový, takže si v clusteru ukládá přehled co je nasazeno a jaké jsou verze. Zejména pro použití pro externí uživatele zapouzdřeného předpisu je to nejpoužívanější varianta (např. open source projekty Helm používají velmi často). Funguje to na principu šablon, v nich vytvořených proměnný a jejich dosazení například z values file.

```bash
kubectl create namespace helm-preprod
kubectl create namespace helm-prod
helm upgrade -i web-preprod helm/web --namespace helm-preprod --values helm/web/preprod_values.yaml
helm upgrade -i web-prod helm/web --namespace helm-prod --values helm/web/prod_values.yaml
```

