`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/13/2023 10:03:28 PM
// Design Name: 
// Module Name: example_design
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

 
module example_design #()(
  input wire         clk,
  input wire         resetn,
  // Ports of Axi Slave Bus Interface axis_slv
  
  output wire        axis_slv_tready,
  input  wire [7:0]  axis_slv_tdata,
  input  wire        axis_slv_tlast,
  input  wire        axis_slv_tvalid,
  
  // Ports of Axi Master Bus Interface axis_mst0
  output wire        axis_mst0_tvalid,
  output wire [7:0]  axis_mst0_tdata,
  output wire        axis_mst0_tlast,
  input  wire        axis_mst0_tready,
  
  // Ports of Axi Master Bus Interface axis_mst1
  output wire        axis_mst1_tvalid,
  output wire [15:0] axis_mst1_tdata,
  output wire        axis_mst1_tlast,
  input  wire        axis_mst1_tready,
		
  input  [31:0]      aximm_slv_awaddr,
  input              aximm_slv_awvalid,
  output             aximm_slv_awready,
  
  input  [31:0]      aximm_slv_wdata,
  input              aximm_slv_wvalid,
  output             aximm_slv_wready,
  
  output [1:0]       aximm_slv_bresp,
  output             aximm_slv_bvalid,
  input              aximm_slv_bready,
  
  input  [31:0]      aximm_slv_araddr,
  input              aximm_slv_arvalid,
  output             aximm_slv_arready,
  
  output [31:0]      aximm_slv_rdata,
  output             aximm_slv_rvalid,
  input              aximm_slv_rready
);
 
  // APB interface
  wire [11:0] paddr;
  wire        psel;
  wire        penable;
  wire        pwrite;
  wire [31:0] pwdata;
  wire [2:0]  pprot;
  wire [3:0]  pstrb;
  reg         pready;
  reg  [31:0] prdata;
  reg         pslverr;
  // memory-mapped registers
  reg  [31:0] shift_left;
  reg  [31:0] shift_right;
  reg  [31:0] rcv_cnt;
  reg  [31:0] snd_cnt;
  
  axi_apb_bridge_0 axi_apb_bridge_0(
    .s_axi_aclk (clk),
    .s_axi_aresetn (resetn),
    .s_axi_awaddr (aximm_slv_awaddr),
    .s_axi_awvalid (aximm_slv_awvalid),
    .s_axi_awready (aximm_slv_awready),
    .s_axi_wdata (aximm_slv_wdata),
    .s_axi_wvalid (aximm_slv_wvalid),
    .s_axi_wready (aximm_slv_wready),
    .s_axi_bresp (aximm_slv_bresp),
    .s_axi_bvalid (aximm_slv_bvalid),
    .s_axi_bready (aximm_slv_bready),
    .s_axi_araddr (aximm_slv_araddr),
    .s_axi_arvalid (aximm_slv_arvalid),
    .s_axi_arready (aximm_slv_arready),
    .s_axi_rdata (aximm_slv_rdata),
    .s_axi_rresp (aximm_slv_rresp),
    .s_axi_rvalid (aximm_slv_rvalid),
    .s_axi_rready (aximm_slv_rready),
    .m_apb_paddr (paddr),
    .m_apb_psel (psel),
    .m_apb_penable (penable),
    .m_apb_pwrite (pwrite),
    .m_apb_pwdata (pwdata),
    .m_apb_pready (pready),
    .m_apb_prdata (prdata),
    .m_apb_pslverr (pslverr)
  );
  
  always @(posedge clk)
    if (!resetn) begin
        shift_left  <= 32'd1;
        shift_right <= 32'd1;
        rcv_cnt     <= 32'h0;
        snd_cnt     <= 32'h0;
        pready      <= 1'b1;
        pslverr     <= 1'b0;
        prdata      <= 32'h0;
  end else begin
    pready      <= 1'b1;
    pslverr     <= 1'b0;
    prdata      <= 32'd0;
    rcv_cnt     <= rcv_cnt + (axis_slv_tready & axis_slv_tvalid);
    snd_cnt     <= snd_cnt + (axis_slv_tready & axis_slv_tvalid);
    if (psel & ~penable)
      case (paddr[11:0])
         12'h0:
           if (pwrite) shift_left  <= pwdata;
           else        prdata <= shift_left;
         12'h4:
           if (pwrite) shift_right  <= pwdata;
           else        prdata <= shift_right;
         12'h8:
           if (pwrite) pslverr <= 1'b1;
           else        prdata <= rcv_cnt;
         12'hc:
           if (pwrite) snd_cnt <= 0;
           else        prdata <= snd_cnt;
         default:   
           pslverr <= 1'b1;
       endcase
  end
  
  assign axis_mst0_tvalid = axis_mst1_tready & axis_slv_tvalid;
  assign axis_mst0_tdata  = (axis_slv_tdata>>shift_right);
  assign axis_mst0_tlast  = axis_slv_tlast;
  
  assign axis_mst1_tvalid = axis_mst0_tready & axis_slv_tvalid;
  assign axis_mst1_tdata  = ({axis_slv_tdata<<shift_left, axis_slv_tdata<<shift_left});
  assign axis_mst1_tlast  = axis_slv_tlast;
  
  assign axis_slv_tready  = axis_mst0_tready & axis_mst1_tready;

endmodule
