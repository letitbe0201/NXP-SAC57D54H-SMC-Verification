// Input sequence
class in_msg extends uvm_sequence_item;

	`uvm_object_utils(in_msg)

	rand bit QRESET;
	rand bit QWRITE;
	rand bit QSEL;
	rand bit [6:0] QADDR;
	rand bit [15:0] QDATAIN;
	realtime timestamp;

	function new(string name="in_msg");
		super.new(name);
	endfunction : new

endclass : in_msg


// Output from DUT
class out_msg extends uvm_sequence_item;

	`uvm_object_utils(out_msg)

	logic [15:0] QDATAOUT;
	logic [11:0] MNM;
	logic [11:0] MNP;
	realtime timestamp;

	function new(string name="out_msg");
		super.new(name);
	endfunction : new

endclass : out_msg

// Edge detector message
typedef enum {Stay, Rising, Falling} rf;

class rf_msg;

	rf rf_mnm[11:0];
	rf rf_mnp[11:0];
	realtime timestamp;

	function new(rf r);
		for (int i=0; i<12; i+=1) begin
			this.rf_mnm[i] = r;
			this.rf_mnp[i] = r;
		end
		this.timestamp = $realtime;
	endfunction : new

endclass : rf_msg

typedef enum {mcper, mcctl1, mcctl0, mccc3, mccc2, mccc1, mccc0, mccc7, mccc6, mccc5, mccc4, mccc11, mccc10, mccc9, mccc8, mcdc1, mcdc0, mcdc3, mcdc2, mcdc5, mcdc4, mcdc7, mcdc6, mcdc9, mcdc8, mcdc11, mcdc10, empty} regsss;
class command_msg;

	regsss r;
	logic [15:0] data;
	realtime timestamp;

	function new(regsss R, logic D);
		r = R;
		data = D;
		this.timestamp = $realtime;
	endfunction : new

endclass : command_msg;