`timescale 1ns / 1ns
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
   wire [(bit_width*depth)-1:0] mac_wt_in0, mac_wt_in1, mac_wt_in2, mac_wt_in3;
   wire [(bit_width*depth)-1:0] mac_wt_out0, mac_wt_out1, mac_wt_out2, mac_wt_out3;
   wire [(bit_width*depth)-1:0] mac_data_in0, mac_data_in1, mac_data_in2, mac_data_in3;
   wire [(bit_width*depth)-1:0] mac_data_out0, mac_data_out1, mac_data_out2, mac_data_out3;
   
   wire [acc_width*size-1:0] mac_acc_in0, mac_acc_in1, mac_acc_in2, mac_acc_in3;
   wire [acc_width*size-1:0] mac_acc_out0, mac_acc_out1, mac_acc_out2, mac_acc_out3;
   
   
   assign mac_acc_in0 = 'h0;
   assign mac_acc_in1 = mac_acc_out0;
   assign mac_acc_in2 = mac_acc_out1;
   assign mac_acc_in3 = mac_acc_out2;
   
   assign mac_data_in0 = control ? 'h0 : data_arr; // pass the data when control bit is not set
   assign mac_data_in1 = mac_data_out0;
   assign mac_data_in2 = mac_data_out1;
   assign mac_data_in3 = mac_data_out2;
   
   // need to shift weights only when control bit is set
   assign mac_wt_in0 = control ? wt_arr : 'h0;
   assign mac_wt_in1 = control ? mac_wt_out0 : 'h0;
   assign mac_wt_in2 = control ? mac_wt_out1 : 'h0;
   assign mac_wt_in3 = control ? mac_wt_out2 : 'h0;
   

   MAC u_MAC11 (
      .clk         (clk),
      .control     (control),
      .data_in     (mac_data_in0[7:0]),
      .wt_path_in  (mac_wt_in0[7:0]),
      .acc_in      (mac_acc_in0[acc_width-1:0]),
      .data_out    (mac_data_out0[7:0]),
      .wt_path_out (mac_wt_out0[7:0]),
      .acc_out     (mac_acc_out0[acc_width-1:0])
   );
   MAC u_MAC12 (
      .clk         (clk),
      .control     (control),
      .data_in     (mac_data_in0[15:8]),
      .wt_path_in  (mac_wt_in1[7:0]),
      .acc_in      (mac_acc_in1[acc_width-1:0]),
      .data_out    (mac_data_out0[15:8]),
      .wt_path_out (mac_wt_out1[7:0]),
      .acc_out     (mac_acc_out1[acc_width-1:0])
   );
   MAC u_MAC13 (
      .clk         (clk),
      .control     (control),
      .data_in     (mac_data_in0[23:16]),
      .wt_path_in  (mac_wt_in2[7:0]),
      .acc_in      (mac_acc_in2[acc_width-1:0]),
      .data_out    (mac_data_out0[23:16]),
      .wt_path_out (mac_wt_out2[7:0]),
      .acc_out     (mac_acc_out2[acc_width-1:0])
   );
   MAC u_MAC14 (
      .clk         (clk),
      .control     (control),
      .data_in     (mac_data_in0[31:24]),
      .wt_path_in  (mac_wt_in3[7:0]),
      .acc_in      (mac_acc_in3[acc_width-1:0]),
      .data_out    (mac_data_out0[31:24]),
      .wt_path_out (mac_wt_out3[7:0]),
      .acc_out     (mac_acc_out3[acc_width-1:0])
   );

   MAC u_MAC21 (
      .clk         (clk),
      .control     (control),
      .data_in     (mac_data_in1[7:0]),
      .wt_path_in  (mac_wt_in0[15:8]),
      .acc_in      (mac_acc_in0[2*acc_width-1:acc_width]),
      .data_out    (mac_data_out1[7:0]),
      .wt_path_out (mac_wt_out0[15:8]),
      .acc_out     (mac_acc_out0[2*acc_width-1:acc_width])
   );
   MAC u_MAC22 (
      .clk         (clk),
      .control     (control),
      .data_in     (mac_data_in1[15:8]),
      .wt_path_in  (mac_wt_in1[15:8]),
      .acc_in      (mac_acc_in1[2*acc_width-1:acc_width]),
      .data_out    (mac_data_out1[15:8]),
      .wt_path_out (mac_wt_out1[15:8]),
      .acc_out     (mac_acc_out1[2*acc_width-1:acc_width])
   );
   MAC u_MAC23 (
      .clk         (clk),
      .control     (control),
      .data_in     (mac_data_in1[23:16]),
      .wt_path_in  (mac_wt_in2[15:8]),
      .acc_in      (mac_acc_in2[2*acc_width-1:acc_width]),
      .data_out    (mac_data_out1[23:16]),
      .wt_path_out (mac_wt_out2[15:8]),
      .acc_out     (mac_acc_out2[2*acc_width-1:acc_width])
   );
   MAC u_MAC24 (
      .clk         (clk),
      .control     (control),
      .data_in     (mac_data_in1[31:24]),
      .wt_path_in  (mac_wt_in3[15:8]),
      .acc_in      (mac_acc_in3[2*acc_width-1:acc_width]),
      .data_out    (mac_data_out1[31:24]),
      .wt_path_out (mac_wt_out3[15:8]),
      .acc_out     (mac_acc_out3[2*acc_width-1:acc_width])
   );

   MAC u_MAC31 (
      .clk         (clk),
      .control     (control),
      .data_in     (mac_data_in2[7:0]),
      .wt_path_in  (mac_wt_in0[23:16]),
      .acc_in      (mac_acc_in0[3*acc_width-1:2*acc_width]),
      .data_out    (mac_data_out2[7:0]),
      .wt_path_out (mac_wt_out0[23:16]),
      .acc_out     (mac_acc_out0[3*acc_width-1:2*acc_width])
   );
   MAC u_MAC32 (
      .clk         (clk),
      .control     (control),
      .data_in     (mac_data_in2[15:8]),
      .wt_path_in  (mac_wt_in1[23:16]),
      .acc_in      (mac_acc_in1[3*acc_width-1:2*acc_width]),
      .data_out    (mac_data_out2[15:8]),
      .wt_path_out (mac_wt_out1[23:16]),
      .acc_out     (mac_acc_out1[3*acc_width-1:2*acc_width])
   );
   MAC u_MAC33 (
      .clk         (clk),
      .control     (control),
      .data_in     (mac_data_in2[23:16]),
      .wt_path_in  (mac_wt_in2[23:16]),
      .acc_in      (mac_acc_in2[3*acc_width-1:2*acc_width]),
      .data_out    (mac_data_out2[23:16]),
      .wt_path_out (mac_wt_out2[23:16]),
      .acc_out     (mac_acc_out2[3*acc_width-1:2*acc_width])
   );
   MAC u_MAC34 (
      .clk         (clk),
      .control     (control),
      .data_in     (mac_data_in2[31:24]),
      .wt_path_in  (mac_wt_in3[23:16]),
      .acc_in      (mac_acc_in3[3*acc_width-1:2*acc_width]),
      .data_out    (mac_data_out2[31:24]),
      .wt_path_out (mac_wt_out3[23:16]),
      .acc_out     (mac_acc_out3[3*acc_width-1:2*acc_width])
   );

   MAC u_MAC41 (
      .clk         (clk),
      .control     (control),
      .data_in     (mac_data_in3[7:0]),
      .wt_path_in  (mac_wt_in0[31:24]),
      .acc_in      (mac_acc_in0[4*acc_width-1:3*acc_width]),
      .data_out    (mac_data_out3[7:0]),
      .wt_path_out (mac_wt_out0[31:24]),
      .acc_out     (mac_acc_out0[4*acc_width-1:3*acc_width])
   );
   MAC u_MAC42 (
      .clk         (clk),
      .control     (control),
      .data_in     (mac_data_in3[15:8]),
      .wt_path_in  (mac_wt_in1[31:24]),
      .acc_in      (mac_acc_in1[4*acc_width-1:3*acc_width]),
      .data_out    (mac_data_out3[15:8]),
      .wt_path_out (mac_wt_out1[31:24]),
      .acc_out     (mac_acc_out1[4*acc_width-1:3*acc_width])
   );
   MAC u_MAC43 (
      .clk         (clk),
      .control     (control),
      .data_in     (mac_data_in3[23:16]),
      .wt_path_in  (mac_wt_in2[31:24]),
      .acc_in      (mac_acc_in2[4*acc_width-1:3*acc_width]),
      .data_out    (mac_data_out3[23:16]),
      .wt_path_out (mac_wt_out2[31:24]),
      .acc_out     (mac_acc_out2[4*acc_width-1:3*acc_width])
   );
   MAC u_MAC44 (
      .clk         (clk),
      .control     (control),
      .data_in     (mac_data_in3[31:24]),
      .wt_path_in  (mac_wt_in3[31:24]),
      .acc_in      (mac_acc_in3[4*acc_width-1:3*acc_width]),
      .data_out    (mac_data_out3[31:24]),
      .wt_path_out (mac_wt_out3[31:24]),
      .acc_out     (mac_acc_out3[4*acc_width-1:3*acc_width])
   );

   always@(posedge clk) begin
      acc_out <= mac_acc_out3;
   end

endmodule
