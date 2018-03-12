TIME=500ns
GHDL_SIM_OPT = --stop-time=$(TIME)
GHDL_FLAGS = --ieee=synopsys -fexplicit
WORKDIR = Simulate
TOP_ENTITY = top_tb
compile:
	mkdir -p $(WORKDIR)
	ghdl -i --workdir=$(WORKDIR) *.vhd
	ghdl -m $(GHDL_FLAGS) --workdir=Simulate/ $(TOP_ENTITY)
	ghdl -r --workdir=$(WORKDIR) $(TOP_ENTITY) --stop-time=$(TIME) --wave=$(TOP_ENTITY).ghw --vcd=$(TOP_ENTITY).vcd

clean:
	rm -rf Simulate
	rm -f $(TOP_ENTITY).ghw
	rm -f e~$(TOP_ENTITY).o
	rm -f $(TOP_ENTITY).vhd
