//////monitor//////////////
class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  virtual dut_if vif;
  uvm_analysis_port#(packet) mon_port;
  function new(string name = "monitor",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual dut_if)::get(this,"","dut_vif",vif)) begin
      `uvm_fatal("MON","no vif handle!!")
    end
    mon_port = new("mon_port",this);
  endfunction
  virtual task run_phase(uvm_phase phase);
    packet pkt = packet::type_id::create("pkt",this);
    forever begin
      @(posedge vif.clk);
      @(vif.wr_en,vif.rd_en,vif.addr,vif.wdata);
      `uvm_info("MON","about to start",UVM_LOW)
      pkt.addr = vif.addr;
      if(vif.wr_en)begin
        `uvm_info("MON","performing WRITE data NOW",UVM_LOW)
        pkt.wr_en = vif.wr_en;
        pkt.rd_en = 0;
        pkt.wdata = vif.wdata;
      end
      else if(vif.rd_en)begin
        
        pkt.rd_en = vif.rd_en;
        pkt.wr_en = 0;
        @(posedge vif.clk);
        @(posedge vif.clk);
        `uvm_info("MON","performing READ data now",UVM_LOW)
        pkt.rdata = vif.rdata;
        pkt.print();
      end
      mon_port.write(pkt);
    end
  endtask
endclass
