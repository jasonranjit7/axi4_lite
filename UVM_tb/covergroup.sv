`include "interface.sv"
module cover_group(intf intff);
  
  covergroup axi_lite_cg @(posedge intff.ACLK);
  // Coverpoint tracking the Read Response status
  cp_rresp: coverpoint intff.RRESP {
    bins b_okay   = {2'b00};//OKAY
    bins b_slverr = {2'b10};//SLVERR
  }

  // tracking write addresses
  cp_awaddr: coverpoint intff.AWADDR {
    bins reg_ctrl = {32'h0000_0000};
    bins reg_stat = {32'h0000_0004};
  }
  
  cp_wdata: coverpoint intff.WDATA {
    bins all_zeros = {32'h0000_0000};
    bins all_ones  = {32'hFFFF_FFFF};
  }
  endgroup
  
  axi_lite_cg cg = new();
  
endmodule
