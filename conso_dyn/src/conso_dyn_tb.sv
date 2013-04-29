// On prend 1fs dans le timescale pour que les mesures de temps dans le domaine "numérique" soient précises.
// (à confirmer)
`timescale 1ns/1fs


module conso_dyn_tb;

// Paramètres du testbench
parameter real digital_tick    = 7          ;    // (ns) Temps entre deux transitions du signal d'entrée

// Les signaux logiques et électriques
logic  din1                ; // Signal logique destiné à piloter le test
logic  din2            ; // Signal logique constant sur l'autre entrée
bit    fin_test           ; // vaut 0 au débu de la simu
// Les variables adaptées ou mesurées exprimées sous forme de signaux réels. 
real capa_charge_val      ; // La valeur de la capacité de charge
real tt_val               ; // La valeur du temps de transition en entrée
real internal_energy   	  ; // La mesure du temsp de propag du circuit

// On instancie la maquette de test, en utilisant la connection générique pour simplifie l'écriture
conso_dyn_bd bd0  (
                          .din1(din1),
			  .din2(din2),
                          .tt_val(tt_val),
                          .capa_charge_val(capa_charge_val),
                          .internal_energy(internal_energy),
                          .fin_test(fin_test)
                          ) ;

// La liste des points de test à effectuer est déterminée par 2 tables de paramètres directement
// extraite du fichier Liberty de la bibliothèque NANGATE
localparam NBSLOPES = 7 ;
localparam NBCAPA = 7 ;
localparam real rise_values[0:NBSLOPES-1] = '{0.00117378,0.00472397,0.0171859,0.0409838,0.0780596,0.130081,0.198535} ; // ns
localparam real capa_values[0:NBCAPA-1] = '{0.365616,1.897810,3.795620,7.591250,15.182500,30.365000,60.730000}; // fF
// Table pour récupérer ...
real internal_energy_A1_rise [0:NBSLOPES-1][0:NBCAPA-1] ;
real internal_energy_A1_fall [0:NBSLOPES-1][0:NBCAPA-1] ;
real internal_energy_A2_rise [0:NBSLOPES-1][0:NBCAPA-1] ;
real internal_energy_A2_fall [0:NBSLOPES-1][0:NBCAPA-1] ;
///////////////////////////////////////////////////////////////
// Le testbench proprement dit défini dans le monde "logique".
///////////////////////////////////////////////////////////////

integer File ;
initial 
begin:simu
   int slope_index,capa_index ;
   real prop_time ;
   din1 = 1 ;
   din2 = 1 ;
   // Création du fichier de résultats
   File = $fopen("AND2_X4_internal_power.dat") ;
   // Boucle principale sur la liste des pentes d'entrée
   for(slope_index=0;slope_index<NBSLOPES;slope_index++) 
   begin
     // Attention on change la valeur de la pente lorsque l'on est sur que rien ne bouge dans la partie analogique
     #(digital_tick) ; tt_val = rise_values[slope_index]*1.0e-9  ;
     // Boucle secondaire sur la liste des capa de charge
     for(capa_index=0;capa_index<NBCAPA;capa_index++) 
     begin
       // Attention on change la valeur de la capa de charge lorsque l'on est sur que rien ne bouge dans la partie analogique
       #(digital_tick) ; capa_charge_val = capa_values[capa_index]*1.0e-15  ;
       // On provoque une montée du signal de commande A1
       #(digital_tick) ; din1 = 0 ;
       // On récupère la mesure
       #(digital_tick) ; internal_energy_A1_fall[slope_index][capa_index] = internal_energy/1.0e-9 ;
       // On provoque une descente du signal de commande A1
       #(digital_tick) ; din1 = 1 ;
       // On récupère la mesure
       #(digital_tick) ; internal_energy_A1_rise[slope_index][capa_index] = internal_energy/1.0e-9 ;
       // On provoque une montée du signal de commande A2
       #(digital_tick) ; din2 = 0 ;
       // On récupère la mesure
       #(digital_tick) ; internal_energy_A2_fall[slope_index][capa_index] = internal_energy/1.0e-9 ;
       // On provoque une descente du signal de commande A2
       #(digital_tick) ; din2 = 1 ;
       // On récupère la mesure
       #(digital_tick) ; internal_energy_A2_rise[slope_index][capa_index] = internal_energy/1.0e-9 ;
     end
   end
   // On a récupéré tous les temps de propagation, il n'y a plus qu'à écrire dans un fichier 
   // les résultats de mesure. Ici on utilise le format du fichier "Liberty"
   #(digital_tick) ;
   // Ecriture des résultats
   $fwrite(File,"internal_energy {\n") ;
   $fwrite(File,"    index_1 (\"") ;
   for(slope_index=0;slope_index<NBSLOPES;slope_index++)
   begin
     $fwrite(File,"%10.8f",rise_values[slope_index]) ;
     if(slope_index < NBSLOPES-1)
        $fwrite(File,",") ;
     else
        $fwrite(File,"\");\n") ;
   end

   $fwrite(File,"    index_2 (\"") ;
   for(capa_index=0;capa_index<NBCAPA;capa_index++)
   begin
     $fwrite(File,"%10.8f",capa_values[capa_index]) ;
     if(capa_index < NBCAPA-1)
        $fwrite(File,",") ;
     else
        $fwrite(File,"\");\n") ;
   end
   $fwrite(File,"       A1    :\n") ;
   $fwrite(File,"internal_energy {\n") ;
// A1 rise
   for(slope_index=0;slope_index<NBSLOPES;slope_index++)
   begin
     if(slope_index == 0) 
        $fwrite(File,"    rise (\"") ;
     else
        $fwrite(File,"             ") ;
     for(capa_index=0;capa_index<NBCAPA;capa_index++)
     begin
       $fwrite(File,"%10.8f",internal_energy_A1_rise[slope_index][capa_index]) ;
       if(capa_index < NBCAPA-1)
          $fwrite(File,",") ;
       else
          $fwrite(File,"\"") ;
     end
     if(slope_index < NBSLOPES-1)
        $fwrite(File,", \\\n") ;
     else
        $fwrite(File,");\n") ;
   end
// A1 fall
   for(slope_index=0;slope_index<NBSLOPES;slope_index++)
   begin
     if(slope_index == 0) 
        $fwrite(File,"    fall (\"") ;
     else
        $fwrite(File,"             ") ;
     for(capa_index=0;capa_index<NBCAPA;capa_index++)
     begin
       $fwrite(File,"%10.8f",internal_energy_A1_fall[slope_index][capa_index]) ;
       if(capa_index < NBCAPA-1)
          $fwrite(File,",") ;
       else
          $fwrite(File,"\"") ;
     end
     if(slope_index < NBSLOPES-1)
        $fwrite(File,", \\\n") ;
     else
        $fwrite(File,");\n") ;
   end
   $fwrite(File,"}\n\n") ;

   $fwrite(File,"       A2    :\n") ;
   $fwrite(File,"internal_energy {\n") ;
// A2 rise
   for(slope_index=0;slope_index<NBSLOPES;slope_index++)
   begin
     if(slope_index == 0) 
        $fwrite(File,"    rise (\"") ;
     else
        $fwrite(File,"             ") ;
     for(capa_index=0;capa_index<NBCAPA;capa_index++)
     begin
       $fwrite(File,"%10.8f",internal_energy_A2_rise[slope_index][capa_index]) ;
       if(capa_index < NBCAPA-1)
          $fwrite(File,",") ;
       else
          $fwrite(File,"\"") ;
     end
     if(slope_index < NBSLOPES-1)
        $fwrite(File,", \\\n") ;
     else
        $fwrite(File,");\n") ;
   end
// A2 fall
   for(slope_index=0;slope_index<NBSLOPES;slope_index++)
   begin
     if(slope_index == 0) 
        $fwrite(File,"    fall (\"") ;
     else
        $fwrite(File,"             ") ;
     for(capa_index=0;capa_index<NBCAPA;capa_index++)
     begin
       $fwrite(File,"%10.8f",internal_energy_A2_fall[slope_index][capa_index]) ;
       if(capa_index < NBCAPA-1)
          $fwrite(File,",") ;
       else
          $fwrite(File,"\"") ;
     end
     if(slope_index < NBSLOPES-1)
        $fwrite(File,", \\\n") ;
     else
        $fwrite(File,");\n") ;
   end
   $fwrite(File,"}\n\n") ;
   $fwrite(File,"}\n") ;
   $fclose(File) ;
   fin_test = 1 ;
end

endmodule

