// File: catboard.v
// Generated by MyHDL 1.0dev
// Date: Mon May  9 18:45:44 2016


`timescale 1ns/10ps

module catboard (
    clock,
    to_rpi2B,
    fr_rpi2B,
    a_dstb,
    a_astb,
    a_write,
    a_wait
);


input clock;
input [6:0] to_rpi2B;
input [7:0] fr_rpi2B;
input a_dstb;
input a_astb;
input a_write;
output a_wait;
wire a_wait;

reg reset;
reg [2:0] a_dstb_sr;
reg [2:0] a_astb_sr;
reg [7:0] a_addr_reg;
reg [4:0] reset_dly_cnt;
reg [7:0] a_data_reg;




// For the first 4 clocks the reset is forced to lo
// for clock 6 to 31 the reset is set hi
// then the reset is lo
always @(posedge clock) begin: CATBOARD_RESET_TST
    if ((reset_dly_cnt < 10)) begin
        reset_dly_cnt <= (reset_dly_cnt + 1);
        if ((reset_dly_cnt <= 4)) begin
            reset <= 0;
        end
        if ((reset_dly_cnt >= 5)) begin
            reset <= 1;
        end
    end
    else begin
        reset <= 0;
    end
end


always @(posedge clock) begin: CATBOARD_DUT_DEPP_RTL2
    a_astb_sr <= {a_astb_sr[2-1:0], a_astb};
    a_dstb_sr <= {a_dstb_sr[2-1:0], a_dstb};
end


always @(posedge clock) begin: CATBOARD_DUT_DEPP_RTL3
    if (((~a_write) && (a_astb_sr == 4))) begin
        a_addr_reg <= fr_rpi2B;
    end
end



assign a_wait = ((!a_astb) || (!a_dstb));


always @(posedge clock) begin: CATBOARD_DUT_DEPP_RTL4
    if (((~a_write) && (a_dstb_sr == 4))) begin
        a_data_reg <= fr_rpi2B;
    end
end

endmodule
