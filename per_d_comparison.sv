// COMPARE THE EXPECTING/OBSERVING PERIOD AND DUTY
class per_d_comparison extends uvm_scoreboard;

	`uvm_component_utils(per_d_comparison)
	uvm_tlm_analysis_fifo #(duty_msg) dt_fifo;
	uvm_tlm_analysis_fifo #(period_msg) prd_fifo;
	uvm_tlm_analysis_fifo #(exp_pulse_msg) epfifo;

	period_msg prd_msg;
	duty_msg dt_msg;
	exp_pulse_msg ep_msg; 

	function new(string name="per_d_comparison", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		dt_fifo = new("dt_fifo", this);
		prd_fifo = new("prd_fifo", this);
		epfifo = new("epfifo", this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			dt_fifo.get(dt_msg);
			prd_fifo.get(prd_msg);
			epfifo.get(ep_msg);
			if(ep_msg.p<12) begin
				if(dt_msg.mnm_duty[ep_msg.p]!=ep_msg.duty) begin
						`uvm_error("PER/DUTY", $sformatf("DUTY MISMATCH: %s", ep_msg.p))
				end
				else if(prd_msg.mnm_per[ep_msg.p]!=ep_msg.period) begin
						`uvm_error("PER/DUTY", $sformatf("PERIOD MISMATCH: %s", ep_msg.p))
				end
			end
			if(ep_msg.p>12) begin
				if(dt_msg.mnp_duty[ep_msg.p-12]!=ep_msg.duty) begin
						`uvm_error("PER/DUTY", $sformatf("DUTY MISMATCH: %s", ep_msg.p))
				end
				else if(prd_msg.mnp_per[ep_msg.p-12]!=ep_msg.period) begin
						`uvm_error("PER/DUTY", $sformatf("PERIOD MISMATCH: %s", ep_msg.p))
				end
			end
		end
	endtask : run_phase

endclass : per_d_comparison
