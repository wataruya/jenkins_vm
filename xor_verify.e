<'
--------------------------------------------------------------
-- XOR operation definition
--------------------------------------------------------------
struct operation {
                         -- Physical fields
    %a: uint (bits: 1);  -- First input
    %b: uint (bits: 1);  -- Second input
    xor_result: int;     -- Output reference
       keep xor_result == (a ^ b);
};


--------------------------------------------------------------
-- Topmost xor unit instantiation
--------------------------------------------------------------
extend sys {

    keep agent() == "ncvhdl";
    
    xor_top: xor_top_unit is instance;
       keep xor_top.hdl_path() == "~/xor_top";  // Topmost unit path
                                                // Using canonical name ensures
                                                // simulator/language independency
    
       keep xor_top.agent() == "ncvhdl";          // Topmost unit agent to be VHDL.
                                                // Specman will use FMI interface
                                                // when accessing signals associated 
                                                // this unit. 
                                                // Agent definition can be done
                                                // only by constraints
};

--------------------------------------------------------------
-- xor_top unit definition (VHDL)
--------------------------------------------------------------
unit xor_top_unit {
    p_clock: in simple_port of bit is instance;
        keep bind(p_clock,external);
        keep p_clock.hdl_path() == "clock";
    p_xor_in1: inout simple_port of bit is instance;
        keep bind(p_xor_in1,external);
        keep p_xor_in1.hdl_path() == "xor_in1";
    p_xor_in2: inout simple_port of bit is instance;
        keep bind(p_xor_in2,external);
        keep p_xor_in2.hdl_path() == "xor_in2";
    p_xor_out: inout simple_port of bit is instance;
        keep bind(p_xor_out,external);
        keep p_xor_out.hdl_path() == "xor_out";
        
    
    event clock is rise(p_clock$)@sim;           // A clock in the VHDL domain
    
    xor : xor_try_unit is instance;
       keep xor.hdl_path() == "xor_try";        // xor_try unit path
    
       keep xor.agent() == "ncvlog";           // xor_try unit agent to be Verilog 
                                                // Specman will use Verilog PLI interface
                                                // when accessing signals associated 
                                                // with this unit. 
                                                // Agent definition can be done
                                                // only by constraints
    
    operations : list of operation;
       keep operations.size() == 10;            // Inputs to be injected into the DUT
       keep xor.operations == operations;
    
    drive() @me.clock is  {
           
        for each (op) in operations do {
            print op;
            out("\n");
            
            // Drive
            p_xor_in1$ = op.a;                   // Accessing VHDL signals
            p_xor_in2$ = op.b;
            wait cycle;
            
            
            // Print state of the DUT top component
            out("Time: ",sys.time, " ", agent(),         // Use the the pseudo method agent() in messages 
                "  'xor_in1' = ",p_xor_in1$,"  'xor_in2' = ",p_xor_in2$,"  'xor_out' = ",p_xor_out$,"\n");
            
            // Check the xor operation correctness
            check that p_xor_in1$ == op.a;
            check that p_xor_in2$ == op.b;
            check that p_xor_out$ == op.xor_result;
            
        };
        stop_run();
    };
    
    run() is also {
        start drive();
    };
};

--------------------------------------------------------------
-- xor_try definition (Verilog)
--------------------------------------------------------------
unit xor_try_unit {
    p_clk: in simple_port of bit is instance;
        keep bind(p_clk,external);
        keep p_clk.hdl_path() == "clk";
    p_xor_in1: inout simple_port of bit is instance;
        keep bind(p_xor_in1,external);
        keep p_xor_in1.hdl_path() == "xor_in1";
    p_xor_in2: inout simple_port of bit is instance;
        keep bind(p_xor_in2,external);
        keep p_xor_in2.hdl_path() == "xor_in2";
    p_xor_out: inout simple_port of bit is instance;
        keep bind(p_xor_out,external);
        keep p_xor_out.hdl_path() == "xor_out";    
    
    event clk is rise(p_clk$)@sim;               // A clock in the Verilog domain
    
    operations : list of operation;
    
    monitor() @me.clk is {
        
        for each (op) in operations do { 
            
            wait cycle;
            
            // Print state of the DUT low-level component
            out("Time: ",sys.time, " ", agent(),         // Use the the pseudo method agent() in messages 
                "  'xor_in1' = ",p_xor_in1$,"  'xor_in2' = ",p_xor_in2$,"  'xor_out' = ",p_xor_out$,"\n");                        
            // Check the xor operation correctness
            check that p_xor_in1$ == op.a;
            check that p_xor_in2$ == op.b;
            check that p_xor_out$ == op.xor_result;
            
        };
    };
    
    run() is also {
        start monitor();
    };
};

'>
