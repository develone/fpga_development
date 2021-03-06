// File: xula2.v
// Generated by MyHDL 1.0dev
// Date: Thu May 19 16:36:53 2016


`timescale 1ns/10ps

module xula2 (
    clock,
    fr_rpi2B,
    a_dstb,
    a_astb,
    a_write,
    a_wait,
    to_rpi2B
);


input clock;
input [7:0] fr_rpi2B;
input a_dstb;
input a_astb;
input a_write;
output a_wait;
wire a_wait;
output [7:0] to_rpi2B;
reg [7:0] to_rpi2B;

reg reset;
reg [7:0] a_addr_reg;
reg [4:0] reset_dly_cnt;
reg [7:0] a_data_reg;
reg [2:0] dut_depp_a_dstb_sr;
reg [2:0] dut_depp_a_astb_sr;




// For the first 4 clocks the reset is forced to lo
// for clock 6 to 31 the reset is set hi
// then the reset is lo
always @(posedge clock) begin: XULA2_RESET_TST
    if ((reset_dly_cnt < 10)) begin
        reset_dly_cnt <= (reset_dly_cnt + 1);
        if ((reset_dly_cnt <= 4)) begin
            reset <= 1;
        end
        if ((reset_dly_cnt >= 5)) begin
            reset <= 0;
        end
    end
    else begin
        reset <= 1;
    end
end



assign a_wait = ((!a_astb) || (!a_dstb));


always @(posedge clock) begin: XULA2_DUT_DEPP_RTL2
    dut_depp_a_astb_sr <= {dut_depp_a_astb_sr[2-1:0], a_astb};
    dut_depp_a_dstb_sr <= {dut_depp_a_dstb_sr[2-1:0], a_dstb};
end


always @(posedge clock) begin: XULA2_DUT_DEPP_RTL3
    if (((~a_write) && (dut_depp_a_astb_sr == 4))) begin
        a_addr_reg <= fr_rpi2B;
    end
end


always @(posedge clock) begin: XULA2_DUT_DEPP_RTL4
    if (((~a_write) && (dut_depp_a_dstb_sr == 4))) begin
        a_data_reg <= fr_rpi2B;
    end
end


always @(posedge clock) begin: XULA2_DUT_DEPP_RTL5
    if ((a_write == 1)) begin
        to_rpi2B <= a_data_reg;
    end
end

endmodule
