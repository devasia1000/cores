/*
Copyright 2011, The Regents of the University of California.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE REGENTS OF THE UNIVERSITY OF CALIFORNIA ''AS
IS'' AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE REGENTS OF THE UNIVERSITY OF CALIFORNIA OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT
OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those
of the authors and should not be interpreted as representing official policies,
either expressed or implied, of The Regents of the University of California.
*/

// Language: Verilog 2001

`timescale 1 ns / 1 ps

module spi_master_tb;

////////////////////////////////////////////////////////////////////////////
// DOCUMENTATION
////////////////////////////////////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////
// PARAMETERS AND CONSTANTS
////////////////////////////////////////////////////////////////////////////

localparam WIDTH=4;

////////////////////////////////////////////////////////////////////////////
// WIRES and WIRE REGS (wires that are assigned inside of an always block)
////////////////////////////////////////////////////////////////////////////

integer test = 0;

reg clk = 1'b1; // 125MHz
reg rst = 1'b0;
/*
 * Inputs
 */
reg [WIDTH-1:0] din = 4'hF;
reg miso = 1'b0;
reg spi_clk_in = 1'b1; // 12.5MHz
reg spi_clk_in_negedge = 1'b0;
reg spi_clk_in_posedge = 1'b1;
reg strobe = 1'b0;
/*
 * Outputs
 */
wire busy;
wire [WIDTH-1:0] dout;
wire mosi;
wire spi_clk_out;

////////////////////////////////////////////////////////////////////////////
// CLOCKS
////////////////////////////////////////////////////////////////////////////

always begin : clocks
   spi_clk_in = 1'b1;
   spi_clk_in_negedge = 1'b0;
   spi_clk_in_posedge = 1'b1;
   clk = 1'b1;
   #4;
   clk = 1'b0;
   #4;
   spi_clk_in_posedge = 1'b0;
   clk = 1'b1;
   #4;
   clk = 1'b0;
   #4;
   clk = 1'b1;
   #4;
   clk = 1'b0;
   #4;
   clk = 1'b1;
   #4;
   clk = 1'b0;
   #4;
   clk = 1'b1;
   #4;
   clk = 1'b0;
   #4;
   spi_clk_in = 1'b0;
   spi_clk_in_negedge = 1'b1;
   spi_clk_in_posedge = 1'b0;
   clk = 1'b1;
   #4;
   clk = 1'b0;
   #4;
   spi_clk_in_negedge = 1'b0;
   clk = 1'b1;
   #4;
   clk = 1'b0;
   #4;
   clk = 1'b1;
   #4;
   clk = 1'b0;
   #4;
   clk = 1'b1;
   #4;
   clk = 1'b0;
   #4;
   clk = 1'b1;
   #4;
   clk = 1'b0;
   #4;
end

////////////////////////////////////////////////////////////////////////////
// STIMULUS/RESPONSE
////////////////////////////////////////////////////////////////////////////

task do_test();
begin
   test = test + 1;
   @(negedge clk);
   strobe = 1'b1;
   @(negedge clk);
   strobe = 1'b0;
   @(negedge busy);
   #80;
   @(negedge clk);
end
endtask

initial begin : stimulus_response
   #100; // wait for Xilinx GSR
   // Test 1: Write F, Read 0
   din = 4'hF;
   miso = 1'b0;
   do_test();
   // Test 2: Write 0, Read F
   din = 4'h0;
   miso = 1'b1;
   do_test();
   $stop;
end

////////////////////////////////////////////////////////////////////////////
// COMPONENT INSTANTIATIONS
////////////////////////////////////////////////////////////////////////////

spi_master #(
    .WIDTH(WIDTH))
UUT (
    .clk(clk),                               // input
    .rst(rst),                               // input
    /*
     * Inputs
     */
    .din(din),                               // input [WIDTH-1:0]
    .miso(miso),                             // input
    .spi_clk_in(spi_clk_in),                 // input
    .spi_clk_in_negedge(spi_clk_in_negedge), // input
    .spi_clk_in_posedge(spi_clk_in_posedge), // input
    .strobe(strobe),                         // input
    /*
     * Outputs
     */
    .busy(busy),                             // output
    .dout(dout),                             // output [WIDTH-1:0]
    .mosi(mosi),                             // output
    .spi_clk_out(spi_clk_out),               // output
    .spi_cs_n(spi_cs_n)                      // output
);

endmodule
