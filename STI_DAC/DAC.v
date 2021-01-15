module DAC(
  input clk,
  input reset,
  input so_data,
  input so_valid,
  input final_valid,
  
  output oem_finish,
  output reg [4:0] oem_addr,
  output reg [7:0] oem_dataout,
  output reg odd1_wr,
  output reg even1_wr,
  output reg odd2_wr,
  output reg even2_wr,
  output reg odd3_wr,
  output reg even3_wr,
  output reg odd4_wr,
  output reg even4_wr,
  output reg [2:0] cnt_page
);
  reg [7:0] mem;
  reg flip;
  reg [2:0] cnt;
  
  reg [7:0] cnt_data;
  
  assign oem_finish = (cnt_page == 3'd4);
  
  always@(posedge clk)begin
    if(reset||(cnt_data == 8'd0))
      flip <= 1'b0;
    else if((cnt_data[2:0] == 3'b000) && (cnt == 3'd1))
      flip <= (!flip);
  end
  
  always@(posedge clk)begin
    if(reset||(cnt == 3'd7))
      cnt <= 3'd0;
    else if(so_valid||final_valid)
      cnt <= cnt + 1;      
  end
  
  always@(posedge clk)begin
    if(reset||(cnt_data == 8'd64))
      cnt_data <= 7'd0;
    else if((cnt == 3'd7)&&(so_valid||final_valid))
      cnt_data <= cnt_data + 1;
  end
  
  always@(posedge clk)begin
    if(reset)
      cnt_page <= 3'd0;
    else if(cnt_data == 8'd64)
      cnt_page <= cnt_page + 1;
  end
  
  always@(posedge clk)begin
    if(reset||final_valid)
      mem <= 8'd0;
    else if(so_valid)begin
      mem[0] <= so_data;
      mem[1] <= mem[0];
      mem[2] <= mem[1];
      mem[3] <= mem[2];
      mem[4] <= mem[3];
      mem[5] <= mem[4];
      mem[6] <= mem[5];
      mem[7] <= mem[6];
    end
  end
    
  always@*begin
    oem_dataout = mem[7:0];
  end

  always@*begin
    oem_addr = (cnt_data - 8'd1) >> 1;
  end
  
  always@*begin
    if(cnt == 3'd0)begin
      case(cnt_page)
        3'b000:begin
          odd1_wr = (flip)? (!cnt_data[0]) : cnt_data[0];
          even1_wr = (flip)? cnt_data[0] : (!cnt_data[0]);
          odd2_wr = 1'b0;
          even2_wr = 1'b0;
          odd3_wr = 1'b0;
          even3_wr = 1'b0;
          odd4_wr = 1'b0;
          even4_wr = 1'b0;
        end
        3'b001:begin
          odd1_wr = 1'b0;
          even1_wr = 1'b0;
          odd2_wr = (flip)? (!cnt_data[0]) : cnt_data[0];
          even2_wr = (flip)? cnt_data[0] : (!cnt_data[0]);
          odd3_wr = 1'b0;
          even3_wr = 1'b0;
          odd4_wr = 1'b0;
          even4_wr = 1'b0;
        end
        3'b010:begin
          odd1_wr = 1'b0;
          even1_wr = 1'b0;
          odd2_wr = 1'b0;
          even2_wr = 1'b0;
          odd3_wr = (flip)? (!cnt_data[0]) : cnt_data[0];
          even3_wr = (flip)? cnt_data[0] : (!cnt_data[0]);
          odd4_wr = 1'b0;
          even4_wr = 1'b0;
        end
        3'b011:begin
          odd1_wr = 1'b0;
          even1_wr = 1'b0;
          odd2_wr = 1'b0;
          even2_wr = 1'b0;
          odd3_wr = 1'b0;
          even3_wr = 1'b0;
          odd4_wr = (flip)? (!cnt_data[0]) : cnt_data[0];
          even4_wr = (flip)? cnt_data[0] : (!cnt_data[0]);
        end
        default:begin
          odd1_wr = 1'b0;
          even1_wr = 1'b0;
          odd2_wr = 1'b0;
          even2_wr = 1'b0;
          odd3_wr = 1'b0;
          even3_wr = 1'b0;
          odd4_wr = 1'b0;
          even4_wr = 1'b0;
        end      
      endcase
    end
    else begin
      odd1_wr = 1'b0;
      even1_wr = 1'b0;
      odd2_wr = 1'b0;
      even2_wr = 1'b0;
      odd3_wr = 1'b0;
      even3_wr = 1'b0;
      odd4_wr = 1'b0;
      even4_wr = 1'b0;
    end
  end

endmodule