// Input sequence
class in_msg extends uvm_sequence_item;
	`uvm_object_utils(in_msg)

	bit QCLK;
	rand bit QRESET;
	rand bit QWRITE;
	rand bit QSEL;
	rand bit [6:0] QADDR;
	rand bit [15:0] QDATAIN;
	realtime timestamp;

	rand logic [15:0] mcper;  // 0h
	rand logic [7:0] mcctl1;  // 2h
	rand logic [7:0] mcctl0;  // 3h
	rand logic [7:0] mccc3;   // 10h
	rand logic [7:0] mccc2;   // 11h
	rand logic [7:0] mccc1;   // 12h
	rand logic [7:0] mccc0;   // 13h
	rand logic [7:0] mccc7;   // 14h
	rand logic [7:0] mccc6;   // 15h
	rand logic [7:0] mccc5;   // 16h
	rand logic [7:0] mccc4;   // 17h
	rand logic [7:0] mccc11;  // 18h
	rand logic [7:0] mccc10;  // 19h
	rand logic [7:0] mccc9;   // 1Ah
	rand logic [7:0] mccc8;   // 1Bh
	rand logic [15:0] mcdc1;  // 20h
	rand logic [15:0] mcdc0;  // 22h
	rand logic [15:0] mcdc3;  // 24h
	rand logic [15:0] mcdc2;  // 26h
	rand logic [15:0] mcdc5;  // 28h
	rand logic [15:0] mcdc4;  // 2Ah
	rand logic [15:0] mcdc7;  // 2Ch
	rand logic [15:0] mcdc6;  // 2Eh
	rand logic [15:0] mcdc9;  // 30h
	rand logic [15:0] mcdc8;  // 32h
	rand logic [15:0] mcdc11; // 34h
	rand logic [15:0] mcdc10; // 36h
	rand logic [15:0] dataout;// output register

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


// For observing DUTY
class duty_msg;
	// count: couter for period; per: difference between previous "rising"
	// edges
	int mnm_count[11:0];
	int mnp_count[11:0];
	int mnm_duty[11:0];
	int mnp_duty[11:0];
	realtime timestamp;

	function new();
		for (int i=0; i<12; i+=1) begin
			this.mnm_count[i] = 0;
			this.mnp_count[i] = 0;
			this.mnm_duty[i] = 0;
			this.mnp_duty[i] = 0;
		end
		this.timestamp = $realtime;
	endfunction : new
endclass : duty_msg


// For observing PERIOD
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


// Expecting beginning and ending for the period counter
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


// MNM[11:0]: m0c0m, m0c1m, m1c0m, m1c1m, m2c0m, m2c1m, m3c0m, m3c1m, m4c0m,
// m4c1m, m5c0m, m5c1m
// MNP[11:0]: m0c0p, m0c1p, m1c0p, m1c1p, m2c0p, m2c1p, m3c0p, m3c1p, m4c0p,
// m4c1p, m5c0p, m5c1p 
typedef enum {zero, m0c0m, m0c1m, m1c0m, m1c1m, m2c0m, m2c1m, m3c0m, m3c1m, m4c0m, m4c1m, m5c0m, m5c1m, m0c0p, m0c1p, m1c0p, m1c1p, m2c0p, m2c1p, m3c0p, m3c1p, m4c0p, m4c1p, m5c0p, m5c1p } pin;
typedef enum {half_b_m, half_b_p, full_b, dualfull_b} mcom;
typedef enum {disabled, left, right, center} mcam;
// PWM control parameters
class control_msg;
	pin p;
	logic recirc;
	mcom mo;
	mcam ma;
	logic sign;
	logic [10:0] duty;
	logic [1:0] cd;
	realtime timestamp;

	function new(pin pp);
		this.p = pp;
		this.recirc = 0;
		this.mo = half_b_m;
		this.ma = disabled;
		this.sign = 0;
		this.duty = 0;
		this.cd = 0;
		this.timestamp = $realtime;
	endfunction : new
endclass : control_msg


// Reference of expected value (pin name, value, and timestamp) from Input
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

// Expecting PWM reference
class exp_pulse_msg;
	pin p;
	int period;
	realtime per_start;
	realtime per_end;
	logic recirc;
	mcom mo;
	mcam ma;
	logic sign;
	logic [10:0] duty;
	logic [1:0] cd;
	realtime timestamp;

	function new(pin pp, int per, realtime ps, realtime pe, logic r, mcom o, mcam a, logic s, logic[10:0] d, logic[1:0] c);
		this.p = pp;
		this.period = per;
		this.per_start = ps;
		this.per_end = pe;
		this.recirc = r;
		this.mo = o;
		this.ma = a;
		this.sign = s;
		this.duty = d;
		this.cd = c;
		this.timestamp = $realtime;
	endfunction : new
endclass : exp_pulse_msg;

// Output from the DUT
class obs_val_msg;
	logic [11:0] MNM;
       	logic [11:0] MNP;
       	realtime timestamp;

	function new();
		for (int i=0; i<12; i+=1) begin
			MNM[i] = 0;
			MNP[i] = 0;
		end
		this.timestamp = $realtime;
	endfunction : new
endclass : obs_val_msg
