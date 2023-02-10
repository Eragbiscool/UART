`include "../UART_design/UART_top.v";
module UART_tb ();


logic clk;
logic [7:0] data_in;
logic [7:0] data_out;
logic tx_wire_1_to_2;

uart uart_inst_1(
    .clk(clk),
    .data_frame_in(data_in),
    .tx(tx_wire_1_to_2),
    .rx(),
    .data_frame_out()
);


uart uart_inst_2(
    .clk(clk),
    .data_frame_out(data_out),
    .rx(tx_wire_1_to_2),
    .tx(),
    .data_frame_in()
);


initial begin
    clk = 0;


    repeat (1) @(posedge clk);

    data_in = 8'b00110111;

    repeat (20) @(posedge clk);

    data_in = 8'b01001001;

    repeat (20) @(posedge clk);

    $finish;

end

initial forever begin
    #5 clk =~ clk;
end


endmodule