class smc_period_start extends uvm_scoreboard;

	`uvm_component_utils(smc_period_start)
	uvm_tlm_analysis_fifo #(in_msg) psififo;
	uvm_analysis_port #(period_start_msg) ps_port;

	period_start_msg ps_msg;
	in_msg i_msg;

	int period = 0;
	int next_period = 0;
	int counter = 0;

	function new(string name="smc_period_start", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		psififo = new("psififo", this);
		ps_port = new("ps_port", this);
		ps_msg = new();
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			psififo.get(i_msg);
			//`uvm_info("PERIOD START", $sformatf("Counter%d", counter), UVM_LOW)

			// Receive new PERIOD
			if (!i_msg.QADDR && i_msg.QDATAIN!=period) begin
				next_period = i_msg.QDATAIN;
				//`uvm_info("PERIOD START", $sformatf("New Period%d", i_msg.QDATAIN), UVM_LOW)
			end
			// Assign period when period=0
			if (!period && next_period) begin
				period = next_period;
				`uvm_info("PERIOD START", $sformatf("Period%d starts at %0t", period, $realtime), UVM_LOW)
				ps_msg.period = period;
				ps_msg.per_start = $realtime;
				ps_port.write(ps_msg);
			end

			if (period > counter) begin
				counter += 1;
			end
			else if (period && period==counter) begin // Send a message when counter overflow (New period begins)
				period = next_period;
				`uvm_info("PERIOD START", $sformatf("Period%d starts at %0t", period, $realtime), UVM_LOW)
				counter = 1;
				ps_msg.period = period;
				ps_msg.per_start = $realtime;
				ps_port.write(ps_msg);
			end
		end
	endtask : run_phase

endclass : smc_period_start