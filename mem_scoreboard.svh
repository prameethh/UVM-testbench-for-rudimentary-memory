//////scoreboard//////
class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  uvm_analysis_imp#(packet,scoreboard) sc_port;
  bit[63:0]sc_mem[16];
  packet sc_qu[$];
  packet sc_pkt;
  function new(string name = "scoreboard",uvm_component parent = null);
    super.new(name,parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    sc_port = new("sc_port",this);
    foreach(sc_mem[i]) sc_mem[i] = 8'hff;
  endfunction
  virtual function void write(packet pkt);
    sc_qu.push_back(pkt);
  endfunction
  virtual task run_phase(uvm_phase phase);
    forever begin
    wait(sc_qu.size()>0);
      sc_pkt = sc_qu.pop_front();
      if(sc_pkt.wr_en == 1)begin
        sc_mem[sc_pkt.addr] = sc_pkt.wdata;
        `uvm_info("SCBD","Data written to locl mem",UVM_LOW)
        $display("[%0t]SCBD addr=%0h,wdata=%0h",$time,sc_pkt.addr,sc_pkt.wdata);
      end
      else if(sc_pkt.rd_en == 1)begin
        if(sc_mem[sc_pkt.addr] == sc_pkt.rdata) begin
          `uvm_info("SCBD","Read Match!!",UVM_LOW)
          $display("[%0t]SCBD rdata from dut is %0h, rdata local is %0h",$time,sc_pkt.rdata,sc_mem[sc_pkt.addr]);
        end
        else begin
          `uvm_error("SCBD","No match while read!!",UVM_LOW)
          $display("[%0t]SCBD rdata from dut is %0h, rdata local is %0h",$time,sc_pkt.rdata,sc_mem[sc_pkt.addr]);
        end
      end
    end
  endtask
endclass
