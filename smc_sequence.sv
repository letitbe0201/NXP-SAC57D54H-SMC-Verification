class smc_sequence extends uvm_sequence #(in_msg);

	`uvm_object_utils(smc_sequence)
	in_msg msg;

	function new(string name="smc_sequence");
		super.new(name);
	endfunction : new

	task body();
		msg = in_msg::type_id::create("msg");

		start_item(msg);
		assert(msg.randomize() with{QRESET==1; QWRITE==0; QSEL==0; QADDR==0; QDATAIN==10;});
		finish_item(msg);

		start_item(msg);
		assert(msg.randomize() with{QRESET==0; QWRITE==1; QSEL==1; QADDR==7'b0; QDATAIN==1;});
		finish_item(msg);
		#80;
		start_item(msg);
		assert(msg.randomize() with{QRESET==0; QWRITE==1; QSEL==1; QADDR==7'b0000010; QDATAIN[15:8]==0; QDATAIN[7:0]==8'b10000000;});
		finish_item(msg);
		#150;
		start_item(msg);
		assert(msg.randomize() with{QRESET==0; QWRITE==1; QSEL==1; QADDR==7'b0; QDATAIN==0;});
		finish_item(msg);
		#30;
		start_item(msg);// MCCC3
		assert(msg.randomize() with{QRESET==0; QWRITE==1; QSEL==1; QADDR==7'b0010000; QDATAIN==8'b10110001;});
		finish_item(msg);

		start_item(msg);
		assert(msg.randomize() with{QRESET==0; QWRITE==1; QSEL==1; QADDR==7'b0; QDATAIN[15:11]==5'b0;});
		finish_item(msg);

		start_item(msg);
		assert(msg.randomize() with{QRESET==0; QWRITE==1; QSEL==1; QADDR==7'b0; QDATAIN[15:11]==5'b0; QDATAIN[10:0]==11'b00000001011;});
		finish_item(msg);

		start_item(msg);
		assert(msg.randomize() with{QRESET==0; QWRITE==1; QSEL==1; QADDR==7'b1111111;});
		finish_item(msg);
		#930;
		start_item(msg);
		assert(msg.randomize() with{QRESET==0; QWRITE==1; QSEL==1; QADDR==7'b0100100; QDATAIN[15:11]==5'b11111;});
		finish_item(msg);

		start_item(msg);
		assert(msg.randomize() with{QRESET==0; QWRITE==1; QSEL==1; QADDR==7'b0; QDATAIN[15:11]==5'b0; QDATAIN[10:0]==11'b00100100000;});
		finish_item(msg);
		
/*		start_item(msg);
		assert(msg.randomize() with{QRESET==0; QWRITE==0; QSEL==0; QADDR==0; QDATAIN==0;});
		finish_item(msg);
*/

	endtask : body

endclass : smc_sequence
