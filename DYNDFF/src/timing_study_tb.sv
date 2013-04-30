// On prend 1fs dans le timescale pour que les mesures de temps dans le domaine "numérique" soient précises.
// (à confirmer)
`timescale 1ps/1fs


module timing_study_tb;

// Paramètres du testbench
parameter real digital_tick    = 20000          ;    // (ns) Temps entre deux transitions du signal d'entrée

// Les signaux logiques et électriques
logic  din                ; // Signal logique destiné à piloter le test
logic  clk                ; // Signal logique destiné à piloter le test
wire   q                ; // Signal logique destiné à piloter le test
bit    fin_test           ; // vaut 0 au débu de la simu
// Les variables adaptées ou mesurées exprimées sous forme de signaux réels. 
real capa_charge_val      ; // La valeur de la capacité de charge
real tt_val_clk               ; // La valeur du temps de transition en entrée
real tt_val_d               ; // La valeur du temps de transition en entrée
real d_time_rise           ; 
real clk_time_rise            ;

// On instancie la maquette de test, en utilisant la connection générique pour simplifie l'écriture
setup_study_bd bd0  (
                          .din(din), 
                          .clk(clk),
                          .capa_charge_val(capa_charge_val),
                          .tt_val_clk(tt_val_clk),
                          .tt_val_d(tt_val_d),
                          .clk_rise_time(clk_time_rise),
                          .d_rise_time(d_time_rise),
                          .dout(q),
                          .fin_test(fin_test)
                          ) ;

// La liste des points de test à effectuer est déterminée par 2 tables de paramètres directement
// extraite du fichier Liberty de la bibliothèque NANGATE
localparam load_capacitance = 60.7300000;
localparam NBSLOPES_CK = 3 ;
localparam NBSLOPES_D   = 3 ;
localparam real clk_tran_values[0:NBSLOPES_CK-1] = '{0.00117378,0.0449324,0.198535} ; // ns
localparam real d_tran_values[0:NBSLOPES_D-1] = '{0.00117378,0.0449324,0.198535};// ns 
// initial setup time ns
localparam real setup_step = 8;
localparam real std_delay = 10;
// Table pour récupérer le temps de propagation mesuré
real tab_setup_time [0:1] [0:NBSLOPES_CK-1][0:NBSLOPES_D-1] ;

///////////////////////////////////////////////////////////////
// Le testbench proprement dit défini dans le monde "logique".
///////////////////////////////////////////////////////////////

always #(digital_tick/2) clk = ~clk;


integer File ;
initial 
begin:simu
   int clk_tran_index,d_tran_index;
   real prop_time ;
    

   // On teste A1 : donc on met A2 à 1 pour avoir une monté en sortie   
   din = 0 ;
   clk = 1 ;
   capa_charge_val = load_capacitance*1.0e-15;
    // Result for A1
   // Boucle principale sur la liste des pentes d'entrée
   for(clk_tran_index=0;clk_tran_index<NBSLOPES_CK;clk_tran_index++) 
   begin
     // Attention on change la valeur de la pente lorsque l'on est sur que rien ne bouge dans la partie analogique
     #(digital_tick) ; tt_val_clk = clk_tran_values[clk_tran_index]*1.0e-9  ;
     // Boucle secondaire sur la liste des capa de charge
     for(d_tran_index=0;d_tran_index<NBSLOPES_D;d_tran_index++) 
     begin
        #(digital_tick); tt_val_d = d_tran_values[d_tran_index]*1.0e-9  ;
       // Attention on change la valeur de la capa de charge lorsque l'on est sur que rien ne bouge dans la partie analogique
       // On provoqueune monte du signal de commande : donc du signal de sortie

       for (int i = 500; i>=0; i--)
           begin
            #(digital_tick-i*setup_step - std_delay*tt_val_d*1.0e12) ; din = 1 ;
            #(i*setup_step + std_delay*tt_val_d*1.0e12); // resync on clk
            #(digital_tick/2);din = 0;
            // set dout to 0
            #(digital_tick/2) ;
            #(digital_tick);
          end
     end
   end
   fin_test = 1 ;
end
endmodule
