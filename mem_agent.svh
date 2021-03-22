/////agent/////////
class agent extends uvm_agent;
  `uvm_component_utils(agent)
  uvm_sequencer#(packet) s0;
  driver d0;
  monitor m0;
  uvm_analysis_port#(packet) ag_port;
  function new(string name = "agent",uvm_component parent = null);
    super.new(name,parent);
  endfunction
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    s0 = uvm_sequencer#(packet)::type_id::create("s0",this);
    d0 = driver::type_id::create("d0",this);
    m0 = monitor::type_id::create("m0",this);
    ag_port = new("ag_port",this);
  endfunction
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    d0.seq_item_port.connect(s0.seq_item_export);
    m0.mon_port.connect(this.ag_port);
  endfunction
endclass
