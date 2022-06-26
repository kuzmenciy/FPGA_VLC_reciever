`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Northumbria Univercity
// Engineer: Alexandr Kuzmenko
// 
// Create Date:    11:46:23 07/19/2019 
// Design Name: 
// Module Name:    main 
// Project Name: Digital image processing algorithm
// Target Devices: spartan-3e
//////////////////////////////////////////////////////////////////////////////////
module main
#(parameter WIDHT = 180, //sizes of input picture in pixels
HEIGTH = 350,
CELLS = 1296, 

RAD = 2, //haar radius

TRESHOLD = 52) //theshold for Haar B element to detect points of interest
(
input clk, //signal from clock generator
input [7:0] datain, //data from microcontroller: 8 bits per channel, 3 channels per pixel, no spaces, no parity
input start //signal to synchronise microcontroller and FPGA 
   );
	
	//that was a testing program that flashed led at FPGA board at 1HZ - just to check whether it is alive
	/*
	reg[9:0] counter1 = 10'b0;
	reg drive2 = 1'b0;
	always @(posedge clk) begin
		if(counter1 == 999)begin
			drive2 <= 1;
			counter1 <= 0;
		end
		else begin
			counter1 <= counter1 + 1;
			drive2 <= 0;
		end
	end//always
	
	reg[9:0] counter2 = 10'b0;
	reg drive3 = 1'b0;
	always @(posedge clk) begin
		if(drive2 == 1) begin
			if(counter2 == 999) begin
				drive3 <= 1;
				counter2 <= 0;
			end
			else begin
				counter2 <= counter2 + 1;
				drive3 <= 0;
			end
		end//if
	end//always
	
	reg [5:0] counter3 = 6'b0;
	always @(posedge clk) begin
		if(drive3 == 1) begin
			if(counter3 == 49) begin
				counter3 <= 0;
				led <= !led;
			end
			else counter3 <= counter3 + 1;
		end//if
	end//always
	*/
	
	parameter WAIT = 1'b0;
	parameter ALGORITHM = 1'b1;
	reg state = WAIT;
	
	
	//1-clk-long signal finish
	reg finish1 = 1'b0;
	reg finish2 = 1'b0;
	always @(posedge clk) finish2 <= ~finish1;
	wire finish;
	assign finish = finish1 & finish2;
	
	always @(posedge clk) begin
		case (state)
			WAIT:
				if (start) state <= ALGORITHM;
				else state <= state;
				
			ALGORITHM:
				if (finish) state <= WAIT;
				else state <= state;
				
		endcase
	end//always
	
	//-------INPUT DATA COMPRESSION-------//
	
	//registers to store channels of current pixel incoming:
	reg [7:0] current_R;
	reg [7:0] current_G;
	reg [7:0] current_B;
	
	//register to store median value of channels:
	reg [7:0] saturation = 8'b0;
	
	//counter to remember which channel is at input now:
	reg [1:0] c = 2'b0;
	
	
	//datain is coming as RGBRGBRGBRGB..., therefore, each clk cycle register to store input data should be changed
	//That process is controlled by	[1:0]c counter
	always @(posedge clk) begin
		if(state == ALGORITHM) begin
			if (c==0) begin
				saturation <= (current_R + current_G + current_B)/4;
				current_R <= datain;
				c <= 1;
			end
			else if (c==1) begin
				current_G <= datain;
				c <= 2;
			end
			else if (c==2) begin
				current_B = datain;
				c <= 0;
			end
		end//if
		else c <= 0;
	end//always
	
	//-------DATA SAVING-------//
	
	//two-dimentional arrays for rows of pixels
	reg [7:0] row_1 [0:WIDHT-1]; //due to the very limited capacity of the chip,
	reg [7:0] row_2 [0:WIDHT-1]; //only several rows of incoming picture is being stored.
	reg [7:0] row_3 [0:WIDHT-1]; //While row 1 is being filled with data, previous rows 2-6
	reg [7:0] row_4 [0:WIDHT-1]; //are used in analysing algorithm
	reg [7:0] row_5 [0:WIDHT-1];
	reg [7:0] row_6 [0:WIDHT-1];
	
	reg [9:0] num = 10'b0; //current position in a row (i.e. column) is stored in this register
	reg [9:0] row_cnt = 10'b0;//current number of row
	
	reg h = 1'b0; //signal to start next part of the algorithm (haar wavelet)
	
	always @(posedge clk) begin
		if (c==2) begin //once per 3 clk cycles, i.e. once per pixel
			row_1 [num] <= saturation; //value of current pixel is stored
			if (num == WIDHT-1) begin //when the end of the row is reached, 
											//all stored data shifts (row4 is eliminated, row3 is rewrited to row4, 
											//row2 to row3 and so on), and fresh and empty row1 is ready to store new incoming data
				num <= 0;
				row_cnt <= row_cnt + 1;
				
				//two dimentional arrays can't be directly assigned to each other, so here is a loooong assingment description
				row_6 [0] <= row_5 [0];
				row_6 [1] <= row_5 [1];
				row_6 [2] <= row_5 [2];
				row_6 [3] <= row_5 [3];
				row_6 [4] <= row_5 [4];
				row_6 [5] <= row_5 [5];
				row_6 [6] <= row_5 [6];
				row_6 [7] <= row_5 [7];
				row_6 [8] <= row_5 [8];
				row_6 [9] <= row_5 [9];
				row_6 [10] <= row_5 [10];
				row_6 [11] <= row_5 [11];
				row_6 [12] <= row_5 [12];
				row_6 [13] <= row_5 [13];
				row_6 [14] <= row_5 [14];
				row_6 [15] <= row_5 [15];
				row_6 [16] <= row_5 [16];
				row_6 [17] <= row_5 [17];
				row_6 [18] <= row_5 [18];
				row_6 [19] <= row_5 [19];
				row_6 [20] <= row_5 [20];
				row_6 [21] <= row_5 [21];
				row_6 [22] <= row_5 [22];
				row_6 [23] <= row_5 [23];
				row_6 [24] <= row_5 [24];
				row_6 [25] <= row_5 [25];
				row_6 [26] <= row_5 [26];
				row_6 [27] <= row_5 [27];
				row_6 [28] <= row_5 [28];
				row_6 [29] <= row_5 [29];
				row_6 [30] <= row_5 [30];
				row_6 [31] <= row_5 [31];
				row_6 [32] <= row_5 [32];
				row_6 [33] <= row_5 [33];
				row_6 [34] <= row_5 [34];
				row_6 [35] <= row_5 [35];
				row_6 [36] <= row_5 [36];
				row_6 [37] <= row_5 [37];
				row_6 [38] <= row_5 [38];
				row_6 [39] <= row_5 [39];
				row_6 [40] <= row_5 [40];
				row_6 [41] <= row_5 [41];
				row_6 [42] <= row_5 [42];
				row_6 [43] <= row_5 [43];
				row_6 [44] <= row_5 [44];
				row_6 [45] <= row_5 [45];
				row_6 [46] <= row_5 [46];
				row_6 [47] <= row_5 [47];
				row_6 [48] <= row_5 [48];
				row_6 [49] <= row_5 [49];
				row_6 [50] <= row_5 [50];
				row_6 [51] <= row_5 [51];
				row_6 [52] <= row_5 [52];
				row_6 [53] <= row_5 [53];
				row_6 [54] <= row_5 [54];
				row_6 [55] <= row_5 [55];
				row_6 [56] <= row_5 [56];
				row_6 [57] <= row_5 [57];
				row_6 [58] <= row_5 [58];
				row_6 [59] <= row_5 [59];
				row_6 [60] <= row_5 [60];
				row_6 [61] <= row_5 [61];
				row_6 [62] <= row_5 [62];
				row_6 [63] <= row_5 [63];
				row_6 [64] <= row_5 [64];
				row_6 [65] <= row_5 [65];
				row_6 [66] <= row_5 [66];
				row_6 [67] <= row_5 [67];
				row_6 [68] <= row_5 [68];
				row_6 [69] <= row_5 [69];
				row_6 [70] <= row_5 [70];
				row_6 [71] <= row_5 [71];
				row_6 [72] <= row_5 [72];
				row_6 [73] <= row_5 [73];
				row_6 [74] <= row_5 [74];
				row_6 [75] <= row_5 [75];
				row_6 [76] <= row_5 [76];
				row_6 [77] <= row_5 [77];
				row_6 [78] <= row_5 [78];
				row_6 [79] <= row_5 [79];
				row_6 [80] <= row_5 [80];
				row_6 [81] <= row_5 [81];
				row_6 [82] <= row_5 [82];
				row_6 [83] <= row_5 [83];
				row_6 [84] <= row_5 [84];
				row_6 [85] <= row_5 [85];
				row_6 [86] <= row_5 [86];
				row_6 [87] <= row_5 [87];
				row_6 [88] <= row_5 [88];
				row_6 [89] <= row_5 [89];
				row_6 [90] <= row_5 [90];
				row_6 [91] <= row_5 [91];
				row_6 [92] <= row_5 [92];
				row_6 [93] <= row_5 [93];
				row_6 [94] <= row_5 [94];
				row_6 [95] <= row_5 [95];
				row_6 [96] <= row_5 [96];
				row_6 [97] <= row_5 [97];
				row_6 [98] <= row_5 [98];
				row_6 [99] <= row_5 [99];
				row_6 [100] <= row_5 [100];
				row_6 [101] <= row_5 [101];
				row_6 [102] <= row_5 [102];
				row_6 [103] <= row_5 [103];
				row_6 [104] <= row_5 [104];
				row_6 [105] <= row_5 [105];
				row_6 [106] <= row_5 [106];
				row_6 [107] <= row_5 [107];
				row_6 [108] <= row_5 [108];
				row_6 [109] <= row_5 [109];
				row_6 [110] <= row_5 [110];
				row_6 [111] <= row_5 [111];
				row_6 [112] <= row_5 [112];
				row_6 [113] <= row_5 [113];
				row_6 [114] <= row_5 [114];
				row_6 [115] <= row_5 [115];
				row_6 [116] <= row_5 [116];
				row_6 [117] <= row_5 [117];
				row_6 [118] <= row_5 [118];
				row_6 [119] <= row_5 [119];
				row_6 [120] <= row_5 [120];
				row_6 [121] <= row_5 [121];
				row_6 [122] <= row_5 [122];
				row_6 [123] <= row_5 [123];
				row_6 [124] <= row_5 [124];
				row_6 [125] <= row_5 [125];
				row_6 [126] <= row_5 [126];
				row_6 [127] <= row_5 [127];
				row_6 [128] <= row_5 [128];
				row_6 [129] <= row_5 [129];
				row_6 [130] <= row_5 [130];
				row_6 [131] <= row_5 [131];
				row_6 [132] <= row_5 [132];
				row_6 [133] <= row_5 [133];
				row_6 [134] <= row_5 [134];
				row_6 [135] <= row_5 [135];
				row_6 [136] <= row_5 [136];
				row_6 [137] <= row_5 [137];
				row_6 [138] <= row_5 [138];
				row_6 [139] <= row_5 [139];
				row_6 [140] <= row_5 [140];
				row_6 [141] <= row_5 [141];
				row_6 [142] <= row_5 [142];
				row_6 [143] <= row_5 [143];
				row_6 [144] <= row_5 [144];
				row_6 [145] <= row_5 [145];
				row_6 [146] <= row_5 [146];
				row_6 [147] <= row_5 [147];
				row_6 [148] <= row_5 [148];
				row_6 [149] <= row_5 [149];
				row_6 [150] <= row_5 [150];
				row_6 [151] <= row_5 [151];
				row_6 [152] <= row_5 [152];
				row_6 [153] <= row_5 [153];
				row_6 [154] <= row_5 [154];
				row_6 [155] <= row_5 [155];
				row_6 [156] <= row_5 [156];
				row_6 [157] <= row_5 [157];
				row_6 [158] <= row_5 [158];
				row_6 [159] <= row_5 [159];
				row_6 [160] <= row_5 [160];
				row_6 [161] <= row_5 [161];
				row_6 [162] <= row_5 [162];
				row_6 [163] <= row_5 [163];
				row_6 [164] <= row_5 [164];
				row_6 [165] <= row_5 [165];
				row_6 [166] <= row_5 [166];
				row_6 [167] <= row_5 [167];
				row_6 [168] <= row_5 [168];
				row_6 [169] <= row_5 [169];
				row_6 [170] <= row_5 [170];
				row_6 [171] <= row_5 [171];
				row_6 [172] <= row_5 [172];
				row_6 [173] <= row_5 [173];
				row_6 [174] <= row_5 [174];
				row_6 [175] <= row_5 [175];
				row_6 [176] <= row_5 [176];
				row_6 [177] <= row_5 [177];
				row_6 [178] <= row_5 [178];
				row_6 [179] <= row_5 [179];
				
				row_5 [0] <= row_4 [0];
				row_5 [1] <= row_4 [1];
				row_5 [2] <= row_4 [2];
				row_5 [3] <= row_4 [3];
				row_5 [4] <= row_4 [4];
				row_5 [5] <= row_4 [5];
				row_5 [6] <= row_4 [6];
				row_5 [7] <= row_4 [7];
				row_5 [8] <= row_4 [8];
				row_5 [9] <= row_4 [9];
				row_5 [10] <= row_4 [10];
				row_5 [11] <= row_4 [11];
				row_5 [12] <= row_4 [12];
				row_5 [13] <= row_4 [13];
				row_5 [14] <= row_4 [14];
				row_5 [15] <= row_4 [15];
				row_5 [16] <= row_4 [16];
				row_5 [17] <= row_4 [17];
				row_5 [18] <= row_4 [18];
				row_5 [19] <= row_4 [19];
				row_5 [20] <= row_4 [20];
				row_5 [21] <= row_4 [21];
				row_5 [22] <= row_4 [22];
				row_5 [23] <= row_4 [23];
				row_5 [24] <= row_4 [24];
				row_5 [25] <= row_4 [25];
				row_5 [26] <= row_4 [26];
				row_5 [27] <= row_4 [27];
				row_5 [28] <= row_4 [28];
				row_5 [29] <= row_4 [29];
				row_5 [30] <= row_4 [30];
				row_5 [31] <= row_4 [31];
				row_5 [32] <= row_4 [32];
				row_5 [33] <= row_4 [33];
				row_5 [34] <= row_4 [34];
				row_5 [35] <= row_4 [35];
				row_5 [36] <= row_4 [36];
				row_5 [37] <= row_4 [37];
				row_5 [38] <= row_4 [38];
				row_5 [39] <= row_4 [39];
				row_5 [40] <= row_4 [40];
				row_5 [41] <= row_4 [41];
				row_5 [42] <= row_4 [42];
				row_5 [43] <= row_4 [43];
				row_5 [44] <= row_4 [44];
				row_5 [45] <= row_4 [45];
				row_5 [46] <= row_4 [46];
				row_5 [47] <= row_4 [47];
				row_5 [48] <= row_4 [48];
				row_5 [49] <= row_4 [49];
				row_5 [50] <= row_4 [50];
				row_5 [51] <= row_4 [51];
				row_5 [52] <= row_4 [52];
				row_5 [53] <= row_4 [53];
				row_5 [54] <= row_4 [54];
				row_5 [55] <= row_4 [55];
				row_5 [56] <= row_4 [56];
				row_5 [57] <= row_4 [57];
				row_5 [58] <= row_4 [58];
				row_5 [59] <= row_4 [59];
				row_5 [60] <= row_4 [60];
				row_5 [61] <= row_4 [61];
				row_5 [62] <= row_4 [62];
				row_5 [63] <= row_4 [63];
				row_5 [64] <= row_4 [64];
				row_5 [65] <= row_4 [65];
				row_5 [66] <= row_4 [66];
				row_5 [67] <= row_4 [67];
				row_5 [68] <= row_4 [68];
				row_5 [69] <= row_4 [69];
				row_5 [70] <= row_4 [70];
				row_5 [71] <= row_4 [71];
				row_5 [72] <= row_4 [72];
				row_5 [73] <= row_4 [73];
				row_5 [74] <= row_4 [74];
				row_5 [75] <= row_4 [75];
				row_5 [76] <= row_4 [76];
				row_5 [77] <= row_4 [77];
				row_5 [78] <= row_4 [78];
				row_5 [79] <= row_4 [79];
				row_5 [80] <= row_4 [80];
				row_5 [81] <= row_4 [81];
				row_5 [82] <= row_4 [82];
				row_5 [83] <= row_4 [83];
				row_5 [84] <= row_4 [84];
				row_5 [85] <= row_4 [85];
				row_5 [86] <= row_4 [86];
				row_5 [87] <= row_4 [87];
				row_5 [88] <= row_4 [88];
				row_5 [89] <= row_4 [89];
				row_5 [90] <= row_4 [90];
				row_5 [91] <= row_4 [91];
				row_5 [92] <= row_4 [92];
				row_5 [93] <= row_4 [93];
				row_5 [94] <= row_4 [94];
				row_5 [95] <= row_4 [95];
				row_5 [96] <= row_4 [96];
				row_5 [97] <= row_4 [97];
				row_5 [98] <= row_4 [98];
				row_5 [99] <= row_4 [99];
				row_5 [100] <= row_4 [100];
				row_5 [101] <= row_4 [101];
				row_5 [102] <= row_4 [102];
				row_5 [103] <= row_4 [103];
				row_5 [104] <= row_4 [104];
				row_5 [105] <= row_4 [105];
				row_5 [106] <= row_4 [106];
				row_5 [107] <= row_4 [107];
				row_5 [108] <= row_4 [108];
				row_5 [109] <= row_4 [109];
				row_5 [110] <= row_4 [110];
				row_5 [111] <= row_4 [111];
				row_5 [112] <= row_4 [112];
				row_5 [113] <= row_4 [113];
				row_5 [114] <= row_4 [114];
				row_5 [115] <= row_4 [115];
				row_5 [116] <= row_4 [116];
				row_5 [117] <= row_4 [117];
				row_5 [118] <= row_4 [118];
				row_5 [119] <= row_4 [119];
				row_5 [120] <= row_4 [120];
				row_5 [121] <= row_4 [121];
				row_5 [122] <= row_4 [122];
				row_5 [123] <= row_4 [123];
				row_5 [124] <= row_4 [124];
				row_5 [125] <= row_4 [125];
				row_5 [126] <= row_4 [126];
				row_5 [127] <= row_4 [127];
				row_5 [128] <= row_4 [128];
				row_5 [129] <= row_4 [129];
				row_5 [130] <= row_4 [130];
				row_5 [131] <= row_4 [131];
				row_5 [132] <= row_4 [132];
				row_5 [133] <= row_4 [133];
				row_5 [134] <= row_4 [134];
				row_5 [135] <= row_4 [135];
				row_5 [136] <= row_4 [136];
				row_5 [137] <= row_4 [137];
				row_5 [138] <= row_4 [138];
				row_5 [139] <= row_4 [139];
				row_5 [140] <= row_4 [140];
				row_5 [141] <= row_4 [141];
				row_5 [142] <= row_4 [142];
				row_5 [143] <= row_4 [143];
				row_5 [144] <= row_4 [144];
				row_5 [145] <= row_4 [145];
				row_5 [146] <= row_4 [146];
				row_5 [147] <= row_4 [147];
				row_5 [148] <= row_4 [148];
				row_5 [149] <= row_4 [149];
				row_5 [150] <= row_4 [150];
				row_5 [151] <= row_4 [151];
				row_5 [152] <= row_4 [152];
				row_5 [153] <= row_4 [153];
				row_5 [154] <= row_4 [154];
				row_5 [155] <= row_4 [155];
				row_5 [156] <= row_4 [156];
				row_5 [157] <= row_4 [157];
				row_5 [158] <= row_4 [158];
				row_5 [159] <= row_4 [159];
				row_5 [160] <= row_4 [160];
				row_5 [161] <= row_4 [161];
				row_5 [162] <= row_4 [162];
				row_5 [163] <= row_4 [163];
				row_5 [164] <= row_4 [164];
				row_5 [165] <= row_4 [165];
				row_5 [166] <= row_4 [166];
				row_5 [167] <= row_4 [167];
				row_5 [168] <= row_4 [168];
				row_5 [169] <= row_4 [169];
				row_5 [170] <= row_4 [170];
				row_5 [171] <= row_4 [171];
				row_5 [172] <= row_4 [172];
				row_5 [173] <= row_4 [173];
				row_5 [174] <= row_4 [174];
				row_5 [175] <= row_4 [175];
				row_5 [176] <= row_4 [176];
				row_5 [177] <= row_4 [177];
				row_5 [178] <= row_4 [178];
				row_5 [179] <= row_4 [179];
				
				row_4 [0] <= row_3 [0];
				row_4 [1] <= row_3 [1];
				row_4 [2] <= row_3 [2];
				row_4 [3] <= row_3 [3];
				row_4 [4] <= row_3 [4];
				row_4 [5] <= row_3 [5];
				row_4 [6] <= row_3 [6];
				row_4 [7] <= row_3 [7];
				row_4 [8] <= row_3 [8];
				row_4 [9] <= row_3 [9];
				row_4 [10] <= row_3 [10];
				row_4 [11] <= row_3 [11];
				row_4 [12] <= row_3 [12];
				row_4 [13] <= row_3 [13];
				row_4 [14] <= row_3 [14];
				row_4 [15] <= row_3 [15];
				row_4 [16] <= row_3 [16];
				row_4 [17] <= row_3 [17];
				row_4 [18] <= row_3 [18];
				row_4 [19] <= row_3 [19];
				row_4 [20] <= row_3 [20];
				row_4 [21] <= row_3 [21];
				row_4 [22] <= row_3 [22];
				row_4 [23] <= row_3 [23];
				row_4 [24] <= row_3 [24];
				row_4 [25] <= row_3 [25];
				row_4 [26] <= row_3 [26];
				row_4 [27] <= row_3 [27];
				row_4 [28] <= row_3 [28];
				row_4 [29] <= row_3 [29];
				row_4 [30] <= row_3 [30];
				row_4 [31] <= row_3 [31];
				row_4 [32] <= row_3 [32];
				row_4 [33] <= row_3 [33];
				row_4 [34] <= row_3 [34];
				row_4 [35] <= row_3 [35];
				row_4 [36] <= row_3 [36];
				row_4 [37] <= row_3 [37];
				row_4 [38] <= row_3 [38];
				row_4 [39] <= row_3 [39];
				row_4 [40] <= row_3 [40];
				row_4 [41] <= row_3 [41];
				row_4 [42] <= row_3 [42];
				row_4 [43] <= row_3 [43];
				row_4 [44] <= row_3 [44];
				row_4 [45] <= row_3 [45];
				row_4 [46] <= row_3 [46];
				row_4 [47] <= row_3 [47];
				row_4 [48] <= row_3 [48];
				row_4 [49] <= row_3 [49];
				row_4 [50] <= row_3 [50];
				row_4 [51] <= row_3 [51];
				row_4 [52] <= row_3 [52];
				row_4 [53] <= row_3 [53];
				row_4 [54] <= row_3 [54];
				row_4 [55] <= row_3 [55];
				row_4 [56] <= row_3 [56];
				row_4 [57] <= row_3 [57];
				row_4 [58] <= row_3 [58];
				row_4 [59] <= row_3 [59];
				row_4 [60] <= row_3 [60];
				row_4 [61] <= row_3 [61];
				row_4 [62] <= row_3 [62];
				row_4 [63] <= row_3 [63];
				row_4 [64] <= row_3 [64];
				row_4 [65] <= row_3 [65];
				row_4 [66] <= row_3 [66];
				row_4 [67] <= row_3 [67];
				row_4 [68] <= row_3 [68];
				row_4 [69] <= row_3 [69];
				row_4 [70] <= row_3 [70];
				row_4 [71] <= row_3 [71];
				row_4 [72] <= row_3 [72];
				row_4 [73] <= row_3 [73];
				row_4 [74] <= row_3 [74];
				row_4 [75] <= row_3 [75];
				row_4 [76] <= row_3 [76];
				row_4 [77] <= row_3 [77];
				row_4 [78] <= row_3 [78];
				row_4 [79] <= row_3 [79];
				row_4 [80] <= row_3 [80];
				row_4 [81] <= row_3 [81];
				row_4 [82] <= row_3 [82];
				row_4 [83] <= row_3 [83];
				row_4 [84] <= row_3 [84];
				row_4 [85] <= row_3 [85];
				row_4 [86] <= row_3 [86];
				row_4 [87] <= row_3 [87];
				row_4 [88] <= row_3 [88];
				row_4 [89] <= row_3 [89];
				row_4 [90] <= row_3 [90];
				row_4 [91] <= row_3 [91];
				row_4 [92] <= row_3 [92];
				row_4 [93] <= row_3 [93];
				row_4 [94] <= row_3 [94];
				row_4 [95] <= row_3 [95];
				row_4 [96] <= row_3 [96];
				row_4 [97] <= row_3 [97];
				row_4 [98] <= row_3 [98];
				row_4 [99] <= row_3 [99];
				row_4 [100] <= row_3 [100];
				row_4 [101] <= row_3 [101];
				row_4 [102] <= row_3 [102];
				row_4 [103] <= row_3 [103];
				row_4 [104] <= row_3 [104];
				row_4 [105] <= row_3 [105];
				row_4 [106] <= row_3 [106];
				row_4 [107] <= row_3 [107];
				row_4 [108] <= row_3 [108];
				row_4 [109] <= row_3 [109];
				row_4 [110] <= row_3 [110];
				row_4 [111] <= row_3 [111];
				row_4 [112] <= row_3 [112];
				row_4 [113] <= row_3 [113];
				row_4 [114] <= row_3 [114];
				row_4 [115] <= row_3 [115];
				row_4 [116] <= row_3 [116];
				row_4 [117] <= row_3 [117];
				row_4 [118] <= row_3 [118];
				row_4 [119] <= row_3 [119];
				row_4 [120] <= row_3 [120];
				row_4 [121] <= row_3 [121];
				row_4 [122] <= row_3 [122];
				row_4 [123] <= row_3 [123];
				row_4 [124] <= row_3 [124];
				row_4 [125] <= row_3 [125];
				row_4 [126] <= row_3 [126];
				row_4 [127] <= row_3 [127];
				row_4 [128] <= row_3 [128];
				row_4 [129] <= row_3 [129];
				row_4 [130] <= row_3 [130];
				row_4 [131] <= row_3 [131];
				row_4 [132] <= row_3 [132];
				row_4 [133] <= row_3 [133];
				row_4 [134] <= row_3 [134];
				row_4 [135] <= row_3 [135];
				row_4 [136] <= row_3 [136];
				row_4 [137] <= row_3 [137];
				row_4 [138] <= row_3 [138];
				row_4 [139] <= row_3 [139];
				row_4 [140] <= row_3 [140];
				row_4 [141] <= row_3 [141];
				row_4 [142] <= row_3 [142];
				row_4 [143] <= row_3 [143];
				row_4 [144] <= row_3 [144];
				row_4 [145] <= row_3 [145];
				row_4 [146] <= row_3 [146];
				row_4 [147] <= row_3 [147];
				row_4 [148] <= row_3 [148];
				row_4 [149] <= row_3 [149];
				row_4 [150] <= row_3 [150];
				row_4 [151] <= row_3 [151];
				row_4 [152] <= row_3 [152];
				row_4 [153] <= row_3 [153];
				row_4 [154] <= row_3 [154];
				row_4 [155] <= row_3 [155];
				row_4 [156] <= row_3 [156];
				row_4 [157] <= row_3 [157];
				row_4 [158] <= row_3 [158];
				row_4 [159] <= row_3 [159];
				row_4 [160] <= row_3 [160];
				row_4 [161] <= row_3 [161];
				row_4 [162] <= row_3 [162];
				row_4 [163] <= row_3 [163];
				row_4 [164] <= row_3 [164];
				row_4 [165] <= row_3 [165];
				row_4 [166] <= row_3 [166];
				row_4 [167] <= row_3 [167];
				row_4 [168] <= row_3 [168];
				row_4 [169] <= row_3 [169];
				row_4 [170] <= row_3 [170];
				row_4 [171] <= row_3 [171];
				row_4 [172] <= row_3 [172];
				row_4 [173] <= row_3 [173];
				row_4 [174] <= row_3 [174];
				row_4 [175] <= row_3 [175];
				row_4 [176] <= row_3 [176];
				row_4 [177] <= row_3 [177];
				row_4 [178] <= row_3 [178];
				row_4 [179] <= row_3 [179];
				
				row_3 [0] <= row_2 [0];
				row_3 [1] <= row_2 [1];
				row_3 [2] <= row_2 [2];
				row_3 [3] <= row_2 [3];
				row_3 [4] <= row_2 [4];
				row_3 [5] <= row_2 [5];
				row_3 [6] <= row_2 [6];
				row_3 [7] <= row_2 [7];
				row_3 [8] <= row_2 [8];
				row_3 [9] <= row_2 [9];
				row_3 [10] <= row_2 [10];
				row_3 [11] <= row_2 [11];
				row_3 [12] <= row_2 [12];
				row_3 [13] <= row_2 [13];
				row_3 [14] <= row_2 [14];
				row_3 [15] <= row_2 [15];
				row_3 [16] <= row_2 [16];
				row_3 [17] <= row_2 [17];
				row_3 [18] <= row_2 [18];
				row_3 [19] <= row_2 [19];
				row_3 [20] <= row_2 [20];
				row_3 [21] <= row_2 [21];
				row_3 [22] <= row_2 [22];
				row_3 [23] <= row_2 [23];
				row_3 [24] <= row_2 [24];
				row_3 [25] <= row_2 [25];
				row_3 [26] <= row_2 [26];
				row_3 [27] <= row_2 [27];
				row_3 [28] <= row_2 [28];
				row_3 [29] <= row_2 [29];
				row_3 [30] <= row_2 [30];
				row_3 [31] <= row_2 [31];
				row_3 [32] <= row_2 [32];
				row_3 [33] <= row_2 [33];
				row_3 [34] <= row_2 [34];
				row_3 [35] <= row_2 [35];
				row_3 [36] <= row_2 [36];
				row_3 [37] <= row_2 [37];
				row_3 [38] <= row_2 [38];
				row_3 [39] <= row_2 [39];
				row_3 [40] <= row_2 [40];
				row_3 [41] <= row_2 [41];
				row_3 [42] <= row_2 [42];
				row_3 [43] <= row_2 [43];
				row_3 [44] <= row_2 [44];
				row_3 [45] <= row_2 [45];
				row_3 [46] <= row_2 [46];
				row_3 [47] <= row_2 [47];
				row_3 [48] <= row_2 [48];
				row_3 [49] <= row_2 [49];
				row_3 [50] <= row_2 [50];
				row_3 [51] <= row_2 [51];
				row_3 [52] <= row_2 [52];
				row_3 [53] <= row_2 [53];
				row_3 [54] <= row_2 [54];
				row_3 [55] <= row_2 [55];
				row_3 [56] <= row_2 [56];
				row_3 [57] <= row_2 [57];
				row_3 [58] <= row_2 [58];
				row_3 [59] <= row_2 [59];
				row_3 [60] <= row_2 [60];
				row_3 [61] <= row_2 [61];
				row_3 [62] <= row_2 [62];
				row_3 [63] <= row_2 [63];
				row_3 [64] <= row_2 [64];
				row_3 [65] <= row_2 [65];
				row_3 [66] <= row_2 [66];
				row_3 [67] <= row_2 [67];
				row_3 [68] <= row_2 [68];
				row_3 [69] <= row_2 [69];
				row_3 [70] <= row_2 [70];
				row_3 [71] <= row_2 [71];
				row_3 [72] <= row_2 [72];
				row_3 [73] <= row_2 [73];
				row_3 [74] <= row_2 [74];
				row_3 [75] <= row_2 [75];
				row_3 [76] <= row_2 [76];
				row_3 [77] <= row_2 [77];
				row_3 [78] <= row_2 [78];
				row_3 [79] <= row_2 [79];
				row_3 [80] <= row_2 [80];
				row_3 [81] <= row_2 [81];
				row_3 [82] <= row_2 [82];
				row_3 [83] <= row_2 [83];
				row_3 [84] <= row_2 [84];
				row_3 [85] <= row_2 [85];
				row_3 [86] <= row_2 [86];
				row_3 [87] <= row_2 [87];
				row_3 [88] <= row_2 [88];
				row_3 [89] <= row_2 [89];
				row_3 [90] <= row_2 [90];
				row_3 [91] <= row_2 [91];
				row_3 [92] <= row_2 [92];
				row_3 [93] <= row_2 [93];
				row_3 [94] <= row_2 [94];
				row_3 [95] <= row_2 [95];
				row_3 [96] <= row_2 [96];
				row_3 [97] <= row_2 [97];
				row_3 [98] <= row_2 [98];
				row_3 [99] <= row_2 [99];
				row_3 [100] <= row_2 [100];
				row_3 [101] <= row_2 [101];
				row_3 [102] <= row_2 [102];
				row_3 [103] <= row_2 [103];
				row_3 [104] <= row_2 [104];
				row_3 [105] <= row_2 [105];
				row_3 [106] <= row_2 [106];
				row_3 [107] <= row_2 [107];
				row_3 [108] <= row_2 [108];
				row_3 [109] <= row_2 [109];
				row_3 [110] <= row_2 [110];
				row_3 [111] <= row_2 [111];
				row_3 [112] <= row_2 [112];
				row_3 [113] <= row_2 [113];
				row_3 [114] <= row_2 [114];
				row_3 [115] <= row_2 [115];
				row_3 [116] <= row_2 [116];
				row_3 [117] <= row_2 [117];
				row_3 [118] <= row_2 [118];
				row_3 [119] <= row_2 [119];
				row_3 [120] <= row_2 [120];
				row_3 [121] <= row_2 [121];
				row_3 [122] <= row_2 [122];
				row_3 [123] <= row_2 [123];
				row_3 [124] <= row_2 [124];
				row_3 [125] <= row_2 [125];
				row_3 [126] <= row_2 [126];
				row_3 [127] <= row_2 [127];
				row_3 [128] <= row_2 [128];
				row_3 [129] <= row_2 [129];
				row_3 [130] <= row_2 [130];
				row_3 [131] <= row_2 [131];
				row_3 [132] <= row_2 [132];
				row_3 [133] <= row_2 [133];
				row_3 [134] <= row_2 [134];
				row_3 [135] <= row_2 [135];
				row_3 [136] <= row_2 [136];
				row_3 [137] <= row_2 [137];
				row_3 [138] <= row_2 [138];
				row_3 [139] <= row_2 [139];
				row_3 [140] <= row_2 [140];
				row_3 [141] <= row_2 [141];
				row_3 [142] <= row_2 [142];
				row_3 [143] <= row_2 [143];
				row_3 [144] <= row_2 [144];
				row_3 [145] <= row_2 [145];
				row_3 [146] <= row_2 [146];
				row_3 [147] <= row_2 [147];
				row_3 [148] <= row_2 [148];
				row_3 [149] <= row_2 [149];
				row_3 [150] <= row_2 [150];
				row_3 [151] <= row_2 [151];
				row_3 [152] <= row_2 [152];
				row_3 [153] <= row_2 [153];
				row_3 [154] <= row_2 [154];
				row_3 [155] <= row_2 [155];
				row_3 [156] <= row_2 [156];
				row_3 [157] <= row_2 [157];
				row_3 [158] <= row_2 [158];
				row_3 [159] <= row_2 [159];
				row_3 [160] <= row_2 [160];
				row_3 [161] <= row_2 [161];
				row_3 [162] <= row_2 [162];
				row_3 [163] <= row_2 [163];
				row_3 [164] <= row_2 [164];
				row_3 [165] <= row_2 [165];
				row_3 [166] <= row_2 [166];
				row_3 [167] <= row_2 [167];
				row_3 [168] <= row_2 [168];
				row_3 [169] <= row_2 [169];
				row_3 [170] <= row_2 [170];
				row_3 [171] <= row_2 [171];
				row_3 [172] <= row_2 [172];
				row_3 [173] <= row_2 [173];
				row_3 [174] <= row_2 [174];
				row_3 [175] <= row_2 [175];
				row_3 [176] <= row_2 [176];
				row_3 [177] <= row_2 [177];
				row_3 [178] <= row_2 [178];
				row_3 [179] <= row_2 [179];
				
				row_2 [0] <= row_1 [0];
				row_2 [1] <= row_1 [1];
				row_2 [2] <= row_1 [2];
				row_2 [3] <= row_1 [3];
				row_2 [4] <= row_1 [4];
				row_2 [5] <= row_1 [5];
				row_2 [6] <= row_1 [6];
				row_2 [7] <= row_1 [7];
				row_2 [8] <= row_1 [8];
				row_2 [9] <= row_1 [9];
				row_2 [10] <= row_1 [10];
				row_2 [11] <= row_1 [11];
				row_2 [12] <= row_1 [12];
				row_2 [13] <= row_1 [13];
				row_2 [14] <= row_1 [14];
				row_2 [15] <= row_1 [15];
				row_2 [16] <= row_1 [16];
				row_2 [17] <= row_1 [17];
				row_2 [18] <= row_1 [18];
				row_2 [19] <= row_1 [19];
				row_2 [20] <= row_1 [20];
				row_2 [21] <= row_1 [21];
				row_2 [22] <= row_1 [22];
				row_2 [23] <= row_1 [23];
				row_2 [24] <= row_1 [24];
				row_2 [25] <= row_1 [25];
				row_2 [26] <= row_1 [26];
				row_2 [27] <= row_1 [27];
				row_2 [28] <= row_1 [28];
				row_2 [29] <= row_1 [29];
				row_2 [30] <= row_1 [30];
				row_2 [31] <= row_1 [31];
				row_2 [32] <= row_1 [32];
				row_2 [33] <= row_1 [33];
				row_2 [34] <= row_1 [34];
				row_2 [35] <= row_1 [35];
				row_2 [36] <= row_1 [36];
				row_2 [37] <= row_1 [37];
				row_2 [38] <= row_1 [38];
				row_2 [39] <= row_1 [39];
				row_2 [40] <= row_1 [40];
				row_2 [41] <= row_1 [41];
				row_2 [42] <= row_1 [42];
				row_2 [43] <= row_1 [43];
				row_2 [44] <= row_1 [44];
				row_2 [45] <= row_1 [45];
				row_2 [46] <= row_1 [46];
				row_2 [47] <= row_1 [47];
				row_2 [48] <= row_1 [48];
				row_2 [49] <= row_1 [49];
				row_2 [50] <= row_1 [50];
				row_2 [51] <= row_1 [51];
				row_2 [52] <= row_1 [52];
				row_2 [53] <= row_1 [53];
				row_2 [54] <= row_1 [54];
				row_2 [55] <= row_1 [55];
				row_2 [56] <= row_1 [56];
				row_2 [57] <= row_1 [57];
				row_2 [58] <= row_1 [58];
				row_2 [59] <= row_1 [59];
				row_2 [60] <= row_1 [60];
				row_2 [61] <= row_1 [61];
				row_2 [62] <= row_1 [62];
				row_2 [63] <= row_1 [63];
				row_2 [64] <= row_1 [64];
				row_2 [65] <= row_1 [65];
				row_2 [66] <= row_1 [66];
				row_2 [67] <= row_1 [67];
				row_2 [68] <= row_1 [68];
				row_2 [69] <= row_1 [69];
				row_2 [70] <= row_1 [70];
				row_2 [71] <= row_1 [71];
				row_2 [72] <= row_1 [72];
				row_2 [73] <= row_1 [73];
				row_2 [74] <= row_1 [74];
				row_2 [75] <= row_1 [75];
				row_2 [76] <= row_1 [76];
				row_2 [77] <= row_1 [77];
				row_2 [78] <= row_1 [78];
				row_2 [79] <= row_1 [79];
				row_2 [80] <= row_1 [80];
				row_2 [81] <= row_1 [81];
				row_2 [82] <= row_1 [82];
				row_2 [83] <= row_1 [83];
				row_2 [84] <= row_1 [84];
				row_2 [85] <= row_1 [85];
				row_2 [86] <= row_1 [86];
				row_2 [87] <= row_1 [87];
				row_2 [88] <= row_1 [88];
				row_2 [89] <= row_1 [89];
				row_2 [90] <= row_1 [90];
				row_2 [91] <= row_1 [91];
				row_2 [92] <= row_1 [92];
				row_2 [93] <= row_1 [93];
				row_2 [94] <= row_1 [94];
				row_2 [95] <= row_1 [95];
				row_2 [96] <= row_1 [96];
				row_2 [97] <= row_1 [97];
				row_2 [98] <= row_1 [98];
				row_2 [99] <= row_1 [99];
				row_2 [100] <= row_1 [100];
				row_2 [101] <= row_1 [101];
				row_2 [102] <= row_1 [102];
				row_2 [103] <= row_1 [103];
				row_2 [104] <= row_1 [104];
				row_2 [105] <= row_1 [105];
				row_2 [106] <= row_1 [106];
				row_2 [107] <= row_1 [107];
				row_2 [108] <= row_1 [108];
				row_2 [109] <= row_1 [109];
				row_2 [110] <= row_1 [110];
				row_2 [111] <= row_1 [111];
				row_2 [112] <= row_1 [112];
				row_2 [113] <= row_1 [113];
				row_2 [114] <= row_1 [114];
				row_2 [115] <= row_1 [115];
				row_2 [116] <= row_1 [116];
				row_2 [117] <= row_1 [117];
				row_2 [118] <= row_1 [118];
				row_2 [119] <= row_1 [119];
				row_2 [120] <= row_1 [120];
				row_2 [121] <= row_1 [121];
				row_2 [122] <= row_1 [122];
				row_2 [123] <= row_1 [123];
				row_2 [124] <= row_1 [124];
				row_2 [125] <= row_1 [125];
				row_2 [126] <= row_1 [126];
				row_2 [127] <= row_1 [127];
				row_2 [128] <= row_1 [128];
				row_2 [129] <= row_1 [129];
				row_2 [130] <= row_1 [130];
				row_2 [131] <= row_1 [131];
				row_2 [132] <= row_1 [132];
				row_2 [133] <= row_1 [133];
				row_2 [134] <= row_1 [134];
				row_2 [135] <= row_1 [135];
				row_2 [136] <= row_1 [136];
				row_2 [137] <= row_1 [137];
				row_2 [138] <= row_1 [138];
				row_2 [139] <= row_1 [139];
				row_2 [140] <= row_1 [140];
				row_2 [141] <= row_1 [141];
				row_2 [142] <= row_1 [142];
				row_2 [143] <= row_1 [143];
				row_2 [144] <= row_1 [144];
				row_2 [145] <= row_1 [145];
				row_2 [146] <= row_1 [146];
				row_2 [147] <= row_1 [147];
				row_2 [148] <= row_1 [148];
				row_2 [149] <= row_1 [149];
				row_2 [150] <= row_1 [150];
				row_2 [151] <= row_1 [151];
				row_2 [152] <= row_1 [152];
				row_2 [153] <= row_1 [153];
				row_2 [154] <= row_1 [154];
				row_2 [155] <= row_1 [155];
				row_2 [156] <= row_1 [156];
				row_2 [157] <= row_1 [157];
				row_2 [158] <= row_1 [158];
				row_2 [159] <= row_1 [159];
				row_2 [160] <= row_1 [160];
				row_2 [161] <= row_1 [161];
				row_2 [162] <= row_1 [162];
				row_2 [163] <= row_1 [163];
				row_2 [164] <= row_1 [164];
				row_2 [165] <= row_1 [165];
				row_2 [166] <= row_1 [166];
				row_2 [167] <= row_1 [167];
				row_2 [168] <= row_1 [168];
				row_2 [169] <= row_1 [169];
				row_2 [170] <= row_1 [170];
				row_2 [171] <= row_1 [171];
				row_2 [172] <= row_1 [172];
				row_2 [173] <= row_1 [173];
				row_2 [174] <= row_1 [174];
				row_2 [175] <= row_1 [175];
				row_2 [176] <= row_1 [176];
				row_2 [177] <= row_1 [177];
				row_2 [178] <= row_1 [178];
				row_2 [179] <= row_1 [179];
				
				if (row_cnt == HEIGTH + 2) begin //whole image went through analyzer
					finish1 <= 1;
					h <= 0;
					num <= 0;
					row_cnt <= 0;
				end
				else if (row_6[0] > 0) h <= 1; //when rows 2-4 are filled with data, algorithm can start to analyse it
			end
			else begin
				num <= num+1;
				finish1 <= 0;
			end
		end//if
	end//always
	
	//-------DATA ANALYZING-------//
	
	//just for waveform analysing purposes
	//two signals to spot dark and light pixels using simple tresholds
	wire light;
	wire dark;
	assign light = (saturation > 110) ? 1:0;
	assign dark = (saturation <30) ? 1:0;
	
	//Haar function for discrete signal: 
	//for each pair 'current pixel+its neighbour', two values are calculated: 
	//for neighbour to the rignt
	reg [7:0] haar_Ra = 8'b0;
	reg signed [8:0] haar_Rb = 9'b0;
	//for neighbour to the left
	reg [7:0] haar_La = 8'b0;
	reg signed [8:0] haar_Lb = 9'b0;
	//for neighbour up
	reg [7:0] haar_Ua = 8'b0;
	reg signed [8:0] haar_Ub = 9'b0;
	//for neighbour down
	reg [7:0] haar_Ba = 8'b0;
	reg signed [8:0] haar_Bb = 9'b0;
	
	always @(posedge clk) begin
		if (h) begin
			haar_Ra <= (row_4[num] + row_4[num+RAD])/2;
			haar_Rb <= (row_4[num] - row_4[num+RAD])/2;
			haar_La <= (row_4[num] + row_4[num-RAD])/2;
			haar_Lb <= (row_4[num] - row_4[num-RAD])/2;
			haar_Ua <= (row_4[num] + row_2[num])/2;
			haar_Ub <= (row_4[num] - row_2[num])/2;
			haar_Ba <= (row_4[num] + row_6[num])/2;
			haar_Bb <= (row_4[num] - row_6[num])/2;
		end//if h
	end//always
	
	//-------ROW BORDERS SEARCHING-------//
	
	reg cnt_init = 1'b0;//signal to start count number and sizes of cells when border of screen is spotted
	
	//weird connection to swithch berween screen and cells borders searchings
	reg cnt_init_busy = 1'b0;
	//dont even ask
	//but if you do, cnt_init starts cell searching and stops screen borders searching
	//it goes high when screen border found (and  therefore signal cnt_init_1 generated) AND
	//AND cnt_init_busy is not high (_busy indicates that cell searching is going on)
	
	//as a result, screen and cells searchings should go one after another
	
	reg wait_init = 1'b0;
	
	//coordinates of the found row's edge will be stored in these registers:
	reg [10:0] row_h_coords = 11'b0;
	reg [10:0] row_v_coords = 11'b0;
	
	reg [10:0] screen_h = 11'b0; //to store horisontal size of the screen (in pixels)
	wire [11:0] screen_v; //to store vertical size of the screen (in pixels) 
	
	always @(posedge clk) begin
		if (h) begin
			if (c == 2) begin
				if (num < WIDHT/8 && (haar_Ub < -100 || haar_Ub > 100) && cnt_init_busy == 0 && wait_init == 0) begin
					//if the value of Haar B functions for upper neighbour is larger 
					//than treshold, we spotted a start of new row of cells
					wait_init <= 1;
					row_h_coords <= num;
					row_v_coords <= row_cnt - 3;
				end
				//wait for the next row for certainty
				else if (wait_init == 1 && num == row_h_coords && row_cnt == row_v_coords + 6) begin 
					cnt_init <= 1;
					wait_init <= 0;
				end
				else cnt_init <= 0;
			end//if
		end//ifh
		else if (state == WAIT) begin
			wait_init <= 0;
			cnt_init <= 0;
			row_h_coords <= 0;
			row_v_coords <= 0;
		end
	end//always
	
	//-------CELLS BORDERS SEARCHING-------//
	
	reg extract_init = 1'b0;
	
	reg [5:0] cell_number = 6'b0;//register to store calculeted number of cells in an each row
	
	//for each cell in a row its size (in pixels) will be counted
	//(sizes are the same on a smartphone screen, but captured image of the screen may have distortions)
	reg [3:0] cell_size_0 = 4'b0;
	reg [3:0] cell_size_1 = 4'b0;
	reg [3:0] cell_size_2 = 4'b0;
	reg [3:0] cell_size_3 = 4'b0;
	reg [3:0] cell_size_4 = 4'b0;
	reg [3:0] cell_size_5 = 4'b0;
	reg [3:0] cell_size_6 = 4'b0;
	reg [3:0] cell_size_7 = 4'b0;
	reg [3:0] cell_size_8 = 4'b0;
	
	reg [3:0] cell_size_9 = 4'b0;
	reg [3:0] cell_size_10 = 4'b0;
	reg [3:0] cell_size_11 = 4'b0;
	reg [3:0] cell_size_12 = 4'b0;
	reg [3:0] cell_size_13 = 4'b0;
	reg [3:0] cell_size_14 = 4'b0;
	reg [3:0] cell_size_15 = 4'b0;
	reg [3:0] cell_size_16 = 4'b0;
	reg [3:0] cell_size_17 = 4'b0;
	
	reg [3:0] cell_size_18 = 4'b0;
	reg [3:0] cell_size_19 = 4'b0;
	reg [3:0] cell_size_20 = 4'b0;
	reg [3:0] cell_size_21 = 4'b0;
	reg [3:0] cell_size_22 = 4'b0;
	reg [3:0] cell_size_23 = 4'b0;
	reg [3:0] cell_size_24 = 4'b0;
	reg [3:0] cell_size_25 = 4'b0;
	reg [3:0] cell_size_26 = 4'b0;
	
	reg once = 1'b0;
	
	always @(posedge clk) begin
		if ((cnt_init || cnt_init_busy) && !once) begin
			if(c == 2) begin
				screen_h <= screen_h + 1;//we can start counting horisontal length of the screen
				if (cell_number == 0) begin
					extract_init <= 0;
					cnt_init_busy <= 1;
					cell_size_0 <= cell_size_0 + 1;
					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_0 > 2) begin
						//border between cells found, switch to count next cell's size
						cell_number <= 1;
					end
				end
				else if (cell_number == 1) begin 
					cell_size_1 <= cell_size_1 + 1;
					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_1 > 2) begin
						cell_number <= 2;
					end
				end
				else if (cell_number == 2) begin
					cell_size_2 <= cell_size_2 + 1;
					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_2 > 2) begin
						cell_number <= 3;
					end
				end
				else if (cell_number == 3) begin
					cell_size_3 <= cell_size_3 + 1;
					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_3 > 2) begin
						cell_number <= 4;
					end
				end
				else if (cell_number == 4) begin
					cell_size_4 <= cell_size_4 + 1;
					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_4 > 2) begin
						cell_number <= 5;
					end
				end
				else if (cell_number == 5) begin
					cell_size_5 <= cell_size_5 + 1;
					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_5 > 2) begin
						cell_number <= 6;
					end
				end
				else if (cell_number == 6) begin
					cell_size_6 <= cell_size_6 + 1;
					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_6 > 2) begin
						cell_number <= 7;
					end
				end
				else if (cell_number == 7) begin
					cell_size_7 <= cell_size_7 + 1;
					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_7 > 2) begin
						cell_number <= 8;
					end
				end
				else if (cell_number == 8) begin
					cell_size_8 <= cell_size_8 + 1;
					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_8 > 2) begin
						cell_number <= 9;
					end
				end
				else if (cell_number == 9) begin
					cell_size_9 <= cell_size_9 + 1;
					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_9 > 2) begin
						cell_number <= 10;
					end
				end
				else if (cell_number == 10) begin
					cell_size_10 <= cell_size_10 + 1;
					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_10 > 2) begin
						cell_number <= 11;
					end
				end
				else if (cell_number == 11) begin
					cell_size_11 <= cell_size_11 + 1;
					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_11 > 2) begin
						cell_number <= 12;
					end
				end
				else if (cell_number == 12) begin
					cell_size_12 <= cell_size_12 + 1;
					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_12 > 2) begin
						cell_number <= 13;
					end
				end
				else if (cell_number == 13) begin
					cell_size_13 <= cell_size_13 + 1;
					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_13 > 2) begin
						cell_number <= 14;
					end
				end
				else if (cell_number == 14) begin
					cell_size_14 <= cell_size_14 + 1;
					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_14 > 2) begin
						cell_number <= 15;
					end
				end
				else if (cell_number == 15) begin
					cell_size_15 <= cell_size_15 + 1;
					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_15 > 2) begin
						cell_number <= 16;
					end
				end
				else if (cell_number == 16) begin
					cell_size_16 <= cell_size_16 + 1;
					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_16 > 2) begin
						cell_number <= 17;
					end
				end
				//the following addition was made for the testing of image with 27x42 cells
//				else if (cell_number == 17) begin
//					cell_size_17 <= cell_size_17 + 1;
//					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_17 > 2) begin
//						cell_number <= 18;
//					end
//				end
//				else if (cell_number == 18) begin
//					cell_size_18 <= cell_size_18 + 1;
//					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_18 > 2) begin
//						cell_number <= 19;
//					end
//				end
//				else if (cell_number == 19) begin
//					cell_size_19 <= cell_size_19 + 1;
//					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_19 > 2) begin
//						cell_number <= 20;
//					end
//				end
//				else if (cell_number == 20) begin
//					cell_size_20 <= cell_size_20 + 1;
//					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_20 > 2) begin
//						cell_number <= 21;
//					end
//				end
//				else if (cell_number == 21) begin
//					cell_size_21 <= cell_size_21 + 1;
//					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_21 > 2) begin
//						cell_number <= 22;
//					end
//				end
//				else if (cell_number == 22) begin
//					cell_size_22 <= cell_size_22 + 1;
//					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_22 > 2) begin
//						cell_number <= 23;
//					end
//				end
//				else if (cell_number == 23) begin
//					cell_size_23 <= cell_size_23 + 1;
//					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_23 > 2) begin
//						cell_number <= 24;
//					end
//				end
//				else if (cell_number == 24) begin
//					cell_size_24 <= cell_size_24 + 1;
//					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_24 > 2) begin
//						cell_number <= 25;
//					end
//				end
//				else if (cell_number == 25) begin
//					cell_size_25 <= cell_size_25 + 1;
//					if ((haar_Rb < -TRESHOLD || haar_Rb > TRESHOLD) && cell_size_25 > 2) begin
//						cell_number <= 26;
//					end
//				end
				else if (cell_number == 17) begin
					cell_size_17 <= cell_size_17 + 1;
					if ((haar_Rb < -TRESHOLD/2 || haar_Rb > TRESHOLD/2) && cell_size_17 > 2) begin
						//if this cell is the last, stop counting
						cell_number <= 0;
						cnt_init_busy <= 0;
						//and start extracting
						extract_init <= 1;
						once <= 1;
					end
					else if (num == WIDHT - 2) begin
						cell_size_17 <= cell_size_16;
						cell_number <= 0;
						cnt_init_busy <= 0;
						extract_init <= 1;
						once <= 1;
					end
				end//cell_17
			end//if c==2
		end//if init
		else if ((cnt_init || cnt_init_busy) && once) begin //if cell sizes are already counted
			if (c == 2) begin
				//just wait till the end of the row
				if (num < WIDHT - 2) begin 
					cnt_init_busy <= 1;
					extract_init <= 0;
				end
				else if (num == WIDHT - 2) begin
					cnt_init_busy <= 0;
					extract_init <= 1;
				end
			end//if c==2
		end//if init & once
		else if (state == WAIT) begin
			screen_h <= 0;
			cell_size_0 <= 0;
			cell_size_1 <= 0;
			cell_size_2 <= 0;
			cell_size_3 <= 0;
			cell_size_4 <= 0;
			cell_size_5 <= 0;
			cell_size_6 <= 0;
			cell_size_7 <= 0;
			cell_size_8 <= 0;
			cell_size_9 <= 0;
			cell_size_10 <= 0;
			cell_size_11 <= 0;
			cell_size_12 <= 0;
			cell_size_13 <= 0;
			cell_size_14 <= 0;
			cell_size_15 <= 0;
			cell_size_16 <= 0;
			cell_size_17 <= 0;
			
			extract_init <= 0;
			cnt_init_busy <= 0;
			once <= 0;
		end
	end//always
	
	//-------DATA EXTRACTION-------//
	
	//data is being extracted from the centre of each cell by targeting to 
	//[row_horizontal_coordinates + size_of_all_previous_cells + 1/2_size_of_target_cell] position in a 
	//[row_vertical_coordinates + size_of_all_previous_rows_of_cells + 1/2_size_of_targer_row_of_cells] row
	
	//the following are two differenr extraction algorithms: for black&white encoding and for grayscale encoding
	//uncomment the one you need right now and comment other
	//suggestion: create a parameter TYPE (of image) and write FSM that chooses algorithm depending on this parameter. 
	//But now I'm to lasy to do it
	
	//for black&white:
	
	wire [18:0] data; //each cell stores one bit of data
	assign data [17] = (row_4[row_h_coords + (cell_size_0)/2] > 127) ? 0:1;
	assign data [16] = (row_4[row_h_coords + cell_size_0 + (cell_size_1)/2] > 127) ? 0:1;
	assign data [15] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + (cell_size_2)/2] > 127) ? 0:1;
	assign data [14] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + (cell_size_3)/2] > 127) ? 0:1;
	assign data [13] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + (cell_size_4)/2] > 127) ? 0:1;
	assign data [12] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + (cell_size_5)/2] > 127) ? 0:1;
	assign data [11] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + (cell_size_6)/2] > 127) ? 0:1;
	assign data [10] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + (cell_size_7)/2] > 127) ? 0:1;
	assign data [9] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + cell_size_7 + (cell_size_8)/2] > 127) ? 0:1;
	assign data [8] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + cell_size_7 + cell_size_8 + (cell_size_9)/2] > 127) ? 0:1;
	assign data [7] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + cell_size_7 + cell_size_8 + cell_size_9 + (cell_size_10)/2] > 127) ? 0:1;
	assign data [6] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + cell_size_7 + cell_size_8 + cell_size_9 + cell_size_10 + (cell_size_11)/2] > 127) ? 0:1;
	assign data [5] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + cell_size_7 + cell_size_8 + cell_size_9 + cell_size_10 + cell_size_11 + (cell_size_12)/2] > 127) ? 0:1;
	assign data [4] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + cell_size_7 + cell_size_8 + cell_size_9 + cell_size_10 + cell_size_11 + cell_size_12 + (cell_size_13)/2] > 127) ? 0:1;
	assign data [3] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + cell_size_7 + cell_size_8 + cell_size_9 + cell_size_10 + cell_size_11 + cell_size_12 + cell_size_13 + (cell_size_14)/2] > 127) ? 0:1;
	assign data [2] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + cell_size_7 + cell_size_8 + cell_size_9 + cell_size_10 + cell_size_11 + cell_size_12 + cell_size_13 + cell_size_14 + (cell_size_15)/2] > 127) ? 0:1;
	assign data [1] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + cell_size_7 + cell_size_8 + cell_size_9 + cell_size_10 + cell_size_11 + cell_size_12 + cell_size_13 + cell_size_14 + cell_size_15 + (cell_size_16)/2] > 127) ? 0:1;
	assign data [0] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + cell_size_7 + cell_size_8 + cell_size_9 + cell_size_10 + cell_size_11 + cell_size_12 + cell_size_13 + cell_size_14 + cell_size_15 + cell_size_16 + (cell_size_17)/2] > 127) ? 0:1;
//	assign data [8] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + cell_size_7 + cell_size_8 + cell_size_9 + cell_size_10 + cell_size_11 + cell_size_12 + cell_size_13 + cell_size_14 + cell_size_15 + cell_size_16 + cell_size_17 + (cell_size_18)/2] > 127) ? 0:1;
//	assign data [7] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + cell_size_7 + cell_size_8 + cell_size_9 + cell_size_10 + cell_size_11 + cell_size_12 + cell_size_13 + cell_size_14 + cell_size_15 + cell_size_16 + cell_size_17 + cell_size_18 + (cell_size_19)/2] > 127) ? 0:1;
//	assign data [6] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + cell_size_7 + cell_size_8 + cell_size_9 + cell_size_10 + cell_size_11 + cell_size_12 + cell_size_13 + cell_size_14 + cell_size_15 + cell_size_16 + cell_size_17 + cell_size_18 + cell_size_19 + (cell_size_20)/2] > 127) ? 0:1;
//	assign data [5] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + cell_size_7 + cell_size_8 + cell_size_9 + cell_size_10 + cell_size_11 + cell_size_12 + cell_size_13 + cell_size_14 + cell_size_15 + cell_size_16 + cell_size_17 + cell_size_18 + cell_size_19 + cell_size_20 + (cell_size_21)/2] > 127) ? 0:1;
//	assign data [4] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + cell_size_7 + cell_size_8 + cell_size_9 + cell_size_10 + cell_size_11 + cell_size_12 + cell_size_13 + cell_size_14 + cell_size_15 + cell_size_16 + cell_size_17 + cell_size_18 + cell_size_19 + cell_size_20 + cell_size_21 + (cell_size_22)/2] > 127) ? 0:1;
//	assign data [3] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + cell_size_7 + cell_size_8 + cell_size_9 + cell_size_10 + cell_size_11 + cell_size_12 + cell_size_13 + cell_size_14 + cell_size_15 + cell_size_16 + cell_size_17 + cell_size_18 + cell_size_19 + cell_size_20 + cell_size_21 + cell_size_22 + (cell_size_23)/2] > 127) ? 0:1;
//	assign data [2] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + cell_size_7 + cell_size_8 + cell_size_9 + cell_size_10 + cell_size_11 + cell_size_12 + cell_size_13 + cell_size_14 + cell_size_15 + cell_size_16 + cell_size_17 + cell_size_18 + cell_size_19 + cell_size_20 + cell_size_21 + cell_size_22 + cell_size_23 + (cell_size_24)/2] > 127) ? 0:1;
//	assign data [1] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + cell_size_7 + cell_size_8 + cell_size_9 + cell_size_10 + cell_size_11 + cell_size_12 + cell_size_13 + cell_size_14 + cell_size_15 + cell_size_16 + cell_size_17 + cell_size_18 + cell_size_19 + cell_size_20 + cell_size_21 + cell_size_22 + cell_size_23 + cell_size_24 + (cell_size_25)/2] > 127) ? 0:1;
//	assign data [0] = (row_4[row_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + cell_size_7 + cell_size_8 + cell_size_9 + cell_size_10 + cell_size_11 + cell_size_12 + cell_size_13 + cell_size_14 + cell_size_15 + cell_size_16 + cell_size_17 + cell_size_18 + cell_size_19 + cell_size_20 + cell_size_21 + cell_size_22 + cell_size_23 + cell_size_24 + cell_size_25 + (cell_size_26)/2] > 127) ? 0:1;
	
	//for grayscale;
//	reg [17:0] data; //each cell stores two bits of data
//	
//	always @(posedge clk) begin
//		data [17:16] <= ~(row_4[row_h_coords + (cell_size_0)/2]+1)/70;
//		data [15:14] <= ~(row_4[corner_h_coords + cell_size_0 + (cell_size_1)/2]+1)/70;
//		data [13:12] <= ~(row_4[corner_h_coords + cell_size_0 + cell_size_1 + (cell_size_2)/2]+1)/70;
//		data [11:10] <= ~(row_4[corner_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + (cell_size_3)/2]+1)/70;
//		data [9:8] <= ~(row_4[corner_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + (cell_size_4)/2]+1)/70;
//		data [7:6] <= ~(row_4[corner_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + (cell_size_5)/2]+1)/70;
//		data [5:4] <= ~(row_4[corner_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + (cell_size_6)/2]+1)/70;
//		data [3:2] <= ~(row_4[corner_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + (cell_size_7)/2]+1)/70;
//		data [1:0] <= ~(row_4[corner_h_coords + cell_size_0 + cell_size_1 + cell_size_2 + cell_size_3 + cell_size_4 + cell_size_5 + cell_size_6 + cell_size_7 + (cell_size_8)/2]+1)/70;
//	end
//	
	reg [17:0] dataout [0:31]; //two-dimentional array of data for two-dimentional array of cells on a screen
	//the folloving signal exists and belongs to this part of algorithm
	//it was commented out, because it's already declarated in Inputs/Outputs section
	//commennts were left here to describe what it is
	//reg finish = 1'b0;//signal that shows that all data was extracted, can be used for synchronisation with next stage
	reg [5:0] cell_row = 6'b0;
	
	reg extract2;
	always @(posedge clk) extract2 <= ~extract_init;
	wire extract;
	assign extract = extract_init & extract2;
	
	always @(posedge clk) begin
		if (extract) begin //if previous stage stopped measuring borders
			dataout [31 - cell_row] <= data;
			cell_row <= cell_row + 1;
		end //if extract_init
		
		else if (state == WAIT) begin 
			dataout [31] <= 0;
			dataout [30] <= 0;
			dataout [29] <= 0;
			dataout [28] <= 0;
			dataout [27] <= 0;
			dataout [26] <= 0;
			dataout [25] <= 0;
			dataout [24] <= 0;
			dataout [23] <= 0;
			dataout [22] <= 0;
			dataout [21] <= 0;
			dataout [20] <= 0;
			dataout [19] <= 0;
			dataout [18] <= 0;
			dataout [17] <= 0;
			dataout [16] <= 0;
			dataout [15] <= 0;
			dataout [14] <= 0;
			dataout [13] <= 0;
			dataout [12] <= 0;
			dataout [11] <= 0;
			dataout [10] <= 0;
			dataout [9] <= 0;
			dataout [8] <= 0;
			dataout [7] <= 0;
			dataout [6] <= 0;
			dataout [5] <= 0;
			dataout [4] <= 0;
			dataout [3] <= 0;
			dataout [2] <= 0;
			dataout [1] <= 0;
			dataout [0] <= 0;
			
			cell_row <= 0;
		end
	end//always
	
endmodule
