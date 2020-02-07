/**
 *
 * Name:
 *   bp_cce_inst_predecode.v
 *
 * Description:
 *   The pre-decoder examines the branch and predict bits from the instruction, extracts the
 *   branch target from the instruction, and then outputs the next fetch PC.
 *   The next fetch PC is either current fetch PC + 1 or the branch target.
 *
 *   The fetch_pc_i signal comes directly from the fetch PC register (which has the same value as
 *   the registered address in the instruction RAM), and the instruction comes from the read of
 *   the instruction RAM.
 *
 *   The Fetch PC register, through the instruction RAM read, through pre-decode, and then
 *   through muxes to the input of the Fetch PC register for the next cycle is a likely critical
 *   path in the CCE.
 *
 */

module bp_cce_inst_predecode
  import bp_cce_pkg::*;
  #(parameter width_p = "inv")
  (input bp_cce_inst_s                              inst_i
   , input [width_p-1:0]                            fetch_pc_i
   //, output logic                                   predict_taken_o
   , output logic [width_p-1:0]                     predicted_fetch_pc_o
  );

  //synopsys translate_off
  initial begin
    assert(width_p <= `bp_cce_inst_addr_width)
      else $error("Desired address width is larger than address width used in instruction encoding");
  end
  //synopsys translate_on

  wire [width_p-1:0] fetch_pc_plus_one = fetch_pc_i + 'd1;
  wire [width_p-1:0] branch_target = inst_i.type_u.branch.target[0+:width_p];

  //assign predict_taken_o = inst_i.branch & inst_i.predict_taken;
  assign predicted_fetch_pc_o = predict_taken_o ? branch_target : fetch_pc_plus_one;

endmodule