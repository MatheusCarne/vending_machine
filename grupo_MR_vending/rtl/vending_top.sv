// ============================================================
// vending_top.sv
// Top-level: instancia e interconecta todos os módulos RTL
//
// Hierarquia:
//   vending_top
//   ├── u_control  : control_unit  (FSM de Moore)
//   ├── u_credit   : credit_reg    (registrador de crédito 8 bits)
//   ├── u_memory   : memory        (4×16 bits, preços e estoques)
//   ├── u_comparator: comparator   (can_sell combinacional)
//   └── u_subtractor: subtractor   (change combinacional)
//
// Saídas registradas neste nível:
//   change_out : registrado quando change_load=1 (estado CHANGE/ERROR)
//   display    : registrado a cada ciclo (espelho do crédito atual)
//   state_out  : direto do registrador de estado da FSM
// ============================================================

import vending_pkg::*;

module vending_top (
  input  logic       clk,
  input  logic       rst,
  input  logic [1:0] coin_in,
  input  logic [1:0] sel_item,
  input  logic       confirm,
  input  logic       cancel,
  // Saídas
  output logic       dispense,
  output logic       error,
  output logic [7:0] change_out,
  output logic [7:0] display,
  output logic [2:0] state_out
);

  // ----------------------------------------------------------
  // Fios internos — interconexão entre módulos
  // ----------------------------------------------------------

  // FSM → caminho de dados
  logic       credit_load;
  logic       mem_read;
  logic       mem_write;
  logic       change_load;

  // Caminho de dados → FSM / saídas
  logic [7:0] credit;
  logic [7:0] price;
  logic [7:0] stock;
  logic       can_sell;
  logic [7:0] change;

  // Estado atual (FSM → top-level)
  state_t     state_internal;

  // ----------------------------------------------------------
  // Instância: Unidade de controle (FSM de Moore)
  // ----------------------------------------------------------
  control_unit u_control (
    .clk        (clk),
    .rst        (rst),
    .coin_in    (coin_in),
    .confirm    (confirm),
    .cancel     (cancel),
    .can_sell   (can_sell),
    .credit_load(credit_load),
    .mem_read   (mem_read),
    .mem_write  (mem_write),
    .change_load(change_load),
    .dispense   (dispense),
    .error      (error),
    .state_out  (state_internal)
  );

  // ----------------------------------------------------------
  // Instância: Registrador de crédito
  // ----------------------------------------------------------
  credit_reg u_credit (
    .clk        (clk),
    .rst        (rst),
    .cancel     (cancel),
    .credit_load(credit_load),
    .coin_in    (coin_in),
    .state      (state_internal),
    .credit     (credit)
  );

  // ----------------------------------------------------------
  // Instância: Memória de preços e estoques
  // ----------------------------------------------------------
  memory u_memory (
    .clk      (clk),
    .rst      (rst),
    .sel_item (sel_item),
    .mem_read (mem_read),
    .mem_write(mem_write),
    .price    (price),
    .stock    (stock)
  );

  // ----------------------------------------------------------
  // Instância: Comparador combinacional
  // ----------------------------------------------------------
  comparator u_comparator (
    .credit  (credit),
    .price   (price),
    .stock   (stock),
    .can_sell(can_sell)
  );

  // ----------------------------------------------------------
  // Instância: Subtrator combinacional
  // ----------------------------------------------------------
  subtractor u_subtractor (
    .credit(credit),
    .price (price),
    .change(change)
  );

  // ----------------------------------------------------------
  // Registro de change_out
  // Capturado quando change_load=1 (FSM em CHANGE ou ERROR)
  // Mantido até a próxima operação
  // ----------------------------------------------------------
  always_ff @(posedge clk) begin
    if (rst) begin
      change_out <= 8'd0;
    end else if (change_load) begin
      change_out <= change;  // registra credit - price
    end
  end

  // ----------------------------------------------------------
  // Registro de display
  // Reflete o crédito acumulado atual para exibição externa
  // Atualizado a cada ciclo (sem habilitação)
  // ----------------------------------------------------------
  always_ff @(posedge clk) begin
    if (rst)
      display <= 8'd0;
    else
      display <= credit;
  end

  // ----------------------------------------------------------
  // state_out: converte state_t (enum) para logic [2:0]
  // Direto do registrador de estado da FSM — sem atraso extra
  // ----------------------------------------------------------
  assign state_out = 3'(state_internal);

endmodule
