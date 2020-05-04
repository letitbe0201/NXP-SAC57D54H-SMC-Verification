`uvm_analysis_imp_decl(_ps)
`uvm_analysis_imp_decl(_cc)
class control_values extends uvm_scoreboard;

	`uvm_component_utils(control_values)
	uvm_tlm_analysis_fifo #(bit) cvififo;
	uvm_analysis_imp_ps #(period_start_msg, control_values) cvpimp;
	uvm_analysis_imp_cc #(control_msg, control_values) cvcimp;
	uvm_analysis_port #(exp_val_msg) cv_l_port;

	bit clk;
	control_msg ct_msg[24:0];
	period_start_msg ps_msg;
	exp_val_msg e_msg;
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
		cvpimp = new("cvpimp", this);
		cvcimp = new("cvcimp", this);
		cv_l_port = new("cv_l_port", this);
		e_msg = new();
		for (int i=0; i<25; i+=1) begin
			ct_msg[i] = new(zero);
		end
	endfunction : build_phase

	function void write_ps (period_start_msg ps_msg);
		per_start = ps_msg.per_start;
		per_end = ps_msg.per_end;
		period = ps_msg.period;
		//`uvm_info("CV period start", $sformatf("PERIOD%d starts at %0t, ends at %0t", period, per_start, per_end), UVM_LOW)
	endfunction : write_ps

	function void write_cc (control_msg ct);
		int i;
		i = ct.p;
		ct_msg[i] = ct;
		//`uvm_info("CV command", $sformatf("%s r%b mo:%s ma:%s s%b cd%b  %0t", ct_msg[i].p, ct_msg[i].recirc, ct_msg[i].mo, ct_msg[i].ma, ct_msg[i].sign, ct_msg[i].cd, ct_msg[i].timestamp), UVM_LOW)
	endfunction : write_cc

	task run_phase(uvm_phase phase);
		forever begin
			cvififo.get(clk);
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
				`uvm_info("CV", $sformatf("%s r%b mo:%s ma:%s s%b cd%b  %0t", ct_msg[4].p, ct_msg[4].recirc, ct_msg[4].mo, ct_msg[4].ma, ct_msg[4].sign, ct_msg[4].cd, ct_msg[4].timestamp), UVM_LOW)
				low_count = 0;
			end
			per_startold = per_start;
		end
	endtask : run_phase

endclass : control_values 
