class axi_coverage_c extends uvm_component;
    `uvm_component_utils(axi_coverage_c)

    `uvm_analysis_imp_decl(_axi_m_in)
    uvm_analysis_imp_axi_m_i n #(axi_item, axi_coverage_c) axi_m_in_imp;
    `uvm_analysis_imp_decl(_axi_s_in)
    uvm_analysis_imp_axi_s_in  #(axi_item, axi_coverage_c) axi_s_in_imp;


    bit [DATA_WIDTH-1:0] data;


    covergroup cg_zeros_or_ones_data;

        cp_parallel_data: coverpoint s_data_in {
            bins zeros = {'h00};
            bins ones = {'hFF};
        }
        
    endgroup: cg_zeros_or_ones_data
    
    // Constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg_zeros_or_ones_data = new();
    endfunction

    // Implimintation Functions
    extern function void write_axi_m_in(axi_item t);
    extern function void write_axi_s_in(axi_item t);


endclass : axi_coverage_c


function void axi_coverage_c::write_axi_m_in(input axi_item item);
    if (item.rst_op)
        // sample covergroups
        cg_zeros_or_ones_data.sample();
endfunction : write_axi_m_in


function void axi_coverage_c::write_axi_s_in(input axi_item item);
    if (item.rst_op)
        // sample covergroups
        cg_zeros_or_ones_data.sample();
endfunction : write_axi_s_in