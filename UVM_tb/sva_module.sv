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
  
  property p_cov_ar_handshake;
    @(posedge ACLK) disable iff (!ARESETN)
    ARVALID && ARREADY;
  endproperty
  
  property p_cov_aw_handshake;
    @(posedge ACLK) disable iff (!ARESETN)
    AWVALID && AWREADY;
  endproperty
  
  property p_cov_w_handshake;
    @(posedge ACLK) disable iff (!ARESETN)
    WVALID && WREADY;
  endproperty
  
  property p_cov_b_handshake;
    @(posedge ACLK) disable iff (!ARESETN)
    BVALID && BREADY;
  endproperty
  
  property p_cov_r_handshake;
    @(posedge ACLK) disable iff (!ARESETN)
    RVALID && RREADY;
  endproperty
  
  property p_cov_back2back_r;
    @(posedge ACLK) disable iff (!ARESETN)
    (RVALID && RREADY) ##1 (RVALID && RREADY);
  endproperty
  
  property p_cov_aw_to_b;
    @(posedge ACLK) disable iff (!ARESETN)
    (AWVALID && AWREADY) ##[1:5] (BVALID && BREADY);
  endproperty
  
  property p_cov_aw_w_simultaneous;
    @(posedge ACLK) disable iff (!ARESETN)
    (AWVALID && AWREADY && WVALID && WREADY);
  endproperty
  
  c_cov_aw_w_simultaneous: cover property(p_cov_aw_w_simultaneous);
  c_cov_aw_to_b: cover property(p_cov_aw_to_b);
  c_cov_back2back_r: cover property(p_cov_back2back_r);
  c_cov_r_handshake: cover property(p_cov_r_handshake);
  c_cov_b_handshake: cover property(p_cov_b_handshake);
  c_cov_w_handshake: cover property(p_cov_w_handshake);
  c_cov_ar_handshake: cover property(p_cov_ar_handshake);
  c_cov_aw_handshake: cover property(p_cov_aw_handshake);
  
  a_awvalid: assert property(p_awvalid)
    else `uvm_error("AXI_AWVALID_ERR", 
      $sformatf("AWADDR changed while waiting for AWREADY! Current AWADDR = 0x%0h",
                AWADDR));
  a_awaddr: assert property(p_awaddr)
    else `uvm_error("AXI_AWADDR_ERR", "AXI_AWADDR_ERR");
  a_reset_awvalid: assert property(p_reset_awvalid)
    else `uvm_error("RESET_AWVALID_ERR", "Descriptive failure message");
  a_ar: assert property(p_ar)
    else `uvm_error("READ_ERR", "Descriptive failure message");
    
    
  
endmodule
  
    
