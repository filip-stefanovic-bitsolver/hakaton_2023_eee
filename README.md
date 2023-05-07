# Hakaton 2023 eee
eee hakaton setup 2023

# Vivado setup

Fajlovi za ucitavanje projekta u Vivadu se nalaze u hakaton_vivado/ direktorijumu. Potrebno je izvrsiti sledece korake kako biste ucitali projekat:

1. Otvoriti Vivado 2021.1
2. Ici na Tools>Run Tcl Script...
3. Navigirati do hakaton_vivado direktorijuma
4. Izabrati hakaton.tcl

Projekat ce biti kreiran unutar direktorijuma u kome se nalazi *hakaton.tcl* skripta. Projekat ce biti imenovan hakaton_eee i sadrzi 2 DMA kontrolera, *example_design* i 4 Logic Analyzer-a. Prvi DMA koristi 8bitnu AXI Stream magistralu za slanje slike ka dizajnu i prijem obradjene slike sa dizajna. Drugi DMA samo vrsi prijem obradjene slike, ali sa 16bitne AXI Stream magistrale. Modul example_design je primer dizajna koji prihvata piksele sa AXI Stream magistrale i zatim ih shift-uje nalevo ili nadesno. Takodje ima integrisan AXI-APB bridge kojim se moze pristupati memorijski-mapiranim registrima (ukoliko ima potrebe za time). Logic Analyzer-i se mogu koristiti za posmatranje AXI magistrala koje se koriste u komunikaciji sa dizajnom.  

Vasu implementaciju zadatka treba da integrisete u ovaj projekat. 

# Jupiter notebook setup

Fajlovi za testiranje projekta se nalaze u direktorijumu jupiter_demo. Neophodno je pristupiti plocici na adresi 192.168.2.99, koristeci vas browser. Lozinka za pristup plocici je **xilinx**. Nakon toga cete videti ovakvu strukturu direktorijuma:

![image](https://user-images.githubusercontent.com/99603657/236697221-3d9ed968-1206-4253-a797-4a7c12a1441e.png)

Potrebno je kreirati direktorijum /hakaton.

![image](https://user-images.githubusercontent.com/99603657/236697275-039e660e-f784-488f-abaf-5544995b0c95.png)

Unutar njega upload-ovati sve fajlove iz jupiter_demo direktorijuma. Direktorijum hakaton treba da izgleda ovako:

![image](https://user-images.githubusercontent.com/99603657/236697509-e0f00643-d01a-48ea-a90b-f67fedebdae0.png)

Nakon toga otvorite *hakaton_demo.ipynb*, gde se nalazi primer *python* koda kojim se ucitava slika, salje koriscenjem DMA kontrolera, i zatim se obradjena slika se prima koriscenjem 2 DMA kontrolera, jer dizajn na izlazu ima 2 AXI Stream porta, 8bitni i 16bitni.

# Ucitavanje novog dizajna na plocicu

Nakon svake izmene u dizajnu je neophodno zameniti *accelerator_top.bit* i *accelerator_top.hwh* fajlove, koje ste upload-ovali prilikom setup-a Jupiter notebook-a. Tako ce najnovija verzija dizajna biti koriscena prilikom pokretanja hakaton_demo.ipynb notebook-a. 

Potrebno je izvrsiti sintezu, implementaciju i na kraju ispis bitstream-a. Ekstenzija .bit oznacava bitstream fajl - on se automatski generise u hakaton_eee\hakaton_eee.runs\impl_1/accelerator_top_wrapper.bit. Ekstenzija .hwh oznacava hardware handoff fajl i taj fajl se automatski generise u hakaton_eee\hakaton_eee.gen\sources_1\bd\accelerator_top\hw_handoff/accelerator_top.hwh. 

Ovi fajlovi se ucitavaju u prvom koraku hakaton_demo.ipynb. Neophodno je da imaju isto ime, tako da ih treba preimenovati pre pokretanja notebook-a. Ime koje notebook koristi  je definisano ovom linijom:

ol = Overlay("/home/xilinx/jupyter_notebooks/hakaton/**accelerator_top.bit**")

, a na osnovu toga se ocekuje i **accelerator_top.hwh**.
