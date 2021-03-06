// Send a message out whenever a new commnd input comes in
class commanddet extends uvm_scoreboard;

	`uvm_component_utils(commanddet)
	uvm_tlm_analysis_fifo #(in_msg) cdfifo;
	uvm_analysis_port #(command_msg) cd_port;

	in_msg i_msg;
	logic [6:0] old_addr;
	logic [15:0] old_data;
	command_msg c_msg;

	function new(string name="commanddet", uvm_component par=null);
		super.new(name, par);
	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		cdfifo = new("cdfifo", this);
		cd_port = new("cd_port", this);
		c_msg = new(empty, 0);
	endfunction : build_phase

	task run_phase(uvm_phase phase);
		forever begin
			cdfifo.get(i_msg);
			//`uvm_info("COMMAND DET", $sformatf("%b %b %b %b", i_msg.QADDR, old_addr, i_msg.QDATAIN, old_data), UVM_LOW)
			if ((i_msg.QADDR!=old_addr) || (i_msg.QDATAIN!=old_data)) begin
				case (i_msg.QADDR)
					7'b0000000: c_msg.r = mcper;
					7'b0000010: c_msg.r = mcctl1;
					7'b0000011: c_msg.r = mcctl0;
					7'b0010000: c_msg.r = mccc3;
					7'b0010001: c_msg.r = mccc2;
					7'b0010010: c_msg.r = mccc1;
					7'b0010011: c_msg.r = mccc0;
					7'b0010100: c_msg.r = mccc7;
					7'b0010101: c_msg.r = mccc6;
					7'b0010110: c_msg.r = mccc5;
					7'b0010111: c_msg.r = mccc4;	
					7'b0011000: c_msg.r = mccc11;	
					7'b0011001: c_msg.r = mccc10;	
					7'b0011010: c_msg.r = mccc9;	
					7'b0011011: c_msg.r = mccc8;	
					7'b0100000: c_msg.r = mcdc1;	
					7'b0100010: c_msg.r = mcdc0;	
					7'b0100100: c_msg.r = mcdc3;	
					7'b0100110: c_msg.r = mcdc2;	
					7'b0101000: c_msg.r = mcdc5;	
					7'b0101010: c_msg.r = mcdc4;	
					7'b0101100: c_msg.r = mcdc7;	
					7'b0101110: c_msg.r = mcdc6;	
					7'b0110000: c_msg.r = mcdc9;	
					7'b0110010: c_msg.r = mcdc8;	
					7'b0110100: c_msg.r = mcdc11;	
					7'b0110110: c_msg.r = mcdc10;
					default: c_msg.r = empty;	
				endcase
				c_msg.timestamp = $realtime;
				c_msg.data = i_msg.QDATAIN;
//				`uvm_info("COMMAND DET", $sformatf("%s = %b @ %0t", c_msg.r, c_msg.data, c_msg.timestamp), UVM_LOW)
				// write to the port when INPUT changes
				cd_port.write(c_msg);
			end
			old_addr = i_msg.QADDR;
			old_data = i_msg.QDATAIN;
		end
	endtask : run_phase

endclass : commanddet
