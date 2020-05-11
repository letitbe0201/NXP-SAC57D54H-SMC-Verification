import uvm_pkg :: *;

`include "smc_pkg.svh"

module top();

	smc_intf vif();

        smc dut(vif.QCLK, vif.QRESET, vif.QWRITE, vif.QSEL, vif.QADDR, vif.QDATAIN, vif.QDATAOUT, vif.MNM, vif.MNP);

	initial begin
		repeat (1000000000) begin
			vif.QCLK = 1;
			#5;
			vif.QCLK = 0;
			#5;
		end
		$display("\n\n////////////////////////////   RAN OUT OF CLOCKS /////////////////////////////////\n\n");
		$finish;
	end

	initial begin
		vif.QRESET = 1;
		#20
	       	vif.QRESET = 0;
	end

	initial begin
		uvm_config_db #(virtual smc_intf)::set(null, "*", "intf", vif);
		run_test("smc_test");
	end

	initial begin
		$dumpfile("smc.vpd");
		$dumpvars(9,top);
	end

endmodule : top
