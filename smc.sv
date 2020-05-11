module smc(
  input QCLK, QRESET, QWRITE, QSEL,
  input [6:0] QADDR, // address and data in same clock cycle
  input [15:0] QDATAIN,
  output [15:0] QDATAOUT,
  output [11:0] MNM, MNP); 


  //regester declairation

  reg [15:0] mcper, mcper_d;	// 0h address
  reg [7:0] mcctl1, mcctl1_d;	// 2h
  reg [7:0] mcctl0, mcctl0_d;	// 3h
  reg [7:0] mccc3, mccc3_d;	// 10h
  reg [7:0] mccc2, mccc2_d;	// 11h
  reg [7:0] mccc1, mccc1_d;	// 12h
  reg [7:0] mccc0, mccc0_d;	// 13h
  reg [7:0] mccc7, mccc7_d;	// 14h
  reg [7:0] mccc6, mccc6_d;	// 15h
  reg [7:0] mccc5, mccc5_d;	// 16h
  reg [7:0] mccc4, mccc4_d;	// 17h
  reg [7:0] mccc11, mccc11_d;	// 18h
  reg [7:0] mccc10, mccc10_d;	// 19h
  reg [7:0] mccc9, mccc9_d;	// 1Ah
  reg [7:0] mccc8, mccc8_d;	// 1Bh
  reg [15:0] mcdc1, mcdc1_d;	// 20h
  reg [15:0] mcdc0, mcdc0_d;	// 22h
  reg [15:0] mcdc3, mcdc3_d;	// 24h
  reg [15:0] mcdc2, mcdc2_d;	// 26h
  reg [15:0] mcdc5, mcdc5_d;	// 28h
  reg [15:0] mcdc4, mcdc4_d;	// 2Ah
  reg [15:0] mcdc7, mcdc7_d;	// 2Ch
  reg [15:0] mcdc6, mcdc6_d;	// 2Eh
  reg [15:0] mcdc9, mcdc9_d;	// 30h
  reg [15:0] mcdc8, mcdc8_d;	// 32h
  reg [15:0] mcdc11, mcdc11_d;	// 34h
  reg [15:0] mcdc10, mcdc10_d;	// 36h
  reg [15:0] dataout, dataout_d;// output regester

  //output assignment

  assign QDATAOUT = dataout;

  //logical block

  always @ (*) begin

    mcper_d	= mcper;
    mcctl1_d	= mcctl1;	
    mcctl0_d	= mcctl0;	
    mccc3_d	= mccc3;	
    mccc2_d	= mccc2;	
    mccc1_d	= mccc1;	
    mccc0_d	= mccc0;	
    mccc7_d	= mccc7;	
    mccc6_d	= mccc6;	
    mccc5_d	= mccc5;	
    mccc4_d	= mccc4;	
    mccc11_d	= mccc11;	
    mccc10_d	= mccc10;	
    mccc9_d	= mccc9;	
    mccc8_d	= mccc8;	
    mcdc1_d	= mcdc1;
    mcdc0_d	= mcdc0;
    mcdc3_d	= mcdc3;
    mcdc2_d	= mcdc2;
    mcdc5_d	= mcdc5;
    mcdc4_d	= mcdc4;
    mcdc7_d	= mcdc7;
    mcdc6_d	= mcdc6;
    mcdc9_d	= mcdc9;
    mcdc8_d	= mcdc8;
    mcdc11_d	= mcdc11;	
    mcdc10_d	= mcdc10;	
    dataout_d	= dataout;	
    
    if (QSEL && QWRITE) begin
      case (QADDR)
        7'h0	: mcper_d 	= QDATAIN;
        7'h2	: mcctl1_d	= QDATAIN;
        7'h3	: mcctl0_d	= QDATAIN;
        7'h10	: mccc3_d 	= QDATAIN;
        7'h11	: mccc2_d 	= QDATAIN;
        7'h12	: mccc1_d 	= QDATAIN;
        7'h13	: mccc0_d 	= QDATAIN;
        7'h14	: mccc7_d 	= QDATAIN;
        7'h15	: mccc6_d 	= QDATAIN;
        7'h16	: mccc5_d 	= QDATAIN;
        7'h17	: mccc4_d 	= QDATAIN;
        7'h18	: mccc11_d	= QDATAIN;
        7'h19	: mccc10_d	= QDATAIN;
        7'h1A	: mccc9_d 	= QDATAIN;
        7'h1B	: mccc8_d 	= QDATAIN;
        7'h20	: mcdc1_d 	= QDATAIN;
        7'h22	: mcdc0_d 	= QDATAIN;
        7'h24	: mcdc3_d 	= QDATAIN;
        7'h26	: mcdc2_d 	= QDATAIN;
        7'h28	: mcdc5_d 	= QDATAIN;
        7'h2A	: mcdc4_d 	= QDATAIN;
        7'h2C	: mcdc7_d 	= QDATAIN;
        7'h2E	: mcdc6_d 	= QDATAIN;
        7'h30	: mcdc9_d 	= QDATAIN;
        7'h32	: mcdc8_d 	= QDATAIN;
        7'h34	: mcdc11_d	= QDATAIN;
        7'h36	: mcdc10_d	= QDATAIN;
      endcase
    end
  
    if (QSEL && !QWRITE)begin
      case (QADDR)
        7'h0	: dataout_d	= mcper;
        7'h2	: dataout_d	= mcctl1;
        7'h3	: dataout_d	= mcctl0;
        7'h10	: dataout_d	= mccc3;
        7'h11	: dataout_d	= mccc2;
        7'h12	: dataout_d	= mccc1;
        7'h13	: dataout_d	= mccc0;
        7'h14	: dataout_d	= mccc7;
        7'h15	: dataout_d	= mccc6;
        7'h16	: dataout_d	= mccc5;
        7'h17	: dataout_d	= mccc4;
        7'h18	: dataout_d	= mccc11;
        7'h19	: dataout_d	= mccc10;
        7'h1A	: dataout_d	= mccc9;
        7'h1B	: dataout_d	= mccc8;
        7'h20	: dataout_d	= mcdc1;
        7'h22	: dataout_d	= mcdc0;
        7'h24	: dataout_d	= mcdc3;
        7'h26	: dataout_d	= mcdc2;
        7'h28	: dataout_d	= mcdc5;
        7'h2A	: dataout_d	= mcdc4;
        7'h2C	: dataout_d	= mcdc7;
        7'h2E	: dataout_d	= mcdc6;
        7'h30	: dataout_d	= mcdc9;
        7'h32	: dataout_d	= mcdc8;
        7'h34	: dataout_d	= mcdc11;
        7'h36	: dataout_d	= mcdc10;
      endcase
    end
  end

  //at clock and reset

  always @ (posedge QCLK or posedge QRESET) begin
    if (QRESET) begin      
      mcper	<= 0;
      mcctl1	<= 0;
      mcctl0	<= 0;
      mccc3 	<= 0;
      mccc2 	<= 0;
      mccc1 	<= 0;
      mccc0 	<= 0;
      mccc7 	<= 0;
      mccc6 	<= 0;
      mccc5 	<= 0;
      mccc4 	<= 0;
      mccc11	<= 0;
      mccc10	<= 0;
      mccc9 	<= 0;
      mccc8 	<= 0;
      mcdc1	<= 0;
      mcdc0	<= 0;
      mcdc3	<= 0;
      mcdc2	<= 0;
      mcdc5	<= 0;
      mcdc4	<= 0;
      mcdc7	<= 0;
      mcdc6	<= 0;
      mcdc9	<= 0;
      mcdc8	<= 0;
      mcdc11	<= 0;
      mcdc10	<= 0;
      dataout	<= 0;
    end
    else begin
      mcper	<= #1 mcper_d;
      mcctl1	<= #1 mcctl1_d;
      mcctl0	<= #1 mcctl0_d;
      mccc3	<= #1 mccc3_d;
      mccc2	<= #1 mccc2_d;
      mccc1	<= #1 mccc1_d;
      mccc0	<= #1 mccc0_d;
      mccc7	<= #1 mccc7_d;
      mccc6	<= #1 mccc6_d;
      mccc5	<= #1 mccc5_d;
      mccc4	<= #1 mccc4_d;
      mccc11	<= #1 mccc11_d;
      mccc10	<= #1 mccc10_d;
      mccc9	<= #1 mccc9_d;
      mccc8	<= #1 mccc8_d;
      mcdc1	<= #1 mcdc1_d;
      mcdc0	<= #1 mcdc0_d;
      mcdc3	<= #1 mcdc3_d;
      mcdc2	<= #1 mcdc2_d;
      mcdc5	<= #1 mcdc5_d;
      mcdc4	<= #1 mcdc4_d;
      mcdc7	<= #1 mcdc7_d;
      mcdc6	<= #1 mcdc6_d;
      mcdc9	<= #1 mcdc9_d;
      mcdc8	<= #1 mcdc8_d;
      mcdc11	<= #1 mcdc11_d;
      mcdc10	<= #1 mcdc10_d;
      dataout	<= #1 dataout_d;
    end
  end
endmodule
