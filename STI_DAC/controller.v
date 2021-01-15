module controller(
  input clk,
  input reset,
  input load,
  input [5:0] out_bit,
  input [2:0] cnt_page,
  
  output reg so_valid,
  output reg final_valid // validation of final condition 
);
  reg [5:0] cnt_out;
  reg [1:0] cnt_load;
  reg [1:0] cstate, nstate;
  parameter LOAD = 2'b00, WAIT = 2'b01, OUT = 2'b10, FINAL = 2'b11;

  always@(posedge clk)begin
    if(reset)
      cstate <= LOAD;
    else
      cstate <= nstate;
  end
  
  always@(posedge clk)begin
    if(reset||(cstate == LOAD))
      cnt_out <= 6'b0;
    else if(cstate == OUT)
      cnt_out <= cnt_out + 1;
  end
  
  always@(posedge clk)begin // used for the last data then go to the final condition
    if(reset||load)
      cnt_load <= 2'b0;
    else if(cstate != OUT)
      cnt_load <= cnt_load + 1;
  end
  
  always@*begin
    case(cstate)
      LOAD:begin
        if(load)
          nstate = WAIT;  
        else if(cnt_load > 2'd1)
          nstate = FINAL;
        else
          nstate = LOAD;
        end
      WAIT:nstate = OUT;     
      OUT:begin
        if(cnt_out == (out_bit - 6'd1))
          nstate = LOAD;
        else
          nstate = OUT;
      end
      FINAL:nstate = FINAL;
      default:nstate = LOAD;
    endcase  
  end
  
  always@*begin
    case(cstate)
      LOAD:begin 
        so_valid = 1'b0;      
        final_valid = 1'b0;
      end
      WAIT:begin 
        so_valid = 1'b0;
        final_valid = 1'b0;
      end
      OUT:begin
        so_valid = 1'b1;      
        final_valid = 1'b0;
      end
      FINAL:begin
        so_valid = 1'b0;
        final_valid = 1'b1;
      end
      default:begin
        so_valid = 1'b0;     
        final_valid = 1'b0;
      end
    endcase
  end
endmodule