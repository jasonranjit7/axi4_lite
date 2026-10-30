`include "uvm_macros.svh"
import uvm_pkg::*;
`include "interface.sv"
`include "tests/base_test.sv"
`include "tests/test.sv"
`include "sva_module.sv"
`include "../rtl/subordinate.sv"
module tb_top#(parameter ADDR_WIDTH=32, DATA_WIDTH=32)();
  
  logic clk;
  logic resetn;
  
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end
  
  initial begin
  resetn = 0; 
  #20;
  resetn = 1; 
end
  
  intf#(ADDR_WIDTH, DATA_WIDTH) intff(clk, resetn);
  
  subordinate#(.ADDR_WIDTH(32), .DATA_WIDTH(32)
              )dut(
    .ACLK(intff.ACLK),
    .ARESETN(intff.ARESETN),
    .AWADDR(intff.AWADDR),
    .AWVALID(intff.AWVALID),
    .AWREADY(intff.AWREADY),
    .WDATA(intff.WDATA),
    .WSTRB(intff.WSTRB),
    .WVALID(intff.WVALID),
    .WREADY(intff.WREADY),
    .BRESP(intff.BRESP),
    .BVALID(intff.BVALID),
    .BREADY(intff.BREADY),
    .ARADDR(intff.ARADDR),
    .ARVALID(intff.ARVALID),
    .ARREADY(intff.ARREADY),
    .RDATA(intff.RDATA),
    .RRESP(intff.RRESP),
    .RVALID(intff.RVALID),
    .RREADY(intff.RREADY)
  );
  
  bind dut sva_module#(.ADDR_WIDTH(ADDR_WIDTH),
                   .DATA_WIDTH(DATA_WIDTH)
                  ) axi_lite_sva(
    .ACLK(ACLK),
    .ARESETN(ARESETN),
    .AWADDR(AWADDR),
    .AWVALID(AWVALID),
    .AWREADY(AWREADY),
    .WDATA(WDATA),
    .WSTRB(WSTRB),
    .WVALID(WVALID),
    .WREADY(WREADY),
    .BRESP(BRESP),
    .BVALID(BVALID),
    .BREADY(BREADY),
    .ARADDR(ARADDR),
    .ARVALID(ARVALID),
    .ARREADY(ARREADY),
    .RDATA(RDATA),
    .RRESP(RRESP),
    .RVALID(RVALID),
    .RREADY(RREADY)
  );
    
  
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0,tb_top.dut);
    uvm_config_db#(virtual intf#(ADDR_WIDTH, DATA_WIDTH))::set(null, "*", "vif", intff);
    run_test("base_test");
  end
  
  
  
endmodule
