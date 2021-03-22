///////sequence/////////
class gen_seq_item extends uvm_sequence;
  `uvm_object_utils(gen_seq_item)
  function new(string name = "gen_seq_item");
    super.new(name);
  endfunction
  virtual task body();
    repeat(20) begin
      packet pkt = packet::type_id::create("pkt");
      start_item(pkt);
      assert(pkt.randomize());
      `uvm_info("SEQ","generating packet",UVM_LOW)
      pkt.print(uvm_default_line_printer);
      finish_item(pkt);
    end
    `uvm_info("SEQ","all packets done",UVM_LOW)
  endtask
endclass

