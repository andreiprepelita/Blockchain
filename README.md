# Blockchain


TEMA 2 Enunt

Sursa data in fisierul: SampleToken.sol (adaptare dupa un exemplu din "Blockchain by Example" - B. Badr, R. Horrocks, X. Wu), include doua contracte: un exemplu simplificat de token ERC-20 - SampleToken si un contract folosit pentru vanzarea acestui token - SampleTokenSale. Proprietarul tokenului va instantia mai intai contractul token cu o suma totala disponibila pentru token ce este asociata balantei proprietarului, dupa care va instantia contractul de vanzare, pentru a vinde tokenul respectiv prin intermediul acestuia.
In forma curenta contractul de vanzare nu are acces initial la fonduri. Pentru a vinde tokenul, proprietarul trebuie sa transfere periodic din fondurile proprii de token catre balanta contractului de vanzare folosind metoda transfer. Contractul de vanzare foloseste de asemenea metoda transfer in cadrul vanzarii.

Se cer urmatoarele:

Completarea si corectarea functionalitatii curente a contractelor. In particular:

Corectarea situatiilor unde pattern-ul Checks-Effects-Interaction nu este respectat in metodele contractelor.
Completarea cu functionalitatile obligatorii lipsa ce corespund unui contract ERC-20, conform specificatiilor standard, pentru contractul SampleToken.
Modificarea implementarii astfel incat contractul de vanzare sa foloseasca metoda transferFrom pentru vanzare, in urma unei aprobari a proprietarului token-ului ce permite contractului de vanzare sa efectueze vanzarea direct din balanta proprietarului.

Imbunatatirea functionalitatii curente a contractelor, dupa cum urmeaza:

Asigurarea posibilitatii pentru proprietarul tokenului de a putea modifica pretul de vanzare fixat la instantierea contractului SampleTokenSale.
Relaxarea implementarii astfel incat cumparatorii sa nu fie obligati sa plateasca suma exacta pentru achizitionarea de tokens, ci sa poata plati mai mult si sa le fie returnat restul.
Implementarea unei functionalitati automate de minting - generarea de noi tokens, ce vor fi adaugate la balanta proprietarului tokenului, la totalSupply, si la cantitatea aprobata pentru vanzare, in numar de o unitate de token nou la fiecare rulaj direct de 10000 de unitati (se considera rulaj direct cantitatea cumulata de tokens transferata in urma apelurilor transfer).

Integrarea utilizarii tokenului in contractul MyAuction ce este parte a exemplului de DAPP pentru licitatii auto din laboratorul 6, si completarea acestuia:

Tokenul va fi utilizat in locul monedei de baza Ethereum in situatiile in care sunt necesare transferuri (bid, withdraw, etc.).
Un aplicant la licitatie nu va putea licita decat o singura data (nu isi va putea suprascrie suma licitata).
Se va adauga o finalitate pentru licitatii: proprietarul contractului va putea retrage suma castigatoare a licitatiei, iar sumele celorlalti aplicanti vor fi returnate la distrugerea contractului daca acestia nu le-au retras pana in acel moment.

Bonus: Se acorda pana la 5 puncte bonus pentru imbunatatirea interfetei exemplului de DAPP din laboratorul 6. Aceasta ar trebui sa includa de exemplu suport pentru pornirea si accesarea a mai multe licitatii simultane, o pagina/sectiune dedicata achizitionarii de tokens si de verificare a balantei proprii, si evident acoperirea functionalitatilor pentru toate operatiile dintr-un contract de licitatie in interfata web (inclusiv retragerea sumelor licitate) precum si imbogatirea acesteia cu un design mai atractiv.


Tema 1 - Enunt :

Se doreste o implementare care sa permita adunarea de fonduri de la mai multi contribuitori si distribuirea acestora unor beneficiari.

Implementati trei contracte: CrowdFunding, SponsorFunding si DistributeFunding, care sa functioneze in modul descris mai jos:

Contractul CrowdFunding include un o suma tinta - "fundingGoal" - ce se doreste sa fie adunata de la mai multi contribuitori. Un contribuitor poate fi identificat printr-o adresa. Eventuale alte informatii (ex., nume, etc.) pot fi retinute optional prin intermediul unei structuri.
Contractul SponsorFunding are rolul de a adauga unei sume adunate o extra sponsorizare in cuantum de un procent fixat din suma respectiva. Pentru aceasta contractul SponsorFunding necesita o balanta de fonduri proprii, lipsa unei balante suficiente (mai mica decat sponsorizarea calculata procentual), rezultand in anularea sponsorizarii. Pentru asigurarea fondurilor contractul va expune o functie apelabila doar de catre proprietarul contractului ce poate realiza doua actiuni: schimbarea procentului de sponsorizare si alimentarea balantei din fondurile proprietarului. De asemenea contractul poate fi initializat printr-un constructor payable cu o suma ca balanta proprie si cu o valoare implicita pentru procentul de sponsorizare.
Contractul DistributeFunding permite adaugarea unui numar de actionari/beneficiari cu rolul de a distribui acestora suma cumulata in final. Fiecare actionar adaugat are o pondere asociata din procentul de 100% al sumei (ponderea totala a actionarilor poate fi mai mica de 100%).

Consideram trei "stari" ale finantarii: 1) "nefinantat" - inainte de atingerea sumei tinta, 2) "prefinantat" - dupa atingerea sumei inainte de sponsorizare, 3) "finantat" - dupa eventuala sponsorizare.
Este posibila interograrea acestei stari (ex., cu un raspuns de tip string mentinut de contractul CrowdFunding) la orice moment de catre oricine pentru a sti in ce stare se afla finantarea.

Inainte de atingerea sumei tinta (starea "nefinantat"), contractul CrowdFunding trebuie sa ofere posibilitatea de:

Depunere a unei sume de catre un contribuitor. La fiecare depunere contractul va verifica daca s-a atins suma tinta.
Retragere a oricarei sume, inclusiv partiala, depuse de un contribuitor.

Dupa atingerea sumei tinta (starea "prefinantat"):

Nu se mai pot retrage sau depune sume.
Proprietarul contractului CrowdFunding poate comunica contractului SponsorFunding finalizarea colectarii sumei, la care contractul SponsorFunding va verifica balanta contractului CrowdFunding si va vira catre acesta sponsorizarea oferita. In cazul in care contractul SponsorFunding nu dispune de o balanta suficienta pentru sponsorizare nu va vira nimic.

Dupa eventuala sponsorizare (starea "finantat"):

Proprietarul contractului CrowdFunding poate vira suma totala adunata catre contractul DistributeFunding.
Doar dupa acest virament, contractul DistributeFunding va permite fiecarui actionar sa isi retraga, o singura data, venitul calculat conform cu ponderea proprie.
