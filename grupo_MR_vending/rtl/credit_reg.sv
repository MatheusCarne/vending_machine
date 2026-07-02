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
  assign coin_value = coin_to_cents(coin_in);

  // ----------------------------------------------------------
  // Registrador síncrono com prioridade explícita
  // ----------------------------------------------------------
  always_ff @(posedge clk) begin
    if (rst) begin
      // Prioridade 1: reset síncrono — zera tudo
      credit <= 8'd0;

    end else if (cancel) begin
      // Prioridade 2: cancelamento — devolve crédito ao usuário
      // (a FSM também volta ao IDLE neste ciclo)
      credit <= 8'd0;

    end else if (credit_load) begin
      if (state == CHANGE) begin
        // Prioridade 3: fim da venda — zera crédito após calcular troco
        credit <= 8'd0;
      end else begin
        // Prioridade 4: COLLECT — acumula valor da moeda
        // Não verifica overflow: 8 bits comportam até R$2,55,
        // suficiente para cobrir qualquer item (máx R$1,00)
        credit <= credit + coin_value;
      end
    end
    // Sem else: registrador mantém valor (latch-free por ser always_ff)
  end

endmodule

