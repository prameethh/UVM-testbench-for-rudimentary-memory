//////////packet//////////
class packet extends uvm_sequence_item;
  function new(string name = "packet");
    super.new(name);
  endfunction
  randc bit[1:0] addr;
  rand bit wr_en;
  rand bit rd_en;
  rand bit[63:0] wdata;
  bit [63:0] rdata;
  `uvm_object_utils_begin(packet)
  `uvm_field_int(addr, UVM_ALL_ON)
  `uvm_field_int(wr_en, UVM_ALL_ON)
  `uvm_field_int(rd_en, UVM_ALL_ON)
  `uvm_field_int(wdata, UVM_ALL_ON)
  `uvm_field_int(rdata, UVM_ALL_ON)
  `uvm_object_utils_end
  constraint cq {wr_en != rd_en;};
  constraint cq1 {rd_en dist {0:/50,1:/50};};
  constraint cq2 {wr_en dist {0:/50,1:/50};}
endclass
