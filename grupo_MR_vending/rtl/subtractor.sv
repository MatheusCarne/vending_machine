// ============================================================
// subtractor.sv
// Subtrator combinacional — calcula o troco em centavos
//
// change = credit - price
//
// O resultado é calculado o tempo todo (combinacional), mas
// só é capturado na saída change_out quando a FSM entra em
// CHANGE e ativa o sinal de registro (feito em vending_top.sv).
//
// Garantia de não-negatividade:
//   O comparador já verificou credit >= price antes de a FSM
//   chegar em DISPENSE/CHANGE. Portanto a subtração aqui é
//   sempre >= 0 — não há risco de underflow.
//
// Caso crédito exato (credit == price):
//   change = 0 → change_out fica em zero, nenhum troco devolvido.
//   A FSM passa por CHANGE normalmente e volta ao IDLE.
// ============================================================

import vending_pkg::*;

module subtractor (
  input  logic [DATA_WIDTH-1:0] credit,  // crédito acumulado (centavos)
  input  logic [DATA_WIDTH-1:0] price,   // preço do item selecionado (centavos)
  output logic [DATA_WIDTH-1:0] change   // troco calculado (centavos)
);

  // ----------------------------------------------------------
  // Lógica combinacional pura — sem clock, sem estado
  //
  // O sintetizador implementa como um subtrator ripple-carry
  // de 8 bits. O bit de borrow é descartado pois a não-
  // negatividade é garantida pelo comparador upstream.
  // ----------------------------------------------------------
  assign change = credit - price;

endmodule

