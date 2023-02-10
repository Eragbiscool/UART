`include "UART_tx.v";
`include "UART_rx.v";
module uart (
    clk             ,
    data_frame_in   ,
    data_frame_out  ,
    tx              ,
    rx
);

input         clk             ;
input [7:0]   data_frame_in   ;
input         rx              ;
output [7:0]  data_frame_out  ;
output        tx              ;


wire from_tx_to_top_new_data_wire;



reg [7:0] data_frame_main_in;

always @(from_tx_to_top_new_data_wire) begin
    data_frame_main_in = data_frame_in;
end


uart_tx uart_tx_inst_1(
    .clk (clk),
    .data_frame_in (data_frame_main_in),
    .data_tx(tx),
    .new_data(from_tx_to_top_new_data_wire)

);

uart_rx uart_rx_inst_1(
    .clk(clk),
    .data_frame_out(data_frame_out),
    .data_rx(rx)
);


endmodule