# Azure Machine Learning
V portálu si založíme službu Azure Machine Learning a zkusíme si některé vlastnosti, primárně trénování modelů s Automatic ML, správu verzí modelů (MLOps) a inferencing (používání modelů).

1. Nahrajeme data ve formátu MLTable, která jsou připravena `aml` adresáři.
2. Vytvoříme Automated ML job s využitím našich lending club dat. Půjde o klasifikační problém.
3. Cílový label (to co predikujeme) je `loan_status`.
4. Prohlédněme si nastavení featurizace
5. Sledujme průběh trénování a sweep operací (vyhledávání hyperparametrů a modelů)
6. Uvidíme různé modely a jejich výsledky - jeden z těchto modelů můžeme zaregistrovat
7. V záložce modelů ho pak můžeme nasadit