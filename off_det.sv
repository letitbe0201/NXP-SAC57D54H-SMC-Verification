class off_det extends uvm_scoreboard;

	`uvm_component_utils(off_det)
	uvm_tlm_analysis_fifo #(obs_val_msg) odfifo;
	uvm_analysis_imp #(exp_val_msg, off_det) od_imp;

	obs_val_msg o_msg;
	exp_val_msg e_msg;

	bit e_receive = 0;
	// Store timestamp and obesrved pin values (Corresponding to enum pin)
	logic [24:0] s_pin;
	realtime s_time;

	function new(string name="off_det", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		odfifo = new("odfifo", this);
		od_imp = new("od_imp", this);
		e_msg = new();
	endfunction : build_phase

	function void write (exp_val_msg ep_msg);
		e_msg.p = ep_msg.p;
		e_msg.val = ep_msg.val;
		e_msg.timestamp = ep_msg.timestamp;
		e_receive = 1;
	endfunction : write

	task run_phase(uvm_phase phase);
		forever begin
			odfifo.get(o_msg);
			s_pin[12:1] = o_msg.MNM[11:0];
			s_pin[24:13] = o_msg.MNP[11:0];
			s_time = o_msg.timestamp;
			//`uvm_info("LD", $sformatf("m0c0p = %b  |  m0c1m = %b   @%0t", s_mnp[0], s_mnm[1], s_time), UVM_LOW)
			// Compare M&P OUTPUT when EXPECTED VALUES received
			if (e_receive) begin
				//`uvm_info("LD", $sformatf("%s = %b  @%0t", e_msg.p, e_msg.val, e_msg.timestamp), UVM_LOW)
				//`uvm_info("LD", $sformatf("m0c0p = %b  |  m0c1m = %b   @%0t", s_pin[13], s_pin[2], s_time), UVM_LOW)
				if (e_msg.timestamp==s_time && e_msg.timestamp!=0) begin // Exclude time = 0
					//`uvm_info("LD", $sformatf("%0t %s %b | mnp0:%b mnm1:%b", s_time, e_msg.p, e_msg.val, s_pin[2], s_pin[13]), UVM_LOW)
					// VERIFY: EXP = OBS = 0
					for (int i=1; i<25; i+=1) begin
						if (e_msg.p == i) begin
							if (e_msg.val == s_pin[i]) begin
								;//`uvm_info("LD", $sformatf("%s  EXP=OBS=%b  @%0t", e_msg.p, e_msg.val, e_msg.timestamp), UVM_LOW)
								/////////////// Send to RESULT
							end
							else
								`uvm_error("LD", $sformatf("%s  EXP=%b!=OBS=%b  @%0t", e_msg.p, e_msg.val, s_pin[i], e_msg.timestamp))
						end	
					end
				end
				else if (!e_msg.timestamp); // Do nothing when time = 0
				else
					`uvm_error("LD", "Timestamp mismatch!")
			end
			
			e_receive = 0;
			end
	endtask : run_phase

endclass : off_det 
