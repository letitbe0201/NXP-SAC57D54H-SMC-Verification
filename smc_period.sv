class smc_period extends uvm_scoreboard;

	`uvm_component_utils(smc_period)
	uvm_tlm_analysis_fifo #(rf_msg) pfifo;
	uvm_analysis_port #(period_msg) p_port;

	period_msg p_msg;
	rf_msg r_msg;

	function new(string name="smc_period", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		pfifo = new("pfifo", this);
		p_port = new("p_port", this);
		p_msg = new();
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			pfifo.get(r_msg);
			for (int i=0; i<12; i+=1) begin

				if (r_msg.rf_mnm[i] == Rising) begin
					p_msg.mnm_count[i] += 1;
					p_msg.mnm_per[i] = p_msg.mnm_count[i];
					p_msg.mnm_count[i] = 0;
				end
				else if (r_msg.rf_mnm[i] == x_z) begin
					p_msg.mnm_count[i] = 0;
					//`uvm_info("PERIOD", "x or z shows up.", UVM_LOW)
				end
				else
					p_msg.mnm_count[i] += 1;

				if (r_msg.rf_mnp[i] == Rising) begin
					p_msg.mnp_count[i] += 1;
					p_msg.mnp_per[i] = p_msg.mnp_count[i];
					p_msg.mnp_count[i] = 0;
				end
				else if (r_msg.rf_mnp[i] == x_z) begin
					p_msg.mnp_count[i] = 0;
					//`uvm_info("PERIOD", "x or z shows up.", UVM_LOW)
				end
				else
					p_msg.mnp_count[i] += 1;

			end
			p_msg.timestamp = $realtime;
			p_port.write(p_msg);
			//`uvm_info("PERIOD", $sformatf("mnm1 p:%d c:%d  %0t", p_msg.mnm_per[1], p_msg.mnm_count[1], p_msg.timestamp), UVM_LOW)
			//`uvm_info("PERIOD", $sformatf("mnp0 p:%d c:%d  %0t", p_msg.mnp_per[0], p_msg.mnp_count[0], p_msg.timestamp), UVM_LOW)
		end
	endtask : run_phase
endclass : smc_period
