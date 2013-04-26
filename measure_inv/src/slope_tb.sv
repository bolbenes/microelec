// On prend 1fs dans le timescale pour que les mesures de temps dans le domaine "numérique" soient précises.
// (à confirmer)
`timescale 1ns/1fs


module slope_tb ;
import "DPI-C" pure function real fabs(real) ;

parameter digital_tick = 10 ;
parameter real abs_prec=1e-3 ;
// Les paramètres de caractérisation (pourcentages de la pleine excursion)
// Noms et valeurs issus du fichier au format "Liberty"
parameter real  slew_lower_threshold_pct 	= 0.3 ; // fraction de la pleine excursion
parameter real  slew_upper_threshold_pct 	= 0.7 ; // fraction de la pleine excursion

// Les variables adaptées ou mesurées exprimées sous forme de signaux réels. 
real din  ;              // Signal logique destiné à piloter le test
real dout ;   // La valeur courante de la capacité témoin
bit fin_test ;
bit get_val ;


// 
slope_bd bd0 (.din(din), .dout(dout),.fin_test(fin_test),.get_val(get_val)) ;


///////////////////////////////////////////////////////////////
// Le testbench proprement dit défini dans le monde "logique".
///////////////////////////////////////////////////////////////
integer File ;
initial 
begin:simu
   int i,nbval ;
   bit stopinf, stopsup ;
   real last_dout ;
   real toot ;
   real tabx[0:2048], taby[0:2048] ;
   real xinf0,yinf0,xinf1,yinf1 ;
   real xsup0,ysup0,xsup1,ysup1 ;
   real xinf, xsup ;
   real alpha_threshold ;
   last_dout=0.0 ;
   nbval=0 ;
   // Récupération de la fonction de transfert
   for(i=4096;i>=0;i--) 
   begin
      din = i/4096.0; 
      #(digital_tick) ; get_val = 1 ; #(digital_tick) ; get_val = 0 ;
      // recherche des points de transition
      if(fabs(dout-last_dout) >=abs_prec)
      begin
         tabx[nbval]  = (4096.0-i)/4096.0 ;
         taby[nbval]  = dout ;
         last_dout = dout ;
         // recherche des points de passage aux deux seuil pour la transition
         if ((dout > slew_lower_threshold_pct) && stopinf) 
         begin
            xinf1 = tabx[nbval] ;
            yinf1 = dout ;
            stopinf = 1'b0 ;
         end
         if ((dout > slew_lower_threshold_pct) && stopsup) 
         begin
            xsup1 = tabx[nbval] ;
            ysup1 = dout ;
            stopsup = 1'b0 ;
         end
         if (dout < slew_lower_threshold_pct) 
         begin
            xinf0 = tabx[nbval]  ;
            yinf0 = dout ;
            stopinf = 1'b1 ;
         end
         if (dout < slew_upper_threshold_pct) 
         begin
            xsup0 = tabx[nbval] ;
            ysup0 = dout ;
            stopsup = 1'b1 ;
         end
         nbval++ ;
      end
   end
   // Interpolation pour le calcul des seuils de transition exact
   xinf = xinf0 + ( slew_lower_threshold_pct - yinf0) * (xinf1 -xinf0)/(yinf1-yinf0) ;
   xsup = xsup0 + ( slew_upper_threshold_pct - ysup0) * (xsup1 -xsup0)/(ysup1-ysup0) ;
   // Calcul du facteur d'homothétie pour obtenir à nouveau les bons seuils
   alpha_threshold = (slew_upper_threshold_pct - slew_lower_threshold_pct)/(xsup-xinf) ;
   $display("%10.8f \n",alpha_threshold) ;

   // Sauvegarde du fichier de données
   File = $fopen("freepdk045_cmos_transition_typ_1V1.vams") ;
   $fwrite(File,"// fonction de transfert de la logique CMOS exprimée en fraction de la pleine échelle\n") ;
   $fwrite(File,"parameter real alpha_threshold = %10.8f;\n",alpha_threshold) ;
   $fwrite(File,"parameter real tt_tablex[0:%3d] = {0.0,\n",nbval+1) ;
   for(i=0;i<nbval;i++) 
     $fwrite(File,"                                  %10.8f,\n",tabx[i]) ; 
   $fwrite(File,"                                  1.0};\n") ; 
   $fwrite(File,"\nparameter real tt_tabley[0:%3d] = {0.0,\n",nbval+1) ;
   for(i=0;i<nbval;i++) 
     $fwrite(File,"                                  %10.8f,\n",taby[i]) ; 
   $fwrite(File,"                                  1.0};\n") ; 
   $fclose(File) ;
   fin_test = 1 ;
end
endmodule
