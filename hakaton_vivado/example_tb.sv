`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/02/2023 10:36:00 PM
// Design Name: 
// Module Name: example_tb
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


module example_tb();
  reg         clk;
  reg         resetn;
// Ports of Axi Slave Bus Interface axis_slv

  reg        axis_slv_tready;
  reg [7:0]  axis_slv_tdata;
  reg        axis_slv_tlast;
  reg        axis_slv_tvalid;

// Ports of Axi Master Bus Interface axis_mst0
  reg        axis_mst0_tvalid;
  reg [7:0]  axis_mst0_tdata;
  reg        axis_mst0_tlast;
  reg        axis_mst0_tready;

// Ports of Axi Master Bus Interface axis_mst1
  reg        axis_mst1_tvalid;
  reg [15:0] axis_mst1_tdata;
  reg        axis_mst1_tlast;
  reg        axis_mst1_tready;
  
  reg [31:0]      aximm_slv_awaddr;
  reg aximm_slv_awvalid;
  reg aximm_slv_awready;

  reg [31:0]      aximm_slv_wdata;
  reg aximm_slv_wvalid;
  reg aximm_slv_wready;

  reg [1:0]       aximm_slv_bresp;
  reg aximm_slv_bvalid;
  reg aximm_slv_bready;

  reg  [31:0]      aximm_slv_araddr;
  reg aximm_slv_arvalid;
  reg aximm_slv_arready;

  reg [31:0]      aximm_slv_rdata;
  reg aximm_slv_rvalid;
  reg aximm_slv_rready;
    
  initial begin
    clk = 0;
    resetn = 0;
    axis_slv_tvalid = 0;
    aximm_slv_awvalid = 0;
    aximm_slv_wvalid = 0;
    aximm_slv_bready = 1;
    aximm_slv_arvalid = 0;
    aximm_slv_rready = 1;
    repeat (10) @(posedge clk);
    resetn <= 1;
    repeat (5) @(posedge clk);
    axis_slv_tlast <= 0;
    axis_slv_tvalid <= 1;
    repeat (10) begin
      axis_slv_tdata <= $random;
      @(posedge clk);
      while (!axis_slv_tready) @(posedge clk);
    end
    axis_slv_tlast <= 1;
    axis_slv_tdata <= $random;
    @(posedge clk);
    while (!axis_slv_tready) @(posedge clk);
    axis_slv_tvalid <= 0;
    repeat (1000) @(posedge clk);
    $finish;
  end

  always @(posedge clk)
  begin
    axis_mst0_tready <= $random;
    axis_mst1_tready <= $random;
  end
    
  initial begin
    repeat (20) @(posedge clk);
    aximm_slv_araddr <= 32'h6000_0004;
    aximm_slv_arvalid <= 1;
    @(posedge clk);
    while (!aximm_slv_arready) @(posedge clk);
    aximm_slv_arvalid <= 0;
    @(posedge clk);
    aximm_slv_awaddr <= 'h6000_0004;
    aximm_slv_awvalid <= 1;
    @(posedge clk);
    while (!aximm_slv_awready) @(posedge clk);
    aximm_slv_awvalid <= 0;
    aximm_slv_wvalid <= 1;
    aximm_slv_wdata <= $random;
    @(posedge clk);
    while (!aximm_slv_wready) @(posedge clk);
    aximm_slv_wvalid <= 0;
    @(posedge clk);
    while (!aximm_slv_bvalid) @(posedge clk);
    aximm_slv_araddr <= 32'h6000_000c;
    aximm_slv_arvalid <= 1;
    @(posedge clk);
    while (!aximm_slv_arready) @(posedge clk);
    aximm_slv_arvalid <= 0;
    @(posedge clk);
    aximm_slv_araddr <= 32'h6000_0004;
    aximm_slv_arvalid <= 1;
    @(posedge clk);
    while (!aximm_slv_arready) @(posedge clk);
    aximm_slv_arvalid <= 0;
  end
    
  always clk = #5ns ~clk;

  example_design #() example_design (
    .clk(clk),
    .resetn(resetn),
    // Ports of Axi Slave Bus Interface axis_slv

    .axis_slv_tready(axis_slv_tready),
    .axis_slv_tdata(axis_slv_tdata),
    .axis_slv_tlast(axis_slv_tlast),
    .axis_slv_tvalid(axis_slv_tvalid),

    // Ports of Axi Master Bus Interface axis_mst0
    .axis_mst0_tvalid(axis_mst0_tvalid),
    .axis_mst0_tdata(axis_mst0_tdata),
    .axis_mst0_tlast(axis_mst0_tlast),
    .axis_mst0_tready(axis_mst0_tready),

    // Ports of Axi Master Bus Interface axis_mst1
    .axis_mst1_tvalid(axis_mst1_tvalid),
    .axis_mst1_tdata(axis_mst1_tdata),
    .axis_mst1_tlast(axis_mst1_tlast),
    .axis_mst1_tready(axis_mst1_tready),
  
    .aximm_slv_awaddr(aximm_slv_awaddr),
    .aximm_slv_awvalid(aximm_slv_awvalid),
    .aximm_slv_awready(aximm_slv_awready),

    .aximm_slv_wdata(aximm_slv_wdata),
    .aximm_slv_wvalid(aximm_slv_wvalid),
    .aximm_slv_wready(aximm_slv_wready),

    .aximm_slv_bresp(aximm_slv_bresp),
    .aximm_slv_bvalid(aximm_slv_bvalid),
    .aximm_slv_bready(aximm_slv_bready),

    .aximm_slv_araddr(aximm_slv_araddr),
    .aximm_slv_arvalid(aximm_slv_arvalid),
    .aximm_slv_arready(aximm_slv_arready),

    .aximm_slv_rdata(aximm_slv_rdata),
    .aximm_slv_rvalid(aximm_slv_rvalid),
    .aximm_slv_rready(aximm_slv_rready)
);

endmodule
