`timescale 1ns/1ps

// ============================================================
// vending_pkg.sv
// Package global: encoding de estados, tipos e funções
// Importar em todos os módulos com: import vending_pkg::*;
// ============================================================

package vending_pkg;

  // ----------------------------------------------------------
  // Encoding dos 6 estados da FSM de Moore (3 bits)
  // Usado em control_unit.sv e exposto via state_out
  // ----------------------------------------------------------
  typedef enum logic [2:0] {
    IDLE     = 3'b000,
    COLLECT  = 3'b001,
    CHECK    = 3'b010,
    DISPENSE = 3'b011,
    CHANGE   = 3'b100,
    ERROR    = 3'b101
  } state_t;

  // ----------------------------------------------------------
  // Parâmetros da memória
  // 4 itens, cada posição tem 16 bits: [15:8]=price, [7:0]=stock
  // ----------------------------------------------------------
  parameter int NUM_ITEMS  = 4;
  parameter int MEM_WIDTH  = 16;
  parameter int ADDR_WIDTH = 2;   // log2(4) = 2 bits → sel_item[1:0]
  parameter int DATA_WIDTH = 8;   // price e stock em centavos (8 bits cada)

  // ----------------------------------------------------------
  // Preços iniciais em centavos (ponto fixo inteiro)
  //   Café  = 0x19 = 25  centavos
  //   Água  = 0x32 = 50  centavos
  //   Suco  = 0x4B = 75  centavos
  //   Snack = 0x64 = 100 centavos
  // ----------------------------------------------------------
  parameter logic [7:0] PRICE_CAFE  = 8'd25;
  parameter logic [7:0] PRICE_AGUA  = 8'd50;
  parameter logic [7:0] PRICE_SUCO  = 8'd75;
  parameter logic [7:0] PRICE_SNACK = 8'd100;

  // ----------------------------------------------------------
  // Estoques iniciais
  // ----------------------------------------------------------
  parameter logic [7:0] STOCK_CAFE  = 8'd5;
  parameter logic [7:0] STOCK_AGUA  = 8'd5;
  parameter logic [7:0] STOCK_SUCO  = 8'd3;
  parameter logic [7:0] STOCK_SNACK = 8'd2;

  // ----------------------------------------------------------
  // Função: decodifica coin_in[1:0] → valor em centavos
  //   00 → 0    (nenhuma moeda)
  //   01 → 25   (R$0,25)
  //   10 → 50   (R$0,50)
  //   11 → 100  (R$1,00)
  // Declarada aqui para reutilização em credit_reg e testbench
  // ----------------------------------------------------------
  function automatic logic [7:0] coin_to_cents(input logic [1:0] coin);
    case (coin)
      2'b01:   return 8'd25;
      2'b10:   return 8'd50;
      2'b11:   return 8'd100;
      default: return 8'd0;
    endcase
  endfunction

endpackage

