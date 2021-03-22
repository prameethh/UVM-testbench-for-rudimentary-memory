//////////driver//////////////
class driver extends uvm_driver#(packet);
  `uvm_component_utils(driver)
  virtual dut_if vif;
  function new(string name = "driver",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual dut_if)::get(this,"","dut_vif",vif)) begin
      `uvm_fatal("DRV","no vif handle!!")
    end
  endfunction
  virtual task run_phase(uvm_phase phase);
   vif.reset = 1;
    @(posedge vif.clk);
    vif.reset =0;
    @(posedge vif.clk);
    repeat(20) begin
      packet pkt;
      `uvm_info("DRV","about to start",UVM_LOW)
      seq_item_port.get_next_item(pkt);
      drive_item(pkt);
      seq_item_port.item_done();
      @(posedge vif.clk);
      @(posedge vif.clk);
      @(posedge vif.clk);
    end
  endtask
  virtual task drive_item(packet pkt);
      if(pkt.wr_en) begin
      `uvm_info("DRV","sending WRITE data",UVM_LOW)
      vif.wdata = pkt.wdata;
      vif.wr_en = pkt.wr_en;
      vif.rd_en=0;
      vif.addr = pkt.addr;
      
    end
    else if(pkt.rd_en) begin
      `uvm_info("DRV","sending READ data",UVM_LOW)
      vif.addr = pkt.addr;
      vif.rd_en = pkt.rd_en;
      vif.wr_en=0;
      vif.wdata=0;
      $display("[%0t]DRV read addr sent is %0h,wdata is %0h",$time,vif.addr,vif.wdata);
     
    end
  endtask
endclass
