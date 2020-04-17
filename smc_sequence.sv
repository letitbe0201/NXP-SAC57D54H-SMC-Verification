class smc_sequence extends uvm_sequence #(in_msg);

	`uvm_object_utils(smc_sequence)
	in_msg msg;

	function new(string name="smc_sequence");
		super.new(name);
	endfunction : new

	task body();
		msg = in_msg::type_id::create("msg");
	endtask : body

endclass : smc_sequence
