// File: xula2.v
// Generated by MyHDL 1.0dev
// Date: Thu May 19 12:32:46 2016


`timescale 1ns/10ps

module xula2 (
    clock,
    led,
    bcm14_txd,
    bcm15_rxd,
    a_dstb,
    a_astb,
    a_write,
    a_wait,
    to_rpi2B,
    fr_rpi2B
);
// The LEDs are controlled from the RPi over the UART
// to the FPGA.

input clock;
output [7:0] led;
reg [7:0] led;
input bcm14_txd;
output bcm15_rxd;
wire bcm15_rxd;
input a_dstb;
input a_astb;
input a_write;
output a_wait;
wire a_wait;
output [7:0] to_rpi2B;
reg [7:0] to_rpi2B;
input [7:0] fr_rpi2B;

reg [2:0] a_dstb_sr;
reg [7:0] tone;
reg [7:0] a_data_reg;
reg [27:0] memmap_mem_addr;
reg [2:0] a_astb_sr;
reg glbl_tick_sec;
reg [4:0] reset_dly_cnt;
reg memmap_done;
reg [7:0] a_addr_reg;
reg [7:0] ledreg;
reg reset;
reg memmap_read;
reg [31:0] memmap_write_data;
reg memmap_write;
reg [31:0] memmap_read_data;
reg cmd_inst_fifobus_write;
reg cmd_inst_ready;
wire cmd_inst_fifobus_empty;
wire cmd_inst_fifobus_read_valid;
reg [3:0] cmd_inst_state;
wire [7:0] cmd_inst_fifobus_read_data;
reg [7:0] cmd_inst_bytemon;
reg [7:0] cmd_inst_fifobus_write_data;
wire cmd_inst_fifobus_full;
wire [31:0] cmd_inst_address;
wire [31:0] cmd_inst_data;
reg [3:0] cmd_inst_bb_per_addr;
reg cmd_inst_fifobus_read;
reg cmd_inst_error;
reg [5:0] cmd_inst_mmc_inst_tocnt;
reg [2:0] cmd_inst_mmc_inst_state;
wire [7:0] uart_inst_fbusrx_read_data;
wire uart_inst_fbusrx_read;
reg uart_inst_fbusrx_empty;
reg uart_inst_baudce16;
reg uart_inst_tx;
wire uart_inst_rx;
reg uart_inst_baudce;
reg uart_inst_fbustx_full;
wire uart_inst_fbusrx_read_valid;
wire [7:0] uart_inst_fbustx_write_data;
wire uart_inst_fbustx_write;
reg uart_inst_rx_inst_midbit;
reg [7:0] uart_inst_rx_inst_rxbyte;
reg uart_inst_rx_inst_rxinprog;
reg uart_inst_rx_inst_rxd;
reg [7:0] uart_inst_rx_inst_fbusrx_write_data;
reg [1:0] uart_inst_rx_inst_state;
reg [3:0] uart_inst_rx_inst_mcnt;
reg [3:0] uart_inst_rx_inst_bitcnt;
reg uart_inst_rx_inst_fbusrx_write;
reg [7:0] uart_inst_tx_inst_txbyte;
reg uart_inst_tx_inst_fbustx_empty;
reg uart_inst_tx_inst_fbustx_read;
reg [3:0] uart_inst_tx_inst_bitcnt;
reg [2:0] uart_inst_tx_inst_state;
wire [7:0] uart_inst_tx_inst_fbustx_read_data;
reg [10:0] uart_inst_baud_inst_cnt;
reg [3:0] uart_inst_baud_inst_cnt16;
reg [2:0] uart_inst_fifo_rx_inst_nvacant;
reg uart_inst_fifo_rx_inst_fbus_full;
reg [1:0] uart_inst_fifo_rx_inst_addr;
reg [2:0] uart_inst_fifo_rx_inst_ntenant;
wire uart_inst_fifo_rx_inst_fbus_clear;
wire [2:0] uart_inst_fifo_rx_inst_fbus_count;
reg [2:0] uart_inst_fifo_tx_inst_nvacant;
reg [1:0] uart_inst_fifo_tx_inst_addr;
reg [2:0] uart_inst_fifo_tx_inst_ntenant;
wire uart_inst_fifo_tx_inst_fbus_clear;
wire [2:0] uart_inst_fifo_tx_inst_fbus_count;
wire uart_inst_fifo_tx_inst_fbus_read_valid;
reg [13:0] tick_inst_mscnt;
reg [9:0] tick_inst_seccnt;
reg tick_inst_g2_increment;

reg [7:0] cmd_inst_packet [0:12-1];
reg [7:0] uart_inst_fifo_rx_inst_mem [0:4-1];
reg [7:0] uart_inst_fifo_tx_inst_mem [0:4-1];
reg uart_inst_synctx_inst_staps [0:3-1];
reg uart_inst_syncrx_inst_staps [0:3-1];

assign uart_inst_fifo_rx_inst_fbus_clear = 0;
assign uart_inst_fifo_tx_inst_fbus_clear = 0;

assign cmd_inst_address[32-1:24] = cmd_inst_packet[2];
assign cmd_inst_address[24-1:16] = cmd_inst_packet[3];
assign cmd_inst_address[16-1:8] = cmd_inst_packet[4];
assign cmd_inst_address[8-1:0] = cmd_inst_packet[5];
assign cmd_inst_data[32-1:24] = cmd_inst_packet[8];
assign cmd_inst_data[24-1:16] = cmd_inst_packet[9];
assign cmd_inst_data[16-1:8] = cmd_inst_packet[10];
assign cmd_inst_data[8-1:0] = cmd_inst_packet[11];


always @(posedge clock, negedge reset) begin: XULA2_TICK_INST_G1_RTL_COUNT
    if (reset == 0) begin
        tick_inst_mscnt <= 0;
    end
    else begin
        if (1'b1) begin
            if (($signed({1'b0, tick_inst_mscnt}) == (12000 - 1))) begin
                tick_inst_mscnt <= 0;
            end
            else begin
                tick_inst_mscnt <= (tick_inst_mscnt + 1);
            end
        end
    end
end


always @(posedge clock) begin: XULA2_TICK_INST_G1_RTL_OVERFLOW
    if ((1'b1 && ($signed({1'b0, tick_inst_mscnt}) == (12000 - 2)))) begin
        tick_inst_g2_increment <= 1'b1;
    end
    else begin
        tick_inst_g2_increment <= 1'b0;
    end
end


always @(posedge clock, negedge reset) begin: XULA2_TICK_INST_G2_RTL_COUNT
    if (reset == 0) begin
        tick_inst_seccnt <= 0;
    end
    else begin
        if (tick_inst_g2_increment) begin
            if (($signed({1'b0, tick_inst_seccnt}) == (1000 - 1))) begin
                tick_inst_seccnt <= 0;
            end
            else begin
                tick_inst_seccnt <= (tick_inst_seccnt + 1);
            end
        end
    end
end


always @(posedge clock) begin: XULA2_TICK_INST_G2_RTL_OVERFLOW
    if ((tick_inst_g2_increment && ($signed({1'b0, tick_inst_seccnt}) == (1000 - 2)))) begin
        glbl_tick_sec <= 1'b1;
    end
    else begin
        glbl_tick_sec <= 1'b0;
    end
end



assign uart_inst_rx = uart_inst_syncrx_inst_staps[(3 - 1)];


always @(posedge clock) begin: XULA2_UART_INST_SYNCRX_INST_BEH_SYNC_STAGES
    integer ii;
    uart_inst_syncrx_inst_staps[0] <= bcm14_txd;
    for (ii=1; ii<3; ii=ii+1) begin
        uart_inst_syncrx_inst_staps[ii] <= uart_inst_syncrx_inst_staps[(ii - 1)];
    end
end


always @(posedge clock, negedge reset) begin: XULA2_UART_INST_BAUD_INST_RTLBAUD16
    if (reset == 0) begin
        uart_inst_baud_inst_cnt <= 0;
        uart_inst_baudce16 <= 0;
    end
    else begin
        if ((uart_inst_baud_inst_cnt >= 529)) begin
            uart_inst_baud_inst_cnt <= (uart_inst_baud_inst_cnt - 529);
            uart_inst_baudce16 <= 1'b1;
        end
        else begin
            uart_inst_baud_inst_cnt <= (uart_inst_baud_inst_cnt + 96);
            uart_inst_baudce16 <= 1'b0;
        end
    end
end


always @(posedge clock, negedge reset) begin: XULA2_UART_INST_BAUD_INST_RTLBAUD
    if (reset == 0) begin
        uart_inst_baud_inst_cnt16 <= 0;
        uart_inst_baudce <= 0;
    end
    else begin
        if (uart_inst_baudce16) begin
            uart_inst_baud_inst_cnt16 <= (uart_inst_baud_inst_cnt16 + 1);
            if ((uart_inst_baud_inst_cnt16 == 0)) begin
                uart_inst_baudce <= 1'b1;
            end
            else begin
                uart_inst_baudce <= 1'b0;
            end
        end
        else begin
            uart_inst_baudce <= 1'b0;
        end
    end
end


always @(posedge clock) begin: XULA2_UART_INST_RX_INST_RTLMID
    uart_inst_rx_inst_rxd <= uart_inst_rx;
    if (((uart_inst_rx_inst_rxd && (!uart_inst_rx)) && (uart_inst_rx_inst_state == 2'b00))) begin
        uart_inst_rx_inst_mcnt <= 0;
        uart_inst_rx_inst_rxinprog <= 1'b1;
    end
    else if ((uart_inst_rx_inst_rxinprog && (uart_inst_rx_inst_state == 2'b11))) begin
        uart_inst_rx_inst_rxinprog <= 1'b0;
    end
    else if (uart_inst_baudce16) begin
        uart_inst_rx_inst_mcnt <= (uart_inst_rx_inst_mcnt + 1);
    end
    if ((uart_inst_rx_inst_rxinprog && (uart_inst_rx_inst_mcnt == 7) && uart_inst_baudce16)) begin
        uart_inst_rx_inst_midbit <= 1'b1;
    end
    else begin
        uart_inst_rx_inst_midbit <= 1'b0;
    end
end


always @(posedge clock, negedge reset) begin: XULA2_UART_INST_RX_INST_RTLRX
    if (reset == 0) begin
        uart_inst_rx_inst_bitcnt <= 0;
        uart_inst_rx_inst_fbusrx_write_data <= 0;
        uart_inst_rx_inst_state <= 2'b00;
        uart_inst_rx_inst_rxbyte <= 0;
        uart_inst_rx_inst_fbusrx_write <= 0;
    end
    else begin
        uart_inst_rx_inst_fbusrx_write <= 1'b0;
        case (uart_inst_rx_inst_state)
            2'b00: begin
                if ((uart_inst_rx_inst_midbit && (!uart_inst_rx))) begin
                    uart_inst_rx_inst_state <= 2'b01;
                end
            end
            2'b01: begin
                if (uart_inst_rx_inst_midbit) begin
                    uart_inst_rx_inst_rxbyte[uart_inst_rx_inst_bitcnt] <= uart_inst_rx;
                    uart_inst_rx_inst_bitcnt <= (uart_inst_rx_inst_bitcnt + 1);
                end
                else if ((uart_inst_rx_inst_bitcnt == 8)) begin
                    uart_inst_rx_inst_state <= 2'b10;
                    uart_inst_rx_inst_bitcnt <= 0;
                end
            end
            2'b10: begin
                if (uart_inst_rx_inst_midbit) begin
                    uart_inst_rx_inst_state <= 2'b11;
                    uart_inst_rx_inst_fbusrx_write <= 1'b1;
                    uart_inst_rx_inst_fbusrx_write_data <= uart_inst_rx_inst_rxbyte;
                end
            end
            2'b11: begin
                uart_inst_rx_inst_state <= 2'b00;
                uart_inst_rx_inst_bitcnt <= 0;
            end
        endcase
    end
end


always @(posedge clock, negedge reset) begin: XULA2_UART_INST_TX_INST_RTLTX
    if (reset == 0) begin
        uart_inst_tx_inst_bitcnt <= 0;
        uart_inst_tx_inst_txbyte <= 0;
        uart_inst_tx_inst_state <= 3'b000;
        uart_inst_tx_inst_fbustx_read <= 0;
        uart_inst_tx <= 1;
    end
    else begin
        uart_inst_tx_inst_fbustx_read <= 1'b0;
        case (uart_inst_tx_inst_state)
            3'b000: begin
                if (((!uart_inst_tx_inst_fbustx_empty) && uart_inst_baudce)) begin
                    uart_inst_tx_inst_txbyte <= uart_inst_tx_inst_fbustx_read_data;
                    uart_inst_tx_inst_fbustx_read <= 1'b1;
                    uart_inst_tx_inst_state <= 3'b001;
                end
            end
            3'b001: begin
                if (uart_inst_baudce) begin
                    uart_inst_tx_inst_bitcnt <= 0;
                    uart_inst_tx <= 1'b0;
                    uart_inst_tx_inst_state <= 3'b010;
                end
            end
            3'b010: begin
                if (uart_inst_baudce) begin
                    uart_inst_tx_inst_bitcnt <= (uart_inst_tx_inst_bitcnt + 1);
                    uart_inst_tx <= uart_inst_tx_inst_txbyte[uart_inst_tx_inst_bitcnt];
                end
                else if ((uart_inst_tx_inst_bitcnt == 8)) begin
                    uart_inst_tx_inst_state <= 3'b011;
                    uart_inst_tx_inst_bitcnt <= 0;
                end
            end
            3'b011: begin
                if (uart_inst_baudce) begin
                    uart_inst_tx <= 1'b1;
                    uart_inst_tx_inst_state <= 3'b100;
                end
            end
            3'b100: begin
                if (uart_inst_baudce) begin
                    uart_inst_tx_inst_state <= 3'b000;
                end
            end
            default: begin
                if (1'b0 !== 1) begin
                    $display("*** AssertionError ***");
                end
            end
        endcase
    end
end


always @(posedge clock, negedge reset) begin: XULA2_UART_INST_FIFO_TX_INST_RTL_OCCUPANCY
    if (reset == 0) begin
        uart_inst_fifo_tx_inst_nvacant <= 4;
        uart_inst_fifo_tx_inst_ntenant <= 0;
    end
    else begin
        if (uart_inst_fifo_tx_inst_fbus_clear) begin
            uart_inst_fifo_tx_inst_nvacant <= 4;
            uart_inst_fifo_tx_inst_ntenant <= 0;
        end
        else if ((uart_inst_tx_inst_fbustx_read && (!uart_inst_fbustx_write))) begin
            uart_inst_fifo_tx_inst_nvacant <= (uart_inst_fifo_tx_inst_nvacant + 1);
            uart_inst_fifo_tx_inst_ntenant <= (uart_inst_fifo_tx_inst_ntenant - 1);
        end
        else if ((uart_inst_fbustx_write && (!uart_inst_tx_inst_fbustx_read))) begin
            uart_inst_fifo_tx_inst_nvacant <= (uart_inst_fifo_tx_inst_nvacant - 1);
            uart_inst_fifo_tx_inst_ntenant <= (uart_inst_fifo_tx_inst_ntenant + 1);
        end
    end
end



assign uart_inst_tx_inst_fbustx_read_data = uart_inst_fifo_tx_inst_mem[uart_inst_fifo_tx_inst_addr];



assign uart_inst_fifo_tx_inst_fbus_count = uart_inst_fifo_tx_inst_ntenant;



assign uart_inst_fifo_tx_inst_fbus_read_valid = (uart_inst_tx_inst_fbustx_read && (!uart_inst_tx_inst_fbustx_empty));


always @(posedge clock, negedge reset) begin: XULA2_UART_INST_FIFO_TX_INST_RTL_FIFO
    if (reset == 0) begin
        uart_inst_fbustx_full <= 0;
        uart_inst_tx_inst_fbustx_empty <= 1;
        uart_inst_fifo_tx_inst_addr <= 0;
    end
    else begin
        if (uart_inst_fifo_tx_inst_fbus_clear) begin
            uart_inst_fifo_tx_inst_addr <= 0;
            uart_inst_tx_inst_fbustx_empty <= 1'b1;
            uart_inst_fbustx_full <= 1'b0;
        end
        else if ((uart_inst_tx_inst_fbustx_read && (!uart_inst_fbustx_write))) begin
            uart_inst_fbustx_full <= 1'b0;
            if ((uart_inst_fifo_tx_inst_addr == 0)) begin
                uart_inst_tx_inst_fbustx_empty <= 1'b1;
            end
            else begin
                uart_inst_fifo_tx_inst_addr <= (uart_inst_fifo_tx_inst_addr - 1);
            end
        end
        else if ((uart_inst_fbustx_write && (!uart_inst_tx_inst_fbustx_read))) begin
            uart_inst_tx_inst_fbustx_empty <= 1'b0;
            if ((!uart_inst_tx_inst_fbustx_empty)) begin
                uart_inst_fifo_tx_inst_addr <= (uart_inst_fifo_tx_inst_addr + 1);
            end
            if (($signed({1'b0, uart_inst_fifo_tx_inst_addr}) == (4 - 2))) begin
                uart_inst_fbustx_full <= 1'b1;
            end
        end
    end
end


always @(posedge clock) begin: XULA2_UART_INST_FIFO_TX_INST_RTL_SRL_IN
    integer jj;
    if (uart_inst_fbustx_write) begin
        uart_inst_fifo_tx_inst_mem[0] <= uart_inst_fbustx_write_data;
        for (jj=1; jj<4; jj=jj+1) begin
            uart_inst_fifo_tx_inst_mem[jj] <= uart_inst_fifo_tx_inst_mem[(jj - 1)];
        end
    end
end

// Map external UART FIFOBus interface to internal
// Map the external UART FIFOBus interface attribute signals to
// internal RX FIFO interface.

assign uart_inst_fbusrx_read = cmd_inst_fifobus_read;
assign cmd_inst_fifobus_empty = uart_inst_fbusrx_empty;
assign cmd_inst_fifobus_read_data = uart_inst_fbusrx_read_data;
assign cmd_inst_fifobus_read_valid = uart_inst_fbusrx_read_valid;



assign bcm15_rxd = uart_inst_synctx_inst_staps[(3 - 1)];


always @(posedge clock) begin: XULA2_UART_INST_SYNCTX_INST_BEH_SYNC_STAGES
    integer ii;
    uart_inst_synctx_inst_staps[0] <= uart_inst_tx;
    for (ii=1; ii<3; ii=ii+1) begin
        uart_inst_synctx_inst_staps[ii] <= uart_inst_synctx_inst_staps[(ii - 1)];
    end
end


always @(posedge clock, negedge reset) begin: XULA2_UART_INST_FIFO_RX_INST_RTL_OCCUPANCY
    if (reset == 0) begin
        uart_inst_fifo_rx_inst_nvacant <= 4;
        uart_inst_fifo_rx_inst_ntenant <= 0;
    end
    else begin
        if (uart_inst_fifo_rx_inst_fbus_clear) begin
            uart_inst_fifo_rx_inst_nvacant <= 4;
            uart_inst_fifo_rx_inst_ntenant <= 0;
        end
        else if ((uart_inst_fbusrx_read && (!uart_inst_rx_inst_fbusrx_write))) begin
            uart_inst_fifo_rx_inst_nvacant <= (uart_inst_fifo_rx_inst_nvacant + 1);
            uart_inst_fifo_rx_inst_ntenant <= (uart_inst_fifo_rx_inst_ntenant - 1);
        end
        else if ((uart_inst_rx_inst_fbusrx_write && (!uart_inst_fbusrx_read))) begin
            uart_inst_fifo_rx_inst_nvacant <= (uart_inst_fifo_rx_inst_nvacant - 1);
            uart_inst_fifo_rx_inst_ntenant <= (uart_inst_fifo_rx_inst_ntenant + 1);
        end
    end
end



assign uart_inst_fbusrx_read_data = uart_inst_fifo_rx_inst_mem[uart_inst_fifo_rx_inst_addr];



assign uart_inst_fifo_rx_inst_fbus_count = uart_inst_fifo_rx_inst_ntenant;



assign uart_inst_fbusrx_read_valid = (uart_inst_fbusrx_read && (!uart_inst_fbusrx_empty));


always @(posedge clock, negedge reset) begin: XULA2_UART_INST_FIFO_RX_INST_RTL_FIFO
    if (reset == 0) begin
        uart_inst_fifo_rx_inst_fbus_full <= 0;
        uart_inst_fbusrx_empty <= 1;
        uart_inst_fifo_rx_inst_addr <= 0;
    end
    else begin
        if (uart_inst_fifo_rx_inst_fbus_clear) begin
            uart_inst_fifo_rx_inst_addr <= 0;
            uart_inst_fbusrx_empty <= 1'b1;
            uart_inst_fifo_rx_inst_fbus_full <= 1'b0;
        end
        else if ((uart_inst_fbusrx_read && (!uart_inst_rx_inst_fbusrx_write))) begin
            uart_inst_fifo_rx_inst_fbus_full <= 1'b0;
            if ((uart_inst_fifo_rx_inst_addr == 0)) begin
                uart_inst_fbusrx_empty <= 1'b1;
            end
            else begin
                uart_inst_fifo_rx_inst_addr <= (uart_inst_fifo_rx_inst_addr - 1);
            end
        end
        else if ((uart_inst_rx_inst_fbusrx_write && (!uart_inst_fbusrx_read))) begin
            uart_inst_fbusrx_empty <= 1'b0;
            if ((!uart_inst_fbusrx_empty)) begin
                uart_inst_fifo_rx_inst_addr <= (uart_inst_fifo_rx_inst_addr + 1);
            end
            if (($signed({1'b0, uart_inst_fifo_rx_inst_addr}) == (4 - 2))) begin
                uart_inst_fifo_rx_inst_fbus_full <= 1'b1;
            end
        end
    end
end


always @(posedge clock) begin: XULA2_UART_INST_FIFO_RX_INST_RTL_SRL_IN
    integer jj;
    if (uart_inst_rx_inst_fbusrx_write) begin
        uart_inst_fifo_rx_inst_mem[0] <= uart_inst_rx_inst_fbusrx_write_data;
        for (jj=1; jj<4; jj=jj+1) begin
            uart_inst_fifo_rx_inst_mem[jj] <= uart_inst_fifo_rx_inst_mem[(jj - 1)];
        end
    end
end

// Map external UART FIFOBus interface to internal
// Map external UART FIFOBus interface attribute signals to
// internal TX FIFO interface.

assign uart_inst_fbustx_write = (cmd_inst_fifobus_write & (!uart_inst_fbustx_full));
assign uart_inst_fbustx_write_data = cmd_inst_fifobus_write_data;
assign cmd_inst_fifobus_full = uart_inst_fbustx_full;


always @(cmd_inst_ready, cmd_inst_fifobus_empty) begin: XULA2_CMD_INST_BEH_FIFO_READ
    if ((cmd_inst_ready && (!cmd_inst_fifobus_empty))) begin
        cmd_inst_fifobus_read = 1'b1;
    end
    else begin
        cmd_inst_fifobus_read = 1'b0;
    end
end


always @(posedge clock, negedge reset) begin: XULA2_CMD_INST_MMC_INST_BEH_SM
    if (reset == 0) begin
        cmd_inst_mmc_inst_tocnt <= 0;
        cmd_inst_mmc_inst_state <= 3'b000;
    end
    else begin
        case (cmd_inst_mmc_inst_state)
            3'b000: begin
                if ((!memmap_done)) begin
                    cmd_inst_mmc_inst_state <= 3'b001;
                end
                else if (memmap_write) begin
                    cmd_inst_mmc_inst_state <= 3'b010;
                end
                else if (memmap_read) begin
                    cmd_inst_mmc_inst_state <= 3'b100;
                end
            end
            3'b001: begin
                if (memmap_done) begin
                    cmd_inst_mmc_inst_tocnt <= 0;
                    if (memmap_write) begin
                        cmd_inst_mmc_inst_state <= 3'b110;
                    end
                    else if (memmap_read) begin
                        cmd_inst_mmc_inst_state <= 3'b101;
                    end
                end
            end
            3'b010: begin
                cmd_inst_mmc_inst_state <= 3'b110;
                cmd_inst_mmc_inst_tocnt <= 0;
            end
            3'b100: begin
                cmd_inst_mmc_inst_state <= 3'b101;
            end
            3'b101: begin
                if (memmap_done) begin
                    cmd_inst_mmc_inst_state <= 3'b110;
                end
            end
            3'b110: begin
                if ((!(memmap_write || memmap_read))) begin
                    cmd_inst_mmc_inst_state <= 3'b000;
                end
            end
            default: begin
                if (1'b0 !== 1) begin
                    $display("*** AssertionError ***");
                end
            end
        endcase
    end
end


always @(posedge clock, negedge reset) begin: XULA2_CMD_INST_BEH_STATE_MACHINE
    integer ii;
    reg [8-1:0] bytecnt;
    integer val;
    integer idx;
    if (reset == 0) begin
        cmd_inst_fifobus_write <= 0;
        memmap_read <= 0;
        memmap_write <= 0;
        cmd_inst_bytemon <= 0;
        memmap_mem_addr <= 0;
        memmap_write_data <= 0;
        cmd_inst_packet[0] <= 0;
        cmd_inst_packet[1] <= 0;
        cmd_inst_packet[2] <= 0;
        cmd_inst_packet[3] <= 0;
        cmd_inst_packet[4] <= 0;
        cmd_inst_packet[5] <= 0;
        cmd_inst_packet[6] <= 0;
        cmd_inst_packet[7] <= 0;
        cmd_inst_packet[8] <= 0;
        cmd_inst_packet[9] <= 0;
        cmd_inst_packet[10] <= 0;
        cmd_inst_packet[11] <= 0;
        cmd_inst_state <= 4'b0000;
        cmd_inst_error <= 0;
        cmd_inst_ready <= 0;
        cmd_inst_fifobus_write_data <= 0;
        cmd_inst_bb_per_addr <= 0;
        bytecnt = 0;
    end
    else begin
        case (cmd_inst_state)
            4'b0000: begin
                cmd_inst_state <= 4'b0001;
                cmd_inst_ready <= 1'b1;
                bytecnt = 0;
            end
            4'b0001: begin
                if (cmd_inst_fifobus_read_valid) begin
                    for (ii=0; ii<2; ii=ii+1) begin
                        case (ii)
                            0: idx = 0;
                            default: idx = 7;
                        endcase
                        case (ii)
                            0: val = 222;
                            default: val = 202;
                        endcase
                        if (($signed({1'b0, bytecnt}) == idx)) begin
                            if (($signed({1'b0, cmd_inst_fifobus_read_data}) != val)) begin
                                cmd_inst_error <= 1'b1;
                                cmd_inst_state <= 4'b1001;
                            end
                        end
                    end
                    cmd_inst_packet[bytecnt] <= cmd_inst_fifobus_read_data;
                    bytecnt = (bytecnt + 1);
                end
                if ((bytecnt == 12)) begin
                    cmd_inst_ready <= 1'b0;
                    cmd_inst_state <= 4'b0010;
                end
            end
            4'b0010: begin
                cmd_inst_bb_per_addr <= cmd_inst_address[32-1:28];
                memmap_mem_addr <= cmd_inst_address[28-1:0];
                if (memmap_done !== 1) begin
                    $display("*** AssertionError ***");
                end
                bytecnt = 0;
                case (cmd_inst_packet[1])
                    'h1: begin
                        cmd_inst_state <= 4'b0101;
                    end
                    'h2: begin
                        memmap_write_data <= cmd_inst_data;
                        cmd_inst_state <= 4'b0011;
                    end
                    default: begin
                        cmd_inst_error <= 1'b1;
                        cmd_inst_state <= 4'b1001;
                    end
                endcase
            end
            4'b0011: begin
                if (memmap_done) begin
                    memmap_write <= 1'b1;
                    cmd_inst_state <= 4'b0100;
                end
            end
            4'b0100: begin
                memmap_write <= 1'b0;
                if (memmap_done) begin
                    cmd_inst_state <= 4'b0101;
                end
            end
            4'b0101: begin
                if (memmap_done) begin
                    memmap_read <= 1'b1;
                    cmd_inst_state <= 4'b0110;
                end
            end
            4'b0110: begin
                memmap_read <= 1'b0;
                if (memmap_done) begin
                    cmd_inst_packet[(8 + 0)] <= memmap_read_data[32-1:24];
                    cmd_inst_packet[(8 + 1)] <= memmap_read_data[24-1:16];
                    cmd_inst_packet[(8 + 2)] <= memmap_read_data[16-1:8];
                    cmd_inst_packet[(8 + 3)] <= memmap_read_data[8-1:0];
                    cmd_inst_state <= 4'b0111;
                end
            end
            4'b0111: begin
                cmd_inst_fifobus_write <= 1'b0;
                if ((bytecnt < 12)) begin
                    if ((!cmd_inst_fifobus_full)) begin
                        cmd_inst_fifobus_write <= 1'b1;
                        cmd_inst_fifobus_write_data <= cmd_inst_packet[bytecnt];
                        bytecnt = (bytecnt + 1);
                    end
                    cmd_inst_state <= 4'b1000;
                end
                else begin
                    cmd_inst_state <= 4'b1010;
                end
            end
            4'b1000: begin
                cmd_inst_fifobus_write <= 1'b0;
                cmd_inst_state <= 4'b0111;
            end
            4'b1001: begin
                if ((!cmd_inst_fifobus_read_valid)) begin
                    cmd_inst_state <= 4'b1010;
                    cmd_inst_ready <= 1'b0;
                end
            end
            4'b1010: begin
                cmd_inst_error <= 1'b0;
                cmd_inst_ready <= 1'b0;
                cmd_inst_state <= 4'b0000;
            end
            default: begin
                if (1'b0 !== 1) begin
                    $display("*** AssertionError ***");
                end
            end
        endcase
        cmd_inst_bytemon <= bytecnt;
    end
end


always @(posedge clock, negedge reset) begin: XULA2_BEH_LED_CONTROL
    if (reset == 0) begin
        memmap_done <= 1;
        ledreg <= 0;
    end
    else begin
        memmap_done <= (!(memmap_write || memmap_read));
        if ((memmap_write && (memmap_mem_addr == 32))) begin
            ledreg <= memmap_write_data;
        end
    end
end


always @(memmap_read, memmap_mem_addr, ledreg) begin: XULA2_BEH_LED_READ
    if ((memmap_read && (memmap_mem_addr == 32))) begin
        memmap_read_data = ledreg;
    end
    else begin
        memmap_read_data = 0;
    end
end


always @(posedge clock) begin: XULA2_BEH_ASSIGN
    if (glbl_tick_sec) begin
        tone <= ((~tone) & 1);
    end
    led <= (ledreg | tone[5-1:0]);
end

// For the first 4 clocks the reset is forced to lo
// for clock 6 to 31 the reset is set hi
// then the reset is lo
always @(posedge clock) begin: XULA2_RESET_TST
    if ((reset_dly_cnt < 31)) begin
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



assign a_wait = ((~a_astb) | (~a_dstb));


always @(posedge clock) begin: XULA2_RTL2
    a_astb_sr <= {a_astb_sr[2-1:0], a_astb};
    a_dstb_sr <= {a_dstb_sr[2-1:0], a_dstb};
end


always @(posedge clock) begin: XULA2_RTL3
    if (((~a_write) && (a_astb_sr == 4))) begin
        a_addr_reg <= fr_rpi2B;
    end
end


always @(posedge clock) begin: XULA2_RTL4
    if (((~a_write) && (a_dstb_sr == 4))) begin
        a_data_reg <= fr_rpi2B;
    end
end


always @(a_data_reg, a_write) begin: XULA2_RTL5
    if ((a_write == 1)) begin
        to_rpi2B = a_data_reg;
    end
end

endmodule
