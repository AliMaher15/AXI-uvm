class axi_master_agent_cfg_c #(DATA_WIDTH = 32) extends uvm_object;

    `uvm_object_param_utils_begin(axi_master_agent_cfg_c #(DATA_WIDTH))
    `uvm_object_utils_end

    //Variables
    virtual axi_master_intf #(DATA_WIDTH) vif;
    uvm_active_passive_enum active = UVM_ACTIVE;
    // has_functional_coverage
    // has_Scoreboard

    // Randimized variables and configurations
    

    //Constraints


    //Functions

    //  Constructor: new
    function new(string name = "");
        super.new(name);
    endfunction: new
    
endclass : axi_master_agent_cfg_c
