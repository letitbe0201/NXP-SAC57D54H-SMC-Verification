class control_values extends uvm_scoreboard;

	`uvm_component_utils(control_values)
	uvm_tlm_analysis_fifo #(in_msg) cvififo;
	uvm_tlm_analysis_fifo #(command_msg) cvcfifo;
	uvm_analysis_imp #(period_start_msg, control_values) cvimp;
	uvm_analysis_port #(exp_val_msg) cv_l_port;

	in_msg i_msg;
	command_msg c_msg;
	period_start_msg ps_msg;
	exp_val_msg e_msg;
	control_msg ct_msg;
	realtime per_start = 0, per_startold = 0;
	realtime per_end = 0;
	int period = 0;
	pin p;
	int low_count = 0; // Counting time for released pins (period = 0)

	function new(string name="control_values", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cvififo = new("cvififo", this);
		cvcfifo = new("cvcfifo", this);
		cvimp = new("cvimp", this);
		cv_l_port = new("cv_l_port", this);
		e_msg = new();
		ct_msg = new(zero);
	endfunction : build_phase

	function void write (period_start_msg ps_msg);
		per_start = ps_msg.per_start;
		per_end = ps_msg.per_end;
		period = ps_msg.period;
		//`uvm_info("CV", $sformatf("PERIOD%d starts at %0t, ends at %0t", period, per_start, per_end), UVM_LOW)
	endfunction : write

	task run_phase(uvm_phase phase);
		forever begin
			cvififo.get(i_msg);
			if (!period) begin
				for (int i=1; i<25; i+=1) begin
					e_msg.p = p.first();
					e_msg.p = p.next(i);
					e_msg.val = 0;
					e_msg.timestamp = per_start + 10*low_count; // CLOCK RELATED
					//`uvm_info("CV", $sformatf("%s = %b @ %0t", e_msg.p, e_msg.val, e_msg.timestamp), UVM_LOW)
					cv_l_port.write(e_msg);
				end			
				low_count += 1;
			end
			else if (per_start == per_startold) begin
				//`uvm_info("CV", $sformatf("Nothing happens"), UVM_LOW)
			end
			else begin
				`uvm_info("CV", $sformatf("PERIOD%d starts at %0t, ends at %0t", period, per_start, per_end), UVM_LOW)
				low_count = 0;
			end
			per_startold = per_start;
		end
	endtask : run_phase

endclass : control_values 
