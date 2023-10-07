`timescale 1ns/1ps // time unit / resolution

`include "cpu.sv"

module cpu_tb;
logic clk, reset;
logic [7:0] ALUResult,cpu_out;

cpu dut(clk,reset,ALUResult,cpu_out);

always begin
    #1; // Generate clock signal with 20 ns period
    clk = ~clk;
end 

initial begin
    $dumpfile("cpu_tb.vcd");   // Dump variable changes in the Variable Dump Changes (vcd) file, which is used to plot the results
    $dumpvars(0,cpu_tb); 

    clk = 0; reset = 0; #1;

    reset = 1; #1; // clk 1 

    reset = 0; #1; // clk 0

    #70;

    $finish;
end 

initial begin
    $monitor("t=%3d,t_clk=%d,t_reset=%d,t_ALUResult=%d,t_cpu_out=%d \n",
    $time,clk,reset,ALUResult,cpu_out); 
end 

endmodule

// Once the testbench code runs for 70 nanoseconds, the output will be 5, incrementing up by one on each positive clock edge.

//Compile: iverilog -g 2012 -o cpu_tb.vvp cpu_tb.sv
//Run : vvp cpu_tb.vvp
//Open : gtkwave
