`timescale 1ns / 1ps

module testbench
#(parameter WIDHT = 180,
HEIGTH = 350,
TRESHOLD = 90,
//put your input files below
INFILE1 = "./real_1.hex",
INFILE2 = "./real_2.hex",
INFILE3 = "./real_3.hex",
INFILE4 = "./real_4.hex",
INFILE5 = "./real_5.hex",
INFILE6 = "./real_6.hex",
INFILE7 = "./real_7.hex",
INFILE8 = "./real_8.hex",
INFILE9 = "./real_9.hex",
INFILE10 = "./real_10.hex",
INFILE11 = "./real_11.hex",
INFILE12 = "./real_12.hex"
)
();
reg clk;
reg start;
reg [7:0] total [0:189000];//width*heigth*3
reg [7:0] datain;
reg [19:0] i;

initial begin
	clk = 1'b0;
	forever begin
		#5
		clk = ~clk;
	end
end

initial begin
	start = 1'b0;
	i = 0;
	#1;
   $readmemh(INFILE1,total,0,188999); // read file from INFILE to total
	start = 1'b1;
	while (i < 190000) begin
		datain = total[i];
		i = i+1;
		#10;
	end
	start = 1'b0;
	#100000;
	$readmemh(INFILE2,total,0,188999); // read file from INFILE to total
	i = 0;
	start = 1'b1;
	while (i < 190000) begin
		datain = total[i];
		i = i+1;
		#10;
	end
	start = 1'b0;
	#100000;
	$readmemh(INFILE3,total,0,188999); // read file from INFILE to total
	i = 0;
	start = 1'b1;
	while (i < 190000) begin
		datain = total[i];
		i = i+1;
		#10;
	end
	start = 1'b0;
	#100000;
	$readmemh(INFILE4,total,0,188999); // read file from INFILE to total
	i = 0;
	start = 1'b1;
	while (i < 190000) begin
		datain = total[i];
		i = i+1;
		#10;
	end
	start = 1'b0;
	#100000;
	$readmemh(INFILE5,total,0,188999); // read file from INFILE to total
	i = 0;
	start = 1'b1;
	while (i < 190000) begin
		datain = total[i];
		i = i+1;
		#10;
	end
	start = 1'b0;
	#100000;
	$readmemh(INFILE6,total,0,188999); // read file from INFILE to total
	i = 0;
	start = 1'b1;
	while (i < 190000) begin
		datain = total[i];
		i = i+1;
		#10;
	end
	start = 1'b0;
	#100000;
	$readmemh(INFILE7,total,0,188999); // read file from INFILE to total
	i = 0;
	start = 1'b1;
	while (i < 190000) begin
		datain = total[i];
		i = i+1;
		#10;
	end
	start = 1'b0;
	#100000;
	$readmemh(INFILE8,total,0,188999); // read file from INFILE to total
	i = 0;
	start = 1'b1;
	while (i < 190000) begin
		datain = total[i];
		i = i+1;
		#10;
	end
	start = 1'b0;
	#100000;
	$readmemh(INFILE9,total,0,188999); // read file from INFILE to total
	i = 0;
	start = 1'b1;
	while (i < 190000) begin
		datain = total[i];
		i = i+1;
		#10;
	end
	start = 1'b0;
	#100000;
	$readmemh(INFILE10,total,0,188999); // read file from INFILE to total
	i = 0;
	start = 1'b1;
	while (i < 190000) begin
		datain = total[i];
		i = i+1;
		#10;
	end
	start = 1'b0;
	#100000;
	$readmemh(INFILE11,total,0,188999); // read file from INFILE to total
	i = 0;
	start = 1'b1;
	while (i < 190000) begin
		datain = total[i];
		i = i+1;
		#10;
	end
	start = 1'b0;
	#100000;
	$readmemh(INFILE12,total,0,188999); // read file from INFILE to total
	i = 0;
	start = 1'b1;
	while (i < 190000) begin
		datain = total[i];
		i = i+1;
		#10;
	end
	start = 1'b0;
	#100000;
end
main main(
	.clk(clk),
	.start(start),
	.datain(datain)
);

endmodule
