class smc_driver extends uvm_driver #(in_msg);

	`uvm_component_utils(smc_driver)
	virtual smc_intf intf;
	uvm_analysis_port #(in_msg) drv_monin;

	function new(string name="smc_driver", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		drv_monin = new("drv_monin", this);
		if (!uvm_config_db #(virtual smc_intf)::get(this, "", "intf", intf))
			`uvm_fatal("SMC DRIVER", "Something wrong in intf config.")
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction : connect_phase

	task run_phase(uvm_phase phase);
	endtask : run_phase

endclass : smc_driver
