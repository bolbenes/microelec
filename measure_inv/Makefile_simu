WORKLIB=work
NANGATE_LIB=/comelec/softs/opt/nangate/TPT/verilogams/NangateLibWithParasitics

.PHONY: compile simu_gui simu_batch

compile: .tagcomp

.tagcomp : .tag_tb .tag_bd
	touch  .tagcomp

.tag_tb: $(TB_SRCFILE) $(WORKLIB)
	vlog_ams  -work $(WORKLIB) $(TB_SRCFILE)
	touch $@

.tag_bd: $(BD_SRCFILE) $(WORKLIB)
	valog  -work $(WORKLIB) $(BD_SRCFILE)
	touch $@

simu_gui: .mapped .tagcomp
	vasim -L nangatelib -cmd tmp.cmd  $(TB_MODULE)

simu_batch: .mapped .tagcomp
	vasim -c -L nangatelib -cmd tmp.cmd  $(TB_MODULE) -do tmp.do

.mapped: $(WORKLIB) $(NANGATE_LIB)
	vamap nangatelib $(NANGATE_LIB) 
	vamap work $(WORKLIB) 
	touch .mapped

$(WORKLIB):
	valib $@

