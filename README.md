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

Potrebno je kreirati direktorijum /hakaton i unutar njega upload-ovati sve fajlove iz jupiter_demo direktorijuma. Nakon toga otvorite 

# Ucitavanje novog dizajna na plocicu

Nakon svake izmene u dizajnu je neophodno zameniti accelerator.bit i accelerator.hwh fajlove, koje ste isprva upload-ovali u memoriju plocice. Tako ce poslednja verzija dizajna biti koriscena prilikom runovanja jupiter notebook-a. 

Morate pokrenuti sintezu, zatim implementaciju i na kraju generisanje bitstream-a. Ekstenzija .bit oznacava bitstream fajl - on se automatski generise u hakaton_eee\hakaton_eee.runs\impl_1/accelerator_top_wrapper.bit. Ekstenzija .hwh oznacava hardware handoff fajl i taj fajl se automatski generise u C:\Users\filip\Desktop\hakaton2\hakaton_eee\hakaton_eee.gen\sources_1\bd\accelerator_top\hw_handoff/accelerator_top.hwh. 

Da bi ova dva fajla mogli zajedno da se koriste, neophodno je da imaju isto ime
