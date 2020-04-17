class smc_monin extends uvm_monitor;

	`uvm_component_utils(smc_monin)
	virtual smc_intf intf;
	uvm_analysis_port #(in_msg) monin_ag;
	uvm_analysis_port #(in_msg) drv_monin;
	in_msg msg;

	function new(string name="smc_monin", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		monin_ag = new("monin_ag", this);
		drv_monin = new("drv_monin", this);
		if (!uvm_config_db #(virtual smc_intf)::get(this, "", "intf", intf))
			`uvm_fatal("SMC MON IN", "Something wrong in intf config.")
	endfunction : build_phase

	task run_phase(uvm_phase phase);
	endtask : run_phase

endclass : smc_monin
