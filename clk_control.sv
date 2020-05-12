// Clock for reference model (Control by the prescalar MCPRE)
class clk_control extends uvm_scoreboard;

	`uvm_component_utils(clk_control)
	uvm_tlm_analysis_fifo #(in_msg) clkfifo;
	uvm_tlm_analysis_fifo #(command_msg) comfifo;
	uvm_analysis_port #(bit) clk_port;

	in_msg i_msg;
	command_msg c_msg;
	
	// Prescalar of the SMC
	int presc = 1;
	int counter = 0;

	function new(string name="clk_control", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		clkfifo = new("clkfifo", this);
		comfifo = new("comfifo", this);
		clk_port = new("clk_port", this);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			fork 
			begin
				clkfifo.get(i_msg);
				counter += 1;
				if (counter == presc) begin
					// Send CLK TIME and VALUE
					clk_port.write(i_msg.QCLK);
					counter = 0;
				end
			end
			begin
				comfifo.get(c_msg);
				if (c_msg.r == mcctl0) begin
					case(c_msg.data[6:5])
						00:
							presc = 1;
						01:
							presc = 2;
						10:
							presc = 4;
						11:
							presc = 8;
						default:
							presc = 1;
					endcase
				end
			end
			join_any;
		end
	endtask : run_phase
endclass : clk_control
