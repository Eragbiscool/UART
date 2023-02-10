module uart_rx (
    clk            ,    
    data_rx        ,
    data_frame_out
);


input                       clk ;
input                   data_rx ;
output reg [7:0] data_frame_out ; 



parameter IDLE      = 1 ;
parameter DATA_RX   = 2 ;
parameter CRC       = 3 ;
parameter STOP      = 4 ;



reg [2:0]           state ;
reg [2:0]         counter ;
reg [7:0]     storage_reg ; 
reg                parity ;






always @(posedge clk) begin
    case(state)
        IDLE    :   begin
            if(~data_rx) begin
                storage_reg  = {data_rx,7'b1111111} ;
                counter      = counter - 3'b001     ;
                state        = DATA_RX ;
            end   
            else begin
                storage_reg  = 8'b11111111;
                state        = IDLE;
                counter      = 3'b111;
                parity       = 1'b1;
            end              
            
            
            
        end

        DATA_RX :   begin
            if(counter>3'b001)
            begin
                storage_reg[counter]  =     data_rx ;
                counter               =     counter - 3'b001 ; 
                parity                =     data_rx ^ parity ;
            end
            else 
            begin
                storage_reg[counter]  =     data_rx ;
                parity                =     data_rx ^ parity ;
                counter               =     counter - 3'b001 ; 
                state                 =     CRC              ;  
            end
        end

        CRC     : begin
            storage_reg[counter]  = data_rx  ;

            if(~(parity ^ data_rx)) begin
                state    = STOP ;
                counter  = counter - 3'b001  ;
            end
            else begin
                counter  = 3'b111 ;
                state    = IDLE   ;
            end
            
        end

        STOP    : begin
            storage_reg[counter]  = data_rx          ;
            data_frame_out        = storage_reg[7:0] ;
            counter               = 3'b111           ;
            state                 = IDLE             ; 
        end
        default : begin 
            state                 = IDLE             ;
            counter               = 3'b111           ;

        end
    endcase
end




endmodule


    