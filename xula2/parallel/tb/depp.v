//Depp module
//Developed by F.M.Zhu

module depp (
	clk		//clock
	, a_astb	//depp address strobe, active low
	, a_dstb	//depp data strobe, active low
	, a_write	//depp write signal, active low
	, a_db		//bi directional data bus
	, a_wait	//indicate peripheral is ready to accept data or has data available
	, a_addr_reg	//latch address to show on led
	);

input 		clk;

//DEPP ports (a stands for async)
input 		a_astb, a_dstb, a_write;
inout	[7:0]	a_db;
output		a_wait;
output	[7:0]	a_addr_reg;

//registers and wires
reg	[7:0]	a_data_reg;
reg	[7:0]	a_addr_reg;
reg	[2:0]	a_astb_sr, a_dstb_sr;

wire a_wait = ~a_astb | ~a_dstb;
wire a_db = (a_write) ? a_data_reg : 8'bZZZZ_ZZZZ;  

//stb signal will hold low for more than 80 ns
//data will is stable during this period
always @ (posedge clk) begin
	a_astb_sr <= {a_astb_sr[1:0], a_astb};
	a_dstb_sr <= {a_dstb_sr[1:0], a_dstb};
end

always @ (posedge clk)
	if (~a_write && a_astb_sr == 3'b100)
		a_addr_reg <= a_db;

always @ (posedge clk)
	if (~a_write && a_dstb_sr == 3'b100)
		a_data_reg <= a_db;

endmodule
		
