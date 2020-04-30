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
typedef enum {x_z, Stay, Rising, Falling} rf;
class rf_msg;
	// Rising/Falling status of each port
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


// Input detector message
typedef enum {empty, mcper, mcctl1, mcctl0, mccc3, mccc2, mccc1, mccc0, mccc7, mccc6, mccc5, mccc4, mccc11, mccc10, mccc9, mccc8, mcdc1, mcdc0, mcdc3, mcdc2, mcdc5, mcdc4, mcdc7, mcdc6, mcdc9, mcdc8, mcdc11, mcdc10} regsss;
class command_msg;
	// r: control register; data: data stored in the address
	regsss r;
	logic [15:0] data;
	realtime timestamp;

	function new(regsss R, logic D);
		r = R;
		data = D;
		this.timestamp = $realtime;
	endfunction : new
endclass : command_msg;


class period_msg;
	// count: couter for period; per: difference between previous "rising"
	// edges
	int mnm_count[11:0];
	int mnp_count[11:0];
	int mnm_per[11:0];
	int mnp_per[11:0];
	realtime timestamp;

	function new();
		for (int i=0; i<12; i+=1) begin
			this.mnm_count[i] = 0;
			this.mnp_count[i] = 0;
			this.mnm_per[i] = 0;
			this.mnp_per[i] = 0;
		end
		this.timestamp = $realtime;
	endfunction : new
endclass : period_msg


// Expected beginning and ending for the period counter
class period_start_msg;
	int period;
	realtime per_start;
	realtime per_end;

	function new();
		this.period = 0;
		this.per_start = $realtime;
		this.per_end = $realtime + 10*period;
	endfunction : new
endclass : period_start_msg


typedef enum {zero, m0c0p, m0c0m, m0c1p, m0c1m, m1c0p, m1c0m, m1c1p, m1c1m, m2c0p, m2c0m, m2c1p, m2c1m, m3c0p, m3c0m, m3c1p, m3c1m, m4c0p, m4c0m, m4cp1, m4c1m, m5c0p, m5c0m, m5c1p, m5c1m} pin;
class exp_val_msg;
	pin p;
	logic val;
	realtime timestamp;

	function new();
		this.p = zero;
		this.val = 0;
		this.timestamp = $realtime;
	endfunction : new
endclass : exp_val_msg
