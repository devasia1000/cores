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

/*
 * A simple timer that expires after a specified number of clock ticks.
 */
module timer (
    input wire arm,
    input wire clk,
    input wire en,
    output wire fire
);

`include "log2.vh"

parameter TIMER_PERIOD_NS=80; // how long until the timer fires
parameter CLOCK_PERIOD_NS=8;  // period of the common clock
parameter NTICKS=TIMER_PERIOD_NS/CLOCK_PERIOD_NS; // overridable if necessary
localparam NBITS=log2(NTICKS); // size of state register

reg [NBITS-1:0] state_reg = 0, state_next;
always @* begin
    state_next = state_reg;
    if (arm)
        state_next = NTICKS - 1;
    else if (en & state_reg != 0)
        state_next = state_reg - 1;
end
always @(posedge clk) state_reg <= state_next;

reg fire_reg = 1'b0;
wire fire_next = ~arm & en & ~(|state_reg);
always @(posedge clk) fire_reg <= fire_next;
assign fire = fire_reg;

endmodule