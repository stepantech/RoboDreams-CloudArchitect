# RPO/RTO tradeoff
V ukázce si nasadíme technologii snapshot replikace VM z jednoho regionu do druhého s využitím Azure Site Recovery a budeme demonstrovat různé hodnoty RTO a RPO pro použití poslední zálohy, poslední zpracované zálohy nebo poslední app-consistent zálohy.

Infrastrukturu najdete v [../terraform/rto_rpo](../terraform/rto_rpo) a v tomto adresáři je i demo_script.sh s dalšími instrukcemi.