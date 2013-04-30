`line 4
module vloga_dig_submod_conso_dyn_bd(start_tick,stop_tick,capa_charge_val,internal_energy,fin_test);
parameter real alim_voltage = 0.0;
parameter real slew_lower_threshold_pct = 0.0;
parameter real slew_upper_threshold_pct = 0.0;
parameter real input_threshold_pct = 0.0;
parameter real output_threshold_pct = 0.0;
input  start_tick ;
input  stop_tick ;
input wreal capa_charge_val ;
output wreal internal_energy ;
input  fin_test ;
endmodule

