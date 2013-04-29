* vasim.cmd

* Insertion des models HSPICE du design Kit Nangate
* La technologie choisie est nominale / typique

.compat
.lib /comelec/softs/opt/opus_kits/FreePDK45/ncsu_basekit/models/hspice/hspice.include TT
.endcompat

* Definition du "corner" en température et en tension
.temp 25
.param valim=1.1

* Definition des modèles de conversion logique/électrique


.model a2d_std a2d mode=std_vsrc vth1=(valim/2) vth2=(valim/2)
.model d2a_std d2a mode=std_vsrc vhi=valim vlo=0 trise=0.001n tfall=0.001n
.defhook d2a_std a2d_std

* Précision des simulations analogiques
* valeurs possibles : FAST STANDARD ACCURATE VHIGH
* HMIN=1f : precision temporelle
* attention ce sont des valeurs extrèmes pour la caractérisation, à ne pas utiliser
* pour des simulations rapides.
.option TUNING=HIGH
.option HMIN=1f

* L'analyse transitoire
* En toute circonstance la simulation ne dure pas plus longtemps.
.tran 0.10f 100u

