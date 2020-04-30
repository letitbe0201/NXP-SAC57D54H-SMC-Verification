class control_values extends uvm_scoreboard;

	`uvm_component_utils(control_values)
	uvm_tlm_analysis_fifo #(in_msg) cvififo;
	uvm_analysis_imp #(period_start_msg, control_values) cvimp;
	//uvm_analysis_port #(cv_msg) cv_port;

	in_msg i_msg;
	period_start_msg ps_msg;
	exp_val_msg e_msg;
	realtime per_start = 0, per_startold = 0;
	realtime per_end = 0;
	int period = 0;
	//cv_msg msg;

	function new(string name="control_values", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cvififo = new("cvififo", this);
		cvimp = new("cvimp", this);
		e_msg = new();
		//cv_port = new("cv_port", this);
	endfunction : build_phase

	function void write (period_start_msg ps_msg);
		per_start = ps_msg.per_start;
		per_end = ps_msg.per_end;
		period = ps_msg.period;
	endfunction : write

	task run_phase(uvm_phase phase);
		forever begin
			cvififo.get(i_msg);
/*			if (!period) begin
				
			end
			else*/ if (per_start == per_startold) begin
				//`uvm_info("CV", $sformatf("Nothing happens"), UVM_LOW)
			end
			else begin
				`uvm_info("CV", $sformatf("PERIOD%d starts at %0t", period, per_start), UVM_LOW)
			end
			per_startold = per_start;
		end
	endtask : run_phase

endclass : control_values 
