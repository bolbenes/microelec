
add wave \
  :timing_study_tb:bd0:din0 \
    :timing_study_tb:bd0:din1 \
      :timing_study_tb:bd0:din_real_1 \
        :timing_study_tb:bd0:din_real0 \
          :timing_study_tb:bd0:din_real1 \
            :timing_study_tb:bd0:dout
            add wave \
              :timing_study_tb:bd0:tt_val \
                :timing_study_tb:bd0:start_time \
                  :timing_study_tb:bd0:stop_time
                  add wave  \
                  :timing_study_tb:start_time \
                  :timing_study_tb:stop_time \
                  :timing_study_tb:tab_prop_time

run -all
exit
