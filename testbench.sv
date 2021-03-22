
import uvm_pkg::*;
`include"uvm_macros.svh"
`include"mem_packet.svh"
`include"mem_driver.svh"
`include"mem_sequence.svh"
`include"mem_monitor.svh"
`include"mem_scoreboard.svh"
`include"mem_agent.svh"
`include"mem_env.svh"
`include"mem_basetest.svh"

//////top level module//////
module tb;
  dut_if intf1();
  memory mem0 (._if (intf1));
  initial begin
    uvm_config_db#(virtual dut_if)::set(null,"*","dut_vif",intf1);
    run_test("base_test");
  end
  initial begin
    intf1.clk = 0;
  end
  initial begin
    forever #5 intf1.clk=~intf1.clk;
  end
  initial begin
    $dumpfile("ths.vcd");
    $dumpvars(0,tb);
  end
endmodule









  

  

  
    
    

  


  
        
      
   
  

