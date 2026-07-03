// ============================================================
// credit_reg.sv
// Registrador síncrono de crédito — 8 bits, sem sinal
// ============================================================

module credit_reg
  import vending_pkg::*;
(
  input  logic       clk,
  input  logic       rst,
  input  logic       cancel,
  input  logic       credit_load,
  input  logic [1:0] coin_in,
  input  state_t     state,
  output logic [7:0] credit
);

  logic [7:0] coin_value;
  assign coin_value = coin_to_cents(coin_in);

  always_ff @(posedge clk) begin
    if (rst) begin
      credit <= 8'd0;
    end else if (cancel) begin
      credit <= 8'd0;
    end else if (credit_load) begin
      if (state == CHANGE)
        credit <= 8'd0;
      else
        credit <= credit + coin_value;
    end
  end

endmodule
