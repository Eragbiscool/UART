module uart_tx (
    clk             ,
    data_frame_in   ,
    data_tx         ,
    new_data
);
    input                        clk ;
    input [7:0]        data_frame_in ;
    output  reg              data_tx ;
    output  reg             new_data ;



parameter IDLE      = 1 ;
parameter DATA_TX   = 2 ;
parameter CRC       = 3 ;
parameter STOP      = 4 ;



reg [2:0]         state;
reg [2:0]       counter; 



wire start_bit          ;
wire [4:0] data_bits    ;
wire parity_bits        ;
wire stop_bits          ;




assign start_bit    = data_frame_in[7]     ;
assign parity_bits  = data_frame_in[1]     ;
assign stop_bits    = data_frame_in[0]     ;


always @(posedge clk) begin
    case(state)
        IDLE    :   begin

            new_data = 1'b0 ;
            
            if(~data_frame_in[7]) begin
                   state   = DATA_TX                ;
                   counter = counter - 3'b001        ;
                   data_tx = data_frame_in[7]        ;
            end
            else begin             
                state       = IDLE                  ;
                counter     = counter                ;
                data_tx     = data_tx                ;
            end                
        end

        DATA_TX :   begin
            
            new_data = 1'b0 ;

            if(counter > 3'b001)
            begin
                data_tx  = data_frame_in[counter]    ;
                counter  = counter - 3'b001          ;
                state    = DATA_TX                  ;
                
            end
            else 
            begin
                
                state    = CRC                       ;
                data_tx  = data_frame_in[counter]    ;
                counter  = counter-3'b001            ;
            end
        end

        CRC     : begin
            
            state   = STOP                   ; 
            data_tx = data_frame_in[counter]  ;
            counter = counter-3'b001          ;
            new_data = 1'b0                  ;
        end

        STOP    : begin

            new_data = 1'b1 ;
            
            if(data_frame_in[0]) begin 
                counter = 3'b111                   ;
                state   = IDLE                    ;
                data_tx = data_frame_in[counter]   ;
            end
            else begin
                state   = STOP              ;
                counter = counter            ;
                data_tx  = data_tx           ;
                
            end
        end
    default : begin 
        state    = IDLE                     ;
        counter  = 3'b111                    ;
        data_tx  = data_tx                   ;
        new_data = 1'b1                     ;   
    end
    endcase




    

end



endmodule