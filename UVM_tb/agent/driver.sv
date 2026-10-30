`include "sequence_item.sv"
class driver#(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32) extends uvm_driver#(sequence_item#(ADDR_WIDTH, DATA_WIDTH));
  
  
  `uvm_component_param_utils(driver#(ADDR_WIDTH, DATA_WIDTH))
  
  
  virtual intf#(ADDR_WIDTH, DATA_WIDTH) vif;
    
  function new(string name = "driver", uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual intf#(ADDR_WIDTH, DATA_WIDTH))::get(this,"","vif",vif))
      begin
         `uvm_fatal("DRV", "vif not found")
       end
  endfunction  
  
  task reset_signals();
  	// If reset is not already low, wait for it to go low
    if (vif.ARESETN !== 1'b0)
      @(negedge vif.ARESETN);

    vif.AWVALID <= 1'b0;
    vif.WVALID  <= 1'b0;
    vif.BREADY  <= 1'b0;
    vif.ARVALID <= 1'b0;
    vif.RREADY  <= 1'b0;

    // Wait for reset to be release
    wait (vif.ARESETN === 1'b1);
    @(posedge vif.ACLK);
  endtask
  
  task run_phase(uvm_phase phase);
    reset_signals();
    forever begin
      seq_item_port.get_next_item(req);
      if(req.kind == 0) begin
        drive_write(req);
      end
      else begin
        drive_read(req);
      end
      seq_item_port.item_done();
    end
  endtask
  
  task drive_write(sequence_item#(ADDR_WIDTH, DATA_WIDTH) item);
    fork
      //Write data
      begin
        repeat(item.w_delay) @(posedge vif.ACLK);
        vif.WDATA <= item.data;
        vif.WSTRB <= item.strb;
        vif.WVALID <= 1'b1;
        do @(posedge vif.ACLK); while (!vif.WREADY);
        vif.WVALID <= 0;
      end

      //write addr
      begin
        repeat(item.aw_delay) @(posedge vif.ACLK);
        vif.AWADDR <= item.addr;
        vif.AWVALID <= 1'b1;
        do @(posedge vif.ACLK); while (!vif.AWREADY);
        vif.AWVALID <= 0;
      end
    join
    
    vif.BREADY <= 1;
    do @(posedge vif.ACLK); while (!vif.BVALID);
    item.resp <= vif.BRESP;
    vif.BREADY <= 0;
    
  endtask
  
  task drive_read(sequence_item#(ADDR_WIDTH, DATA_WIDTH) item);
    vif.ARADDR <= item.addr;
    vif.ARVALID <= 1;
    do @(posedge vif.ACLK); while(!vif.ARREADY);
    vif.ARVALID <= 0;
    
    vif.RREADY <= 1;
    do @(posedge vif.ACLK); while(!vif.RVALID);
    item.data <= vif.RDATA;
    item.resp <= vif.RRESP;
    vif.RREADY <= 1'b0;
    
  endtask
       
endclass
  
