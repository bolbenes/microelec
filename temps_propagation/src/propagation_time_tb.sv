// On prend 1fs dans le timescale pour que les mesures de temps dans le domaine "numérique" soient précises.
// (à confirmer)
`timescale 1ns/1fs


module propagation_time_tb;

// Paramètres du testbench
parameter real digital_tick    = 7          ;    // (ns) Temps entre deux transitions du signal d'entrée

// Les signaux logiques et électriques
logic  din                ; // Signal logique destiné à piloter le test
bit    fin_test           ; // vaut 0 au débu de la simu
// Les variables adaptées ou mesurées exprimées sous forme de signaux réels. 
real capa_charge_val      ; // La valeur de la capacité de charge
real tt_val               ; // La valeur du temps de transition en entrée
real start_time           ; // La mesure de l'instant de changement à l'entrée de l'inverseur
real stop_time            ; // La mesure de l'instant de changement à la sortie de l'inverseur

// On instancie la maquette de test, en utilisant la connection générique pour simplifie l'écriture
propagation_time_bd bd0  (
                          .din(din), 
                          .tt_val(tt_val),
                          .capa_charge_val(capa_charge_val),
                          .start_time(start_time),
                          .stop_time(stop_time),
                          .fin_test(fin_test)
                          ) ;

// La liste des points de test à effectuer est déterminée par 2 tables de paramètres directement
// extraite du fichier Liberty de la bibliothèque NANGATE
localparam NBSLOPES = 7 ;
localparam NBCAPA = 7 ;
localparam real rise_values[0:NBSLOPES-1] = '{0.00117378,0.00472397,0.0171859,0.0409838,0.0780596,0.130081,0.198535} ; // ns
localparam real capa_values[0:NBCAPA-1] = '{0.365616,1.897810,3.795620,7.591250,15.182500,30.365000,60.730000}; // fF
// Table pour récupérer le temps de propagation mesuré
real tab_prop_time [0:NBSLOPES-1][0:NBCAPA-1] ;

///////////////////////////////////////////////////////////////
// Le testbench proprement dit défini dans le monde "logique".
///////////////////////////////////////////////////////////////

integer File ;
initial 
begin:simu
   int slope_index,capa_index ;
   real prop_time ;
   din = 0 ;
   // Création du fichier de résultats
   File = $fopen("INV_X1_prop_time.dat") ;
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
       // On provoque une montée du signal de commande
       #(digital_tick) ; din = 1 ;
       // On récupère la mesure du temps de propagation (toujours en attendant que d'être dans une zone stable)
       #(digital_tick) ; tab_prop_time[slope_index][capa_index] = (stop_time - start_time)/1.0e-9 ;
       // On provoque une descente du signal de commande
       #(digital_tick) ; din = 0 ;
     end
   end
   // On a récupéré tous les temps de propagation, il n'y a plus qu'à écrire dans un fichier 
   // les résultats de mesure. Ici on utilise le format du fichier "Liberty"
   #(digital_tick) ;
   // Ecriture des résultats
   $fwrite(File,"cell_rise(Timing_7_7) {\n") ;
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

   for(slope_index=0;slope_index<NBSLOPES;slope_index++)
   begin
     if(slope_index == 0) 
        $fwrite(File,"    values (\"") ;
     else
        $fwrite(File,"             ") ;
     for(capa_index=0;capa_index<NBCAPA;capa_index++)
     begin
       $fwrite(File,"%10.8f",tab_prop_time[slope_index][capa_index]) ;
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
   $fwrite(File,"}\n") ;
   $fclose(File) ;
   fin_test = 1 ;
end

endmodule
