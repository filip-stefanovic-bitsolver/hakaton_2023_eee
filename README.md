# Hakaton 2023 eee
eee hakaton setup 2023

# Vivado setup

Fajlovi za ucitavanje projekta u Vivadu se nalaze u hakaton_vivado/ direktorijumu. Potrebno je izvrsiti sledece korake kako biste ucitali projekat:

1. Otvoriti Vivado 2021.1
2. Ici na Tools>Run Tcl Script...
3. Navigirati do hakaton_vivado direktorijuma
4. Izabrati hakaton.tcl

Projekat ce biti kreiran unutar direktorijuma u kome se nalazi hakaton.tcl, pod imenom hakaton_eee.

# Jupiter notebook setup

Fajlovi za testiranje projekta se nalaze u direktorijumu jupiter_demo. Neophodno je pristupiti plocici na adresi 192.168.2.99, putem browsera. Lozinka za pristup plocici je xilinx. Nakon toga cete videti ovakvu strukturu direktorijuma:

![image](https://user-images.githubusercontent.com/99603657/236697221-3d9ed968-1206-4253-a797-4a7c12a1441e.png)

Potrebno je kreirati direktorijum /hakaton.

![image](https://user-images.githubusercontent.com/99603657/236697275-039e660e-f784-488f-abaf-5544995b0c95.png)

Unutar njega upload-ovati sve fajlove iz jupiter_demo direktorijuma. Direktorijum hakaton treba da izgleda ovako:

![image](https://user-images.githubusercontent.com/99603657/236697509-e0f00643-d01a-48ea-a90b-f67fedebdae0.png)

Nakon toga otvorite hakaton_demo.ipynb, gde se nalazi primer koda kojim se ucitava slika, salje koriscenjem DMA kontrolera, i zatim se obradjena slika se prima koriscenjem 2 DMA kontrolera, jer dizajn na izlazu ima 2 AXI Stream porta, 8bitni i 16bitni.

# Ucitavanje novog dizajna na plocicu

Nakon svake izmene u dizajnu je neophodno zameniti accelerator.bit i accelerator.hwh fajlove, koje ste upload-ovali prilikom setup-a Jupiter notebook-a. Tako ce najnovija verzija dizajna biti koriscena prilikom pokretanja hakaton_demo.ipynb notebook-a. 

Potrebno je izvrsiti sintezu, implementaciju i na kraju ispis bitstream-a. Ekstenzija .bit oznacava bitstream fajl - on se automatski generise u hakaton_eee\hakaton_eee.runs\impl_1/accelerator_top_wrapper.bit. Ekstenzija .hwh oznacava hardware handoff fajl i taj fajl se automatski generise u hakaton_eee\hakaton_eee.gen\sources_1\bd\accelerator_top\hw_handoff/accelerator_top.hwh. 

Ovi fajlovi se ucitavaju u prvom koraku hakaton_demo.ipynb. Neophodno je da imaju isto ime, tako da ih treba preimenovati pre pokretanja notebook-a. Ime koje notebook ocekuje je definisano ovom linijom:

ol = Overlay("/home/xilinx/jupyter_notebooks/hakaton/accelerator.bit")
