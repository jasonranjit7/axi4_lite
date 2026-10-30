module sva_module#(parameter ADDR_WIDTH = 32, DATA_WIDTH=32)
  (
    input logic ACLK,
    input logic ARESETN,
    input  logic [ADDR_WIDTH-1:0] AWADDR,
    input  logic AWVALID,
    input logic AWREADY,

    // Write data channel
    input  logic [DATA_WIDTH-1:0] WDATA,
    input  logic [DATA_WIDTH/8-1:0] WSTRB,
    input  logic WVALID,
    input logic WREADY,

    // Write response channel
    input logic [1:0] BRESP,
    input logic BVALID,
    input  logic BREADY,

    // Read address channel
    input  logic [ADDR_WIDTH-1:0] ARADDR,
    input  logic ARVALID,
    input logic ARREADY,

    // Read data channel
    input logic [DATA_WIDTH-1:0] RDATA,
    input logic [1:0] RRESP,
    input logic RVALID,
    input  logic RREADY);
  
  property p_awvalid;
    @(posedge ACLK) disable iff (!ARESETN)
    AWVALID && !AWREADY |=> AWVALID;
  endproperty
  
  property p_awaddr;
    @(posedge ACLK) disable iff (!ARESETN)
    AWVALID && !AWREADY |=> $stable(AWADDR);
  endproperty
  
  property p_reset_awvalid;
    @(posedge ACLK)
    !ARESETN |-> !AWVALID;
  endproperty
  
  property p_ar;
    @(posedge ACLK) disable iff (!ARESETN)
    ARVALID && !ARREADY |=> (ARVALID && $stable(ARADDR));
  endproperty
  
  a_awvalid: assert property(p_awvalid);
  a_awaddr: assert property(p_awaddr);
  a_reset_awvalid: assert property(p_reset_awvalid);
  a_ar: assert property(p_ar);
  
endmodule
  
    
