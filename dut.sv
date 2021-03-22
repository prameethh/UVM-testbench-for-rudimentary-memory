// interface
interface dut_if;
  logic clk;
  logic reset;
  logic [1:0] addr;
  logic wr_en;
  logic rd_en;
  logic [63:0] wdata;
  logic [63:0] rdata;
endinterface
///DUT///
module memory(dut_if _if);
  reg[63:0]mem[4];
  always @ (posedge _if.clk) begin
    if(_if.reset) begin
      for(int i=0;i<16;i++) mem[i]=8'hff;
      $display("[%0t]DUT,System reset now",$time);
    end
    else begin
      if(_if.wr_en) begin
        mem[_if.addr] <= _if.wdata;
        $display("[%0t]DUT write data of %0h match at %0h",$time,_if.wdata,mem[_if.addr]);
      end
      else if (_if.rd_en) begin
        _if.rdata <= mem[_if.addr];
        _if.wdata = 0;
        $display("[%0t]DUT rdata is %0h and wdata is %0h",$time,_if.rdata,_if.wdata);
      end
    end
  end
endmodule
