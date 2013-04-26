add wave \
  :static_consumption_tb:bd0:din \
  :static_consumption_tb:bd0:din2 \
  :static_consumption_tb:bd0:dout \
  :static_consumption_tb:bd0:output_sig0 \
  :static_consumption_tb:bd0:output_sig1 \
  :static_consumption_tb:bd0:start_measure \
  :static_consumption_tb:bd0:measure_int \
  :static_consumption_tb:bd0:tmp_intensity \
  :static_consumption_tb:bd0:tt_val \
  :static_consumption_tb:bd0:continue_consumption

run -all
exit
