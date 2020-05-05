class smc_env extends uvm_env;

	`uvm_component_utils(smc_env)

	virtual smc_intf intf;

	smc_agent agent;
	smc_clk clk;
	smc_edgedet edet;
	smc_pinval pv;
	smc_commanddet cdet;
	control_col cc;
	off_det od;
	low_det ld;
	smc_period per;
	smc_period_start ps;
	control_values cv;

	function new(string name="smc_env", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		agent = smc_agent::type_id::create("agent", this);
		clk = smc_clk::type_id::create("clk", this);
		edet = smc_edgedet::type_id::create("edet", this);
		pv = smc_pinval::type_id::create("pv", this);
		cdet = smc_commanddet::type_id::create("cdet", this);
		cc = control_col::type_id::create("cc", this);
		od = off_det::type_id::create("od", this);
		ld = low_det::type_id::create("ld", this);
		per = smc_period::type_id::create("per", this);
		ps = smc_period_start::type_id::create("ps", this);
		cv = control_values::type_id::create("cv", this);
		if (!uvm_config_db #(virtual smc_intf)::get(this, "", "intf", intf))
			`uvm_fatal("SMC ENV", "Something wrong in intf config.")
		uvm_config_db #(virtual smc_intf)::set(this, "agent", "intf", intf);
	endfunction : build_phase
	
	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agent.ag_out.connect(edet.edfifo.analysis_export);
		agent.ag_out.connect(pv.pvfifo.analysis_export);
		agent.ag_in.connect(clk.clkfifo.analysis_export);
		agent.ag_in.connect(cdet.cdfifo.analysis_export);
		agent.ag_in.connect(ps.psififo.analysis_export);
		clk.clk_port.connect(cv.cvififo.analysis_export);
		clk.clk_port.connect(cc.ccclkfifo.analysis_export);
		edet.ed_port.connect(per.pfifo.analysis_export);
		ps.ps_port.connect(cv.cvpimp);
		cdet.cd_port.connect(cc.cccfifo.analysis_export);
		cc.cc_port.connect(cv.cvcimp);
		cv.cv_off_port.connect(od.od_imp);
		cv.cv_l_port.connect(ld.ld_imp);
		pv.pv_port.connect(od.odfifo.analysis_export);
		pv.pv_port.connect(ld.ldfifo.analysis_export);
	endfunction : connect_phase

endclass : smc_env
