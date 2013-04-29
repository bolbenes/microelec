
add wave \
  :timing_study_tb:bd0:din0 \
    :timing_study_tb:bd0:din1 \
        :timing_study_tb:bd0:din_real0 \
          :timing_study_tb:bd0:din_real1 \
            :timing_study_tb:bd0:dout \
              :timing_study_tb:bd0:tt_val \
                :timing_study_tb:bd0:start_time \
                  :timing_study_tb:bd0:stop_time \
                  :timing_study_tb:start_time \
                  :timing_study_tb:stop_time \
  :timing_study_tb:bd0:tmp_start_tran_time \
    :timing_study_tb:bd0:tmp_stop_tran_time \
        :timing_study_tb:bd0:start_tran_time \
          :timing_study_tb:bd0:stop_tran_time
run -all
exit
