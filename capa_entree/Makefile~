# Ou se trouve le projet
export PRJDIR = $(realpath .)
export SRCDIR = $(PRJDIR)/src
# Le circuit (testbench) à simuler
export BD_MODULE=slope_bd
export TB_MODULE=slope_tb
#export BD_MODULE=rise_capacitance_bd
#export TB_MODULE=rise_capacitance_tb
#export BD_MODULE=propagation_time_bd
#export TB_MODULE=propagation_time_tb
export BD_SRCFILE=$(SRCDIR)/$(BD_MODULE).vams
export TB_SRCFILE=$(SRCDIR)/$(TB_MODULE).sv
export SIMU_CMDFILE=$(SRCDIR)/vasim.cmd
export SIMU_DOFILE=$(SRCDIR)/vasim.do
# 
WORKSIM=worksim
SIMU_MAKEFILE=Makefile_simu

.PHONY: compile simu_gui simu_batch

compile: $(WORKSIM)
	make -C $(WORKSIM) compile

simu_gui: $(WORKSIM)
	make -C $(WORKSIM) simu_gui

simu_batch: $(WORKSIM)
	make -C $(WORKSIM) simu_batch

$(WORKSIM):  $(SIMU_MAKEFILE) $(SIMU_CMDFILE) $(SIMU_DOFILE)
	@rm -rf $@
	mkdir $@ 
	cp $(SIMU_MAKEFILE) $@/Makefile
	cp $(SIMU_CMDFILE) $@/tmp.cmd
	cp $(SIMU_DOFILE) $@/tmp.do

clean:
	@rm -rf $(WORKSIM)




