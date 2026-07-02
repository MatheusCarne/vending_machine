// ============================================================
// credit_reg.sv
// Registrador síncrono de crédito — 8 bits, sem sinal
//
// Comportamento por prioridade (ordem no always_ff):
//   1. rst=1        → credit ← 0  (reset síncrono)
//   2. cancel=1     → credit ← 0  (devolução imediata)
//   3. credit_load=1, state=CHANGE  → credit ← 0  (zera após venda)
//   4. credit_load=1, state=COLLECT → credit ← credit + coin_value
//
// Representação em ponto fixo inteiro (centavos):
//   R$0,25 = 25 | R$0,50 = 50 | R$1,00 = 100
//   Máximo acumulável: 255 centavos (R$2,55)
// ============================================================

import vending_pkg::*;

module credit_reg (
  input  logic       clk,
  input  logic       rst,          // reset síncrono, ativo alto
  input  logic       cancel,       // zera crédito em qualquer estado
  input  logic       credit_load,  // habilitação de escrita (vem da FSM)
  input  logic [1:0] coin_in,      // moeda inserida (decodificada internamente)
  input  state_t     state,        // estado atual da FSM (distingue COLLECT/CHANGE)
  output logic [7:0] credit        // crédito acumulado em centavos
);

  // Decodificação combinacional da moeda (usa função do package)
  logic [7:0] coin_value;
  always_comb begin
      case (coin_in)
          2'b00: coin_value = 8'd0;
          2'b01: coin_value = COIN_25;
          2'b10: coin_value = COIN_50;
          2'b11: coin_value = COIN_100;
      endcase
  end

  always_ff @(posedge clk) begin
      if (rst || cancel) begin
          credit <= 8'd0;
      end else if (credit_load) begin
          credit <= credit + coin_value;
      end
  end

endmodule
