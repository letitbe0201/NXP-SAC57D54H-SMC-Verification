class period_counter extends uvm_scoreboard;

	`uvm_component_utils(period_counter)
	uvm_tlm_analysis_fifo #(command_msg) pcfifo;
	uvm_tlm_analysis_fifo #(in_msg) pcififo;
	uvm_analysis_port #(period_counter_msg) pc_port;

	period_counter_msg pc_msg;
	command_msg c_msg;
	command_msg c_oldmsg;
	in_msg i_msg;

	function new(string name="period_counter", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		pcfifo = new("pcfifo", this);
		pcififo = new("pcififo", this);
		pc_port = new("pc_port", this);
		pc_msg = new();
		c_msg = new(empty, 0);
		c_oldmsg = new(empty, 0);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			fork
			pcfifo.get(c_msg);
			pcififo.get(i_msg);
			join_any
			//`uvm_info("PERIOD COUNTER", $sformatf("%s |data %b| %0t", c_msg.r, c_msg.data, $realtime), UVM_LOW)
			
			// Receive new period
			if (c_msg.r==mcper && c_msg.data!=c_oldmsg.data) begin
				pc_msg.next_period = c_msg.data;
				pc_msg.per_s = counting;
				if (c_oldmsg.r==empty || pc_msg.counter==pc_msg.period) begin
					pc_msg.counter = 0;
					pc_msg.period = c_msg.data;
					pc_msg.next_period = 0;
					pc_msg.start_time = $realtime;
					pc_msg.end_time = $realtime + c_msg.data;
					if (!c_msg.data)
						pc_msg.per_s = zero;
				end
				c_oldmsg.data = c_msg.data;
				c_oldmsg.r = c_msg.r;
			end
			else begin
				if (pc_msg.per_s==counting && pc_msg.counter==pc_msg.period) begin
					if (pc_msg.next_period) begin
						pc_msg.per_s = counting;
						pc_msg.counter = 0;
						pc_msg.period = pc_msg.next_period;
						pc_msg.next_period = 0;
						pc_msg.start_time = $realtime;
						pc_msg.end_time = $realtime + pc_msg.period;
					end
					else begin
						pc_msg.per_s = zero;
						pc_msg.counter = 0;
						pc_msg.period = 0;
						pc_msg.next_period = 0;
						pc_msg.start_time = 0;
						pc_msg.end_time = 0;
					end
				end
			end
			pc_msg.timestamp = $realtime;
			pc_port.write(pc_msg);
			`uvm_info("PERIOD COUNTER", $sformatf("%s | counter %d | per %d | nextper %d | %0t", pc_msg.per_s, pc_msg.counter, pc_msg.period, pc_msg.next_period, pc_msg.timestamp), UVM_LOW)
			if (pc_msg.period)
				pc_msg.counter += 1;
		end
	endtask : run_phase

endclass : period_counter
