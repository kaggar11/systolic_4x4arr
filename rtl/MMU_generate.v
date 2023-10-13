`timescale 1ns / 1ps
// Systolic Array top level module. 

module MMU#(parameter depth=4, bit_width=8, acc_width=32, size=4)
(
   clk,
   control,
   data_arr,
   wt_arr,
   acc_out
);
   input clk;
   input control; 
   input [(bit_width*depth)-1:0] data_arr;
   input [(bit_width*depth)-1:0] wt_arr;
   output reg [acc_width*size-1:0] acc_out;
   
   
   // Implement your logic below based on the MAC unit design in MAC.v
   integer irow, icol;
   genvar row, col;
   
   reg [(bit_width*depth)-1:0] next_row_wt [0:depth-1];
   reg [(bit_width*depth)-1:0] mac_data_in [0:depth-1];
   reg [(bit_width*depth)-1:0] mac_data_out [0:depth-1];
   
   wire [acc_width*size-1:0] mac_acc_in [0:depth-1];
   wire [acc_width*size-1:0] mac_acc_out [0:depth-1];
   
   assign mac_data_in[0] = control ? 'h0 : data_arr;
   assign next_row_wt[0] = control ? wt_arr : 'h0;
   
   always@(posedge clk) begin
      // row wise shift for next cycle of weights and output activations
      mac_acc_in[1] <= mac_acc_out[0];
      next_row_wt[1] <= next_row_wt[0];
      for (irow=1; irow<depth-1; irow=irow+1) begin
         mac_acc_in[irow+1] <= mac_acc_out[irow];
         // need to shift weights only when control bit is set
         if (control)
            next_row_wt[irow+1] <= next_row_wt[irow];
      end
      // column wise shift for next cycle of input activations
      for (icol=0; icol<depth-1; icol=icol+1) begin
         mac_data_in[icol+1] <= mac_data_out[icol];
      end
   end
   
   
   generate
      for (row=0; row<depth; row=row+1) begin
         for (col=0; col<depth; col=col+1) begin
            MAC u_MAC (
               .clk         (clk),
               .control     (control),
               .data_in     (mac_data_in[8*row+8-1:8*row][col]),
               .wt_path_in  (next_row_wt[8*col+8-1:8*col][row]),
               .acc_in      (mac_acc_in[8*col+8-1:8*col][row]),
               .data_out    (mac_data_out[8*row+8-1:8*row][col]),
               .wt_path_out (next_row_wt[8*col+8-1:8*col][row]),
               .acc_out     (mac_acc_out[8*col+8-1:8*col][row])
            );
         end
      end
   endgenerate

   always@(posedge clk) begin
      acc_out <= mac_acc_out[3];
   end

endmodule
