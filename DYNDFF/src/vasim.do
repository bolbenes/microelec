add wave \
  :timing_study_tb:bd0:tt_val_clk \
  :timing_study_tb:q \
  :timing_study_tb:clk_time_rise \
  :timing_study_tb:d_time_rise \
  :timing_study_tb:bd0:tt_val_d \
  :timing_study_tb:bd0:din \
  :timing_study_tb:bd0:clk \
  :timing_study_tb:bd0:din_real \
  :timing_study_tb:bd0:clk_real \
  :timing_study_tb:bd0:dyn_dff:D \
  :timing_study_tb:bd0:dyn_dff:CK \
  :timing_study_tb:bd0:dyn_dff:Q
run -all
exit
