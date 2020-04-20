class smc_sequence extends uvm_sequence #(in_msg);

	`uvm_object_utils(smc_sequence)
	in_msg msg;

	function new(string name="smc_sequence");
		super.new(name);
	endfunction : new

	task body();
		msg = in_msg::type_id::create("msg");
		
		start_item(msg);
		assert(msg.randomize() with{QRESET==0; QWRITE==1; QSEL==1; QADDR==7'b0; QDATAIN[15:11]==5'b0;});
		finish_item(msg);

		start_item(msg);
		assert(msg.randomize() with{QRESET==0; QWRITE==1; QSEL==1; QADDR==7'b0000010; QDATAIN[15:8]==0; QDATAIN[6:1]==0; QDATAIN[0]==1;});
		finish_item(msg);

		start_item(msg);
		assert(msg.randomize() with{QRESET==0; QWRITE==1; QSEL==1; QADDR==7'b0; QDATAIN[15:11]==5'b0;});
		finish_item(msg);

		start_item(msg);
		assert(msg.randomize() with{QRESET==0; QWRITE==1; QSEL==1; QADDR==7'b1111111;});
		finish_item(msg);


	endtask : body

endclass : smc_sequence
