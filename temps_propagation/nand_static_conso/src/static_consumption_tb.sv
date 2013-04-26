// On prend 1fs dans le timescale pour que les mesures de temps dans le domaine "numérique" soient précises.
// (à confirmer)
`timescale 1ns/1fs


module static_consumption_tb;

// Paramètres du testbench
parameter real digital_tick    = 100          ;    // (ns) Temps entre deux transitions du signal d'entrée

// Les signaux logiques et électriques
logic  din                ; // Signal logique destiné à piloter le test
logic  din2                ; // Signal logique destiné à piloter le test
bit    fin_test           ; // vaut 0 au débu de la simu
// Les variables adaptées ou mesurées exprimées sous forme de signaux réels. 
real capa_charge_val      ; // La valeur de la capacité de charge
real measure_int               ; // La valeur du temps de transition en entrée
logic start_measure           ; // La mesure de l'instant de changement à l'entrée de l'inverseur

// On instancie la maquette de test, en utilisant la connection générique pour simplifie l'écriture
static_consumption_bd bd0  (
                          .din(din), 
                          .din2(din2), 
                          .measure_int(measure_int),
                          .capa_charge_val(capa_charge_val),
                          .start_measure(start_measure),
                          .fin_test(fin_test)
                          ) ;

// La liste des points de test à effectuer est déterminée par 2 tables de paramètres directement
// extraite du fichier Liberty de la bibliothèque NANGATE
localparam NBVAL_DIN = 2 ;
localparam NBVAL_DIN2 = 2 ;
localparam logic DIN_VAL[0:1] = '{0,1} ; // ns
// Table pour récupérer le temps de propagation mesuré
real RESULT_TAB [0:NBVAL_DIN-1][0:NBVAL_DIN2-1] ;

///////////////////////////////////////////////////////////////
// Le testbench proprement dit défini dans le monde "logique".
///////////////////////////////////////////////////////////////

integer File ;
initial 
begin:simu
   int din_index,din2_index ;
   din = 0 ;
   din2 = 0 ;
   start_measure = 0 ;
   fin_test = 0;
   // Création du fichier de résultats
   File = $fopen("AND2_X4_static_consumption.dat") ;
   // header
   $fwrite(File,"leakage_power() {\n") ;
   // Boucle principale sur la liste des pentes d'entrée
   for(din_index=0;din_index<NBVAL_DIN;din_index++) 
   begin
     // Attention on change la valeur de la pente lorsque l'on est sur que rien ne bouge dans la partie analogique
     #(digital_tick) ; din = DIN_VAL[din_index];
     // Boucle secondaire sur la liste des capa de charge
     for(din2_index=0;din2_index<NBVAL_DIN2;din2_index++) 
     begin
       // Attention on change la valeur de la capa de charge lorsque l'on est sur que rien ne bouge dans la partie analogique
       #(digital_tick) ; din2 = DIN_VAL[din2_index];

       // takes measurement
       #(digital_tick); start_measure = ~start_measure;
       // On provoque une montée du signal de commande
       #(digital_tick) ; RESULT_TAB[din_index][din2_index] = measure_int;
       // On provoque une descente du signal de commande


       /////////////////// WRITE in FILE results ////////////////////////
       $fwrite(File,"    when : ") ;
       if (din == 0)
       begin 
        $fwrite(File, " \" !A1 & ");
       end
       else
       begin
        $fwrite(File, " \" A1 & ");
       end
       if (din2 == 0)
       begin
        $fwrite(File, "!A2 \" ");
       end
       else
       begin
        $fwrite(File, "A2 \" ");
       end
       $fwrite (File, " ;\n");

       $fwrite(File, "      value : %10.8f \n } \n ", RESULT_TAB[din_index][din2_index]);


       
     end
   end


   $fclose(File) ;
   fin_test = 1 ;

end

endmodule
