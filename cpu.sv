module cpu(input logic clk, reset,
            output logic [7:0] ALUResult,cpu_out);

// Creating variables that aren't inputs or outputs, but intermediary variables between different logic units
logic [23:0] data_ROM [0:255]; // 256 words that are 24 bits long
logic [23:0] instr;
logic [7:0] RD1,RD2,SrcA,SrcB,immediate,PC;
logic [4:0] out;
logic [3:0] RA1,RA2,WA,opcode;
logic [1:0] ALUControl;
logic Zero,write_enable,ALUSrc,PCSrc,Branch; // write_enable = RegWrite


// Register file -------------------
reg[7:0] regfile[0:15]; // An array of 16 registers each of 8 bits
initial regfile[0] = 0; // Making sure that the register file 0 always holds value of 0 

assign RD1 = regfile[RA1]; 
assign RD2 = regfile[RA2];

assign cpu_out = regfile[15]; // assigning the value of cpu_out from register address 15

assign SrcA = RD1;

always_ff @ (posedge clk) begin
    if (write_enable) begin 
        regfile[WA] <= ALUResult;
        
        if (WA == 0) begin 
            regfile[0] <= 0; // To make sure if register x0 is written to, it's overridden and 0 is kept there
        end
    end 
end 

// 2:1 Mux -----------------------------
assign SrcB = (ALUSrc) ? immediate : RD2;

// ALU --------------------------
always_comb // means always combinational (a cyclic structure)
// so need to use combinational logic not sequential logic
case(ALUControl) 
2'b00 : ALUResult = SrcA & SrcB; // bitwise a AND b 
2'b01 : ALUResult = SrcA | SrcB; // bitwise a OR b 
2'b10 : ALUResult = SrcA + SrcB; // addition a + b 
2'b11 : ALUResult = SrcA - SrcB; // subtraction a - b 
default : ALUResult = 8'bx; // The 'x' is like a placeholder for the 8 bits
endcase
assign Zero = (ALUResult == 0);

//Program counter-------------------------------------
always_ff @ (posedge clk) begin 
    if(reset) PC <= 0;

    else if (PCSrc) PC <= immediate;

    else PC <= PC + 1;
end

//ROM-------------------------------------------------
initial   
$readmemb("machineCode.txt",data_ROM); // Reading hexadecimal 'h'
// This is a machine code program which finds the binary logarithm of the value stored in register x2
// and stores the result in register x15.
assign instr = data_ROM[PC];

// Need to bit split the instr word to input to the 
assign immediate = instr[7:0];
assign RA1 = instr[15:12];
assign RA2 = instr[11:8];
assign WA = instr[19:16];
assign opcode = instr[23:20];

//Control Unit---------------------------------------------------------
always_comb
case(opcode)
4'b0000 : out = 5'b10000; 
4'b0001 : out = 5'b10010;
4'b0010 : out = 5'b10100;
4'b0011 : out = 5'b10110;
4'b0100 : out = 5'b11000;
4'b0101 : out = 5'b11010;
4'b0110 : out = 5'b11100;
4'b0111 : out = 5'b00111;
    default : out = 5'bx;
endcase
// Bit splicing into the correct outputs 
// Because the case statement will not allow multiple assignments in one line
assign write_enable = out[4];
assign ALUSrc = out[3];
assign ALUControl = out[2:1];
assign Branch = out[0];

// Writing the combinational logic for the AND gate combining these modules 
assign PCSrc = Branch & Zero;

endmodule 
