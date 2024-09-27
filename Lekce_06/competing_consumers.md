# Competing Consumers
Ve scénáři máme jede Topic, jednoho producenta zpráv a dva nezávislé konzumenty. Oba mají se zprávami jiné záměry, nejsou na sobě závislí.

1. Podívejme se na Topic a odběratele - vidíme, že ani jeden nestíhá všechny zprávy odbavovat.
2. Otevřeme Log stream na konzumentovi a vidíme jeho zpracování zpráv
3. Vypneme jednoho konzumenta a vidíme, že nezpracované zprávy se mu tak hromadí ještě rychleji (ale neztrácejí se, čekají).
4. Znovu zapneme tohoto konzumenta a zvýšíme mu počet instancí - identických replik, která každá "soupeří" o získání zpráv. Tím můžeme vyškálovat výkon tak, abychom dohnali všechno, co se nám hromadí.
5. V topicu vidíme, že tento konzument (resp. několik instancí tohoto konzumenta) nám požírají zprávy až se dostaneme na málo čekajících.
6. Jenže teď u máme replik zase zbytečně moc, chtělo by to ubrat. Vysvětlíme si automatické škálování.