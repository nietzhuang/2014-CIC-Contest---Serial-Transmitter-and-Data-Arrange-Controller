module STI(
  input clk,
  input reset,
  input load,
  input pi_fill,
  input pi_msb,
  input pi_low,
  input [1:0] pi_length,
  input [15:0] pi_data,
  input so_valid,

  output reg so_data,
  output reg [5:0] out_bit
);
  reg [31:0] mem;
  reg [5:0] cnt;

  always@(posedge clk)begin // count to (out_bit+1)
    if(reset||load)
      cnt <= 6'd0;
    else if(so_valid)
      cnt <= cnt + 1;
  end
  
  always@(posedge clk)begin // data arrangement
    if(reset||load)
      mem <= 32'd0;
    else begin
      case(pi_length)
        2'b00:begin
          if(pi_low)
            mem[7:0] <= pi_data[15:8];
          else
            mem[7:0] <= pi_data[7:0];
        end
        2'b01:mem[15:0] <= pi_data[15:0];
        2'b10:begin
          if(pi_fill)
            mem[23:8] <= pi_data[15:0];
          else
            mem[15:0] <= pi_data[15:0];
        end
        2'b11:begin
          if(pi_fill)
            mem[31:16] <= pi_data[15:0];
          else
            mem[15:0] <= pi_data[15:0];
        end
        default:mem[31:0] <= 32'd0;
      endcase
    end
  end
  
  always@*begin
    if(pi_msb)
      so_data = mem[(out_bit-1)-cnt];
    else
      so_data = mem[cnt];
  end
  
  always@*begin
    case(pi_length)
      2'b00:out_bit = 6'd8; 
      2'b01:out_bit = 6'd16;
      2'b10:out_bit = 6'd24;
      2'b11:out_bit = 6'd32;
      default:out_bit = 6'd0;
    endcase
  end

endmodule