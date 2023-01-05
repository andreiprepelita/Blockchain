Cerinte abordate:

Completarea si corectarea functionalitatii curente a contractelor. In particular:

Corectarea situatiilor unde pattern-ul Checks-Effects-Interaction nu este respectat in metodele contractelor.
Completarea cu functionalitatile obligatorii lipsa ce corespund unui contract ERC-20, conform specificatiilor standard, pentru contractul SampleToken.
Modificarea implementarii astfel incat contractul de vanzare sa foloseasca metoda transferFrom pentru vanzare, in urma unei aprobari a proprietarului token-ului ce permite contractului de vanzare sa efectueze vanzarea direct din balanta proprietarului.

Imbunatatirea functionalitatii curente a contractelor, dupa cum urmeaza:

Asigurarea posibilitatii pentru proprietarul tokenului de a putea modifica pretul de vanzare fixat la instantierea contractului SampleTokenSale.
Relaxarea implementarii astfel incat cumparatorii sa nu fie obligati sa plateasca suma exacta pentru achizitionarea de tokens, ci sa poata plati mai mult si sa le fie returnat restul.
Implementarea unei functionalitati automate de minting - generarea de noi tokens, ce vor fi adaugate la balanta proprietarului tokenului, la totalSupply, si la cantitatea aprobata pentru vanzare, in numar de o unitate de token nou la fiecare rulaj direct de 10000 de unitati (se considera rulaj direct cantitatea cumulata de tokens transferata in urma apelurilor transfer).

Pentru Contractul MyAuction am abordat cerinta:
Un aplicant la licitatie nu va putea licita decat o singura data (nu isi va putea suprascrie suma licitata).
