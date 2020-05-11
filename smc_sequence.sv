class smc_sequence extends uvm_sequence #(in_msg);

	`uvm_object_utils(smc_sequence)
	in_msg msg;

	function new(string name="smc_sequence");
		super.new(name);
	endfunction : new

	task body();
		msg = in_msg::type_id::create("msg");
		msg.rand_mode(0);
		def(); // set default value
		
		//test period
		msg.mcper.rand_mode(1);
		repeat (5000) period();
		msg.mcper.rand_mode(0);
		def();
		
		//test interupt
		msg.mcctl1.rand_mode(1);
		msg.mcctl0.rand_mode(1);
		repeat (10) interupt();
		msg.mcctl1.rand_mode(0);
		msg.mcctl0.rand_mode(0);
		def();
		
		//test frequency
		msg.mcctl0.rand_mode(1);
		repeat (100) freq();
		//test halt
		repeat (100) halt();
		msg.mcctl0.rand_mode(0);
		def();

		//random test cases
		msg.rand_mode(1);
		msg.mcper.rand_mode(0);
		msg.mcctl1.rand_mode(0);
		msg.mcctl0.rand_mode(0);
		repeat (50000) test();
		
	endtask : body

	task def(); // default test
		start_item(msg);

		msg.mcper	= 16'h 0080;
		msg.mcctl1	= 8'h 81;	
		msg.mcctl0	= 8'h 04;	
		msg.mccc3	= 8'h 90;	
		msg.mccc2	= 8'h 90;	
		msg.mccc1	= 8'h 90;	
		msg.mccc0	= 8'h 90;	
		msg.mccc7	= 8'h 90;	
		msg.mccc6	= 8'h 90;	
		msg.mccc5	= 8'h 90;	
		msg.mccc4	= 8'h 90;	
		msg.mccc11	= 8'h 90;	
		msg.mccc10	= 8'h 90;	
		msg.mccc9	= 8'h 90;	
		msg.mccc8	= 8'h 90;	
		msg.mcdc1	= 16'h 0040;
		msg.mcdc0	= 16'h 0040;
		msg.mcdc3	= 16'h 0040;
		msg.mcdc2	= 16'h 0040;
		msg.mcdc5	= 16'h 0040;
		msg.mcdc4	= 16'h 0040;
		msg.mcdc7	= 16'h 0040;
		msg.mcdc6	= 16'h 0040;
		msg.mcdc9	= 16'h 0040;
		msg.mcdc8	= 16'h 0040;
		msg.mcdc11	= 16'h 0040;	
		msg.mcdc10	= 16'h 0040;	

		finish_item(msg);
	endtask : def

	task period(); //to check period
		start_item(msg);
		msg.randomize() with {msg.mcper[15:11] == 5'b0;};
		finish_item(msg);
	endtask : period

	task interupt(); // to test interupt
		start_item(msg);
		msg.randomize() with {msg.mcctl1[6:1] == 6'b0; msg.mcctl0[7:1] == 7'b0;};
		finish_item(msg);
	endtask: interupt

	task freq(); // to test freq 
		start_item(msg);
		msg.randomize() with {msg.mcctl0[7] == 0; msg.mcctl0[4:0] == 5'b0;};
		finish_item(msg);
	endtask : freq

	task halt(); // to test halt
		start_item(msg);
		msg.randomize() with {msg.mcctl0[7:5] == 3'b0; mcctl0[3:0] == 4'b0100;};
		finish_item(msg);
	endtask : halt

	task test(); // random test cases
		start_item(msg);
		msg.randomize() with {
		msg.mccc0[3:2] == 2'b0;
		msg.mccc1[3:2] == 2'b0;
		msg.mccc2[3:2] == 2'b0;
		msg.mccc3[3:2] == 2'b0;
		msg.mccc4[3:2] == 2'b0;
		msg.mccc5[3:2] == 2'b0;
		msg.mccc6[3:2] == 2'b0;
		msg.mccc7[3:2] == 2'b0;
		msg.mccc8[3:2] == 2'b0;
		msg.mccc9[3:2] == 2'b0;
		msg.mccc10[3:2] == 2'b0;
		msg.mccc11[3:2] == 2'b0;

		msg.mcdc0[14] == msg.mcdc0[13] == msg.mcdc0[12] == msg.mcdc0[11] == msg.mcdc0[15];
		msg.mcdc1[14] == msg.mcdc1[13] == msg.mcdc1[12] == msg.mcdc1[11] == msg.mcdc1[15];
		msg.mcdc2[14] == msg.mcdc2[13] == msg.mcdc2[12] == msg.mcdc2[11] == msg.mcdc2[15];
		msg.mcdc3[14] == msg.mcdc3[13] == msg.mcdc3[12] == msg.mcdc3[11] == msg.mcdc3[15];
		msg.mcdc4[14] == msg.mcdc4[13] == msg.mcdc4[12] == msg.mcdc4[11] == msg.mcdc4[15];
		msg.mcdc5[14] == msg.mcdc5[13] == msg.mcdc5[12] == msg.mcdc5[11] == msg.mcdc5[15];
		msg.mcdc6[14] == msg.mcdc6[13] == msg.mcdc6[12] == msg.mcdc6[11] == msg.mcdc6[15];
		msg.mcdc7[14] == msg.mcdc7[13] == msg.mcdc7[12] == msg.mcdc7[11] == msg.mcdc7[15];
		msg.mcdc8[14] == msg.mcdc8[13] == msg.mcdc8[12] == msg.mcdc8[11] == msg.mcdc8[15];
		msg.mcdc9[14] == msg.mcdc9[13] == msg.mcdc9[12] == msg.mcdc9[11] == msg.mcdc9[15];
		msg.mcdc10[14] == msg.mcdc10[13] == msg.mcdc10[12] == msg.mcdc10[11] == msg.mcdc10[15];
		msg.mcdc11[14] == msg.mcdc11[13] == msg.mcdc11[12] == msg.mcdc11[11] == msg.mcdc11[15];};
		finish_item(msg);
	endtask : test

endclass : smc_sequence
