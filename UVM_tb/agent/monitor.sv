class monitor#(parameter ADDR_WIDTH = 32, DATA_WIDTH = 32) extends 
  uvm_monitor#(sequence_item#(ADDR_WIDTH, DATA_WIDTH));
  
  `uvm_component_param_utils(monitor#(ADDR_WIDTH, DATA_WIDTH))
  
  
  virtual intf#(ADDR_WIDTH, DATA_WIDTH) vif;
  uvm_analysis_port #(sequence_item#(ADDR_WIDTH, DATA_WIDTH)) item_collected_port;
  
  function new(string name, uvm_component parent);
    super.new(name, parent);
    item_collected_port = new("item_collectoed_port", this);
  endfunction
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual intf#(ADDR_WIDTH,
                                     DATA_WIDTH))::get(this,"","vif",vif));
       begin
         `uvm_fatal("MON", "vif not found")
       end
  endfunction
  
  task run_phase(uvm_phase phase);
    fork
      monitor_read();
      monitor_write();
    join
  endtask
  
  task monitor_write();
    sequence_item#(ADDR_WIDTH, DATA_WIDTH) trans;
    forever @(posedge vif.ACLK) begin
      if(vif.ARESETN && vif.BREADY && vif.BVALID) begin
        trans = sequence_item#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("trans");
        trans.kind = 0;
        trans.addr = vif.AWADDR;
        trans.data = vif.WDATA;
        trans.strb = vif.WSTRB;
        trans.resp = vif.BRESP;
        item_collected_port.write(trans);
      end
    end
  endtask
  
  task monitor_read();
    sequence_item#(ADDR_WIDTH, DATA_WIDTH) trans;
    forever @(posedge vif.ACLK) begin
      if(vif.ARESETN && vif.RREADY && RVALID) begin
        trans = sequence_item#(ADDR_WIDTH, DATA_WIDTH)::type_id::create("trans");
        trans.kind = 1;
        trans.addr = vif.ARADDR;
        trans.data = vif.RDATA;
        trans.resp = vif.RRESP;
        item_collected_port.write(trans);
      end
    end
  endtask
endclass
    
       
  
  
