class axi_coverage_c extends uvm_component;
    `uvm_component_utils(axi_coverage_c)

    `uvm_analysis_imp_decl(_axi_m_in)
    uvm_analysis_imp_axi_m_in #(axi_item_c, axi_coverage_c) axi_m_in_imp;
    `uvm_analysis_imp_decl(_axi_s_in)
    uvm_analysis_imp_axi_s_in  #(axi_item_c, axi_coverage_c) axi_s_in_imp;


    axi_item_c   m_item = axi_item_c::type_id::create("m_item");


    covergroup all_zeros_ones_cg;

        data_cp: coverpoint m_item.tdata {
            bins zeros = {'h00};
            bins ones = {'hFF};
        }
        
    endgroup: all_zeros_ones_cg

    covergroup delay_cg;

        delay_cp: coverpoint m_item.delay {
            bins high = {m_item.delay > 5};
            bins low  = {m_item.delay <= 5};
            bins none = {0};
        }
        
    endgroup: delay_cgx 
    
    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        axi_m_in_imp = new("axi_m_in_imp", this);
        axi_s_in_imp = new("axi_s_in_imp", this);
        all_zeros_ones_cg = new();
        delay_cg = new();
    endfunction

    // Implimintation Functions
    extern function void write_axi_m_in(axi_item_c t);
    extern function void write_axi_s_in(axi_item_c t);


endclass : axi_coverage_c


function void axi_coverage_c::write_axi_m_in(input axi_item_c t);
    if (!t.rst_op) begin
        m_item = t; // shallow copy
        all_zeros_ones_cg.sample();
        delay_cg.sample();
    end 
endfunction : write_axi_m_in


function void axi_coverage_c::write_axi_s_in(input axi_item_c t);
    if (!t.rst_op) begin
        m_item = t; // shallow copy
        all_zeros_ones_cg.sample();
        delay_cg.sample();
    end
endfunction : write_axi_s_in