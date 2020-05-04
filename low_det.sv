class low_det extends uvm_scoreboard;

	`uvm_component_utils(low_det)
	uvm_tlm_analysis_fifo #(obs_val_msg) ldfifo;
	uvm_analysis_imp #(exp_val_msg, low_det) ld_imp;

	obs_val_msg o_msg;
	exp_val_msg e_msg;

	// Store timestamp and obesrved pin values (Corresponding to enum pin)
	logic [24:0] s_pin;
	realtime s_time;

	function new(string name="smc_edgedet", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		ldfifo = new("ldfifo", this);
		ld_imp = new("ld_imp", this);
		e_msg = new();
	endfunction : build_phase

	function void write (exp_val_msg ep_msg);
		e_msg.p = ep_msg.p;
		e_msg.val = ep_msg.val;
		e_msg.timestamp = ep_msg.timestamp;
		//`uvm_info("LD", $sformatf("%s = %b  @%0t", e_msg.p, e_msg.val, e_msg.timestamp), UVM_LOW)
		//`uvm_info("LD", $sformatf("m0c0p = %b  |  m0c1m = %b   @%0t", s_pin[13], s_pin[2], s_time), UVM_LOW)
		if (e_msg.timestamp==s_time && e_msg.timestamp!=0) begin // Exclude time = 0
			//`uvm_info("LD", $sformatf("%0t %s %b | mnp0:%b mnm1:%b", s_time, e_msg.p, e_msg.val, s_mnp[13], s_mnm[2]), UVM_LOW)
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
	endfunction : write

	task run_phase(uvm_phase phase);
		forever begin
			ldfifo.get(o_msg);
			s_pin[12:1] = o_msg.MNM[11:0];
			s_pin[24:13] = o_msg.MNP[11:0];
			s_time = o_msg.timestamp;
			//`uvm_info("LD", $sformatf("m0c0p = %b  |  m0c1m = %b   @%0t", s_mnp[0], s_mnm[1], s_time), UVM_LOW)
		end
	endtask : run_phase

endclass : low_det 
