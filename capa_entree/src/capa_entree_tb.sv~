// On prend 1fs dans le timescale pour que les mesures de temps dans le domaine "numérique" soient précises.
// (à confirmer)
`timescale 1ns/1fs


module capa_entree_tb;

// Paramètres du testbench
parameter real digital_tick    = 7          ;    // (ns) Temps entre deux transitions du signal d'entrée

// Les signaux logiques et électriques
logic  din                ; // Signal logique destiné à piloter le test
logic  din_cst            ; // Signal logique constant sur l'autre entrée
bit    fin_test           ; // vaut 0 au débu de la simu
// Les variables adaptées ou mesurées exprimées sous forme de signaux réels. 
real capa_charge_val      ; // La valeur de la capacité de charge
real capa_test_val        ; // La valeur de la capacité variable
real tt_val               ; // La valeur du temps de transition en entrée
real circuit_propagation_time           ; // La mesure du temsp de propag du circuit
real test_propagation_time            ; // La mesure du temps de propag de circuit test

// On instancie la maquette de test, en utilisant la connection générique pour simplifie l'écriture
input_capa_bd bd0  (
                          .din(din),
			  .din_cst(din_cst),
                          .tt_val(tt_val),
                          .capa_charge_val(capa_charge_val),
                          .capa_test_val(capa_test_val),
                          .circuit_propagation_time(circuit_propagation_time),
                          .test_propagation_time(test_propagation_time),
                          .fin_test(fin_test)
                          ) ;

// La liste des points de test à effectuer est déterminée par 2 tables de paramètres directement
// extraite du fichier Liberty de la bibliothèque NANGATE
localparam NBCAPA = 10 ;
real capa_values[0:NBCAPA-1]; // fF
// Table pour récupérer le temps de propagation mesuré
real tab_prop_time_test_rise [0:NBCAPA-1];
real tab_prop_time_test_fall [0:NBCAPA-1];
real tab_prop_time_circuit [0:1];
localparam initial_capa = 0.1;
localparam final_capa = 1;

///////////////////////////////////////////////////////////////
// Le testbench proprement dit défini dans le monde "logique".
///////////////////////////////////////////////////////////////

integer File ;
initial 
begin:simu
   int capa_index ;
   din = 0 ;
   din_cst = 0;
   capa_charge_val=100*1.0e-15;
   tt_val = 0.01*1.0e-9;
   // Création de la liste des capa_test à tester
   for (capa_index=0;capa_index<NBCAPA;capa_index++)
   begin
	capa_values[capa_index]=(capa_index+1)*(final_capa-initial_capa)/NBCAPA;
   end
   // Création du fichier de résultats
   File = $fopen("AND2_X4_capa_entree.dat") ;
   // Mesures temps de propagation du circuit
       // On provoque une montée du signal de commande
       #(digital_tick) ; din = 1 ;
       // On récupère la mesure du temps de propagation (toujours en attendant que d'être dans une zone stable)
       #(digital_tick) ; tab_prop_time_circuit[0] = circuit_propagation_time/1.0e-9 ;
       // On provoque une descente du signal de commande
       #(digital_tick) ; din = 0 ;
       // On récupère la mesure du temps de propagation (toujours en attendant que d'être dans une zone stable)
       #(digital_tick) ; tab_prop_time_circuit[1] = circuit_propagation_time/1.0e-9 ;
   // Ecriture des résultats
   $fwrite(File,"prop_time_entree_circuit {\n") ;
   for(capa_index=0;capa_index<2;capa_index++)
   begin
       $fwrite(File,"%10.8f",tab_prop_time_circuit[capa_index]) ;
       if(capa_index < 1)
          $fwrite(File,",") ;
       else
          $fwrite(File,"\n\n") ;
   end
   // Boucle principale sur la liste des capa
   for(capa_index=0;capa_index<NBCAPA;capa_index++) 
   begin
       // Attention on change la valeur de la capa de charge lorsque l'on est sur que rien ne bouge dans la partie analogique
       #(digital_tick) ; capa_test_val = capa_values[capa_index]*1.0e-15  ;
       // On provoque une montée du signal de commande
       #(digital_tick) ; din = 1 ;
       // On récupère la mesure du temps de propagation (toujours en attendant que d'être dans une zone stable)
       #(digital_tick) ; tab_prop_time_test_rise[capa_index] = test_propagation_time/1.0e-9 ;
       // On provoque une descente du signal de commande
       #(digital_tick) ; din = 0 ;
       // On récupère la mesure du temps de propagation (toujours en attendant que d'être dans une zone stable)
       #(digital_tick) ; tab_prop_time_test_fall[capa_index] = test_propagation_time/1.0e-9 ;
   end
   // On a récupéré tous les temps de propagation, il n'y a plus qu'à écrire dans un fichier 
   // les résultats de mesure. Ici on utilise le format du fichier "Liberty"
   #(digital_tick) ;
   // Ecriture des résultats
$fwrite(File,"tt_vall {\n") ;
$fwrite(File,"prop_time_entree_test {\n") ;
   $fwrite(File,"%10.8f\n\n",tt_val) ;
   $fwrite(File,"    index_capa (\"") ;
   for(capa_index=0;capa_index<NBCAPA;capa_index++)
   begin
     $fwrite(File,"%10.8f",capa_values[capa_index]) ;
     if(capa_index < NBCAPA-1)
        $fwrite(File,",") ;
     else
        $fwrite(File,"\");\n") ;
   end

   $fwrite(File,"    rise (\"") ;

   for(capa_index=0;capa_index<NBCAPA;capa_index++)
   begin
       $fwrite(File,"%10.8f",tab_prop_time_test_rise[capa_index]) ;
       if(capa_index < NBCAPA-1)
          $fwrite(File,",") ;
       else
          $fwrite(File,"\"") ;
   end
   $fwrite(File,"}\n") ;

   $fwrite(File,"    fall (\"") ;

   for(capa_index=0;capa_index<NBCAPA;capa_index++)
   begin
       $fwrite(File,"%10.8f",tab_prop_time_test_fall[capa_index]) ;
       if(capa_index < NBCAPA-1)
          $fwrite(File,",") ;
       else
          $fwrite(File,"\"") ;
   end
   $fwrite(File,"}\n") ;
   $fclose(File) ;
   fin_test = 1 ;
end

endmodule
