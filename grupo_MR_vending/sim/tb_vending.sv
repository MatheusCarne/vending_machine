// ============================================================
// tb_vending.sv
// Testbench self-checking — 4 cenários obrigatórios
//
// Cenário 1: Compra bem-sucedida com troco
//   coin_in=11 (R$1,00), sel_item=0 (café R$0,25), confirm=1
//   Esperado: dispense=1, change_out=75, credit=0
//
// Cenário 2: Crédito insuficiente
//   coin_in=01 (R$0,25), sel_item=3 (snack R$1,00), confirm=1
//   Esperado: error=1, FSM em ERROR
//
// Cenário 3: Cancelamento
//   coin_in=11, coin_in=11, cancel=1
//   Esperado: credit=0, FSM retorna a IDLE, change_out=200
//
// Cenário 4: Estoque zerado
//   Comprar café 5 vezes (estoque=5), tentar 6ª vez
//   Esperado na 6ª: error=1 (stock=0)
// ============================================================

`timescale 1ns/1ps
import vending_pkg::*;

module tb_vending;

  // ----------------------------------------------------------
  // Sinais de interface com o DUT
  // ----------------------------------------------------------
  logic       clk;
  logic       rst;
  logic [1:0] coin_in;
  logic [1:0] sel_item;
  logic       confirm;
  logic       cancel;
  logic       dispense;
  logic       error;
  logic [7:0] change_out;
  logic [7:0] display;
  logic [2:0] state_out;

  // ----------------------------------------------------------
  // Contadores de PASS/FAIL
  // ----------------------------------------------------------
  int pass_count = 0;
  int fail_count = 0;

  // ----------------------------------------------------------
  // Instância do DUT
  // ----------------------------------------------------------
  vending_top dut (
    .clk       (clk),
    .rst       (rst),
    .coin_in   (coin_in),
    .sel_item  (sel_item),
    .confirm   (confirm),
    .cancel    (cancel),
    .dispense  (dispense),
    .error     (error),
    .change_out(change_out),
    .display   (display),
    .state_out (state_out)
  );

  // ----------------------------------------------------------
  // Geração de clock: período 10 ns (50 MHz)
  // ----------------------------------------------------------
  initial clk = 0;
  always #5 clk = ~clk;

  // ----------------------------------------------------------
  // Geração de waveform para o DVE
  // ----------------------------------------------------------
  initial begin
    $dumpfile("tb_vending.vcd");
    $dumpvars(0, tb_vending);
  end

  // ----------------------------------------------------------
  // Tarefa: check — verifica expected vs actual e reporta
  // ----------------------------------------------------------
  task automatic check(
    input logic [7:0] expected,
    input logic [7:0] actual,
    input string      label
  );
    if (expected === actual) begin
      $display("[PASS] %s: esperado=%0d, obtido=%0d", label, expected, actual);
      pass_count++;
    end else begin
      $display("[FAIL] %s: esperado=%0d, obtido=%0d", label, expected, actual);
      fail_count++;
    end
  endtask

  // ----------------------------------------------------------
  // Tarefa: reset_dut — aplica reset por 2 ciclos
  // ----------------------------------------------------------
  task automatic reset_dut();
    rst     = 1;
    coin_in = 2'b00;
    sel_item= 2'b00;
    confirm = 0;
    cancel  = 0;
    @(posedge clk); #1;
    @(posedge clk); #1;
    rst = 0;
    @(posedge clk); #1;
  endtask

  // ----------------------------------------------------------
  // Tarefa: apply_coin — aplica uma moeda e aguarda 1 ciclo
  // ----------------------------------------------------------
  task automatic apply_coin(input logic [1:0] value);
    coin_in = value;
    @(posedge clk); #1;
    coin_in = 2'b00;
  endtask

  // ----------------------------------------------------------
  // Tarefa: do_confirm — asserta confirm por 1 ciclo
  // ----------------------------------------------------------
  task automatic do_confirm();
    confirm = 1;
    @(posedge clk); #1;
    confirm = 0;
  endtask

  // ----------------------------------------------------------
  // Tarefa: do_cancel — asserta cancel por 1 ciclo
  // ----------------------------------------------------------
  task automatic do_cancel();
    cancel = 1;
    @(posedge clk); #1;
    cancel = 0;
  endtask

  // ----------------------------------------------------------
  // Tarefa: wait_cycles — aguarda N ciclos
  // ----------------------------------------------------------
  task automatic wait_cycles(input int n);
    repeat(n) @(posedge clk);
    #1;
  endtask

  // ----------------------------------------------------------
  // Tarefa: buy_item — executa uma compra completa
  //   item   : sel_item[1:0]
  //   coins  : array de moedas a inserir
  // ----------------------------------------------------------
  task automatic buy_item(
    input logic [1:0] item,
    input logic [1:0] coins []
  );
    sel_item = item;
    // Inserir moedas — FSM vai de IDLE para COLLECT
    foreach (coins[i]) begin
      apply_coin(coins[i]);
    end
    // Confirmar compra
    do_confirm();
    // Aguarda FSM percorrer CHECK → DISPENSE → CHANGE → IDLE
    wait_cycles(5);
  endtask

  // ----------------------------------------------------------
  // Bloco principal de simulação
  // ----------------------------------------------------------
  initial begin
    $display("============================================");
    $display("  Testbench Vending Machine — Iniciando    ");
    $display("============================================");

    // --------------------------------------------------------
    // CENÁRIO 1: Compra bem-sucedida com troco
    // Inserir R$1,00, selecionar café (R$0,25)
    // Esperado: dispense=1, change_out=75, credit=0
    // --------------------------------------------------------
    $display("\n--- Cenário 1: Compra bem-sucedida com troco ---");
    reset_dut();

    begin
      automatic logic [1:0] c1[] = '{2'b11}; // R$1,00
      buy_item(2'b00, c1);                    // café
    end

    check(8'd1,  {7'b0, dispense},  "C1 dispense");
    check(8'd75, change_out,         "C1 change_out");
    check(8'd0,  display,            "C1 credit=0");
    wait_cycles(2);

    // --------------------------------------------------------
    // CENÁRIO 2: Crédito insuficiente
    // Inserir R$0,25, selecionar snack (R$1,00)
    // Esperado: error=1, FSM em ERROR
    // --------------------------------------------------------
    $display("\n--- Cenário 2: Crédito insuficiente ---");
    reset_dut();

    begin
      automatic logic [1:0] c2[] = '{2'b01}; // R$0,25
      buy_item(2'b11, c2);                    // snack
    end

    check(8'd1, {7'b0, error},     "C2 error=1");
    check(8'd5, {5'b0, state_out}, "C2 state=ERROR(5)");

    // Cancelar para voltar ao IDLE
    do_cancel();
    wait_cycles(2);

    // --------------------------------------------------------
    // CENÁRIO 3: Cancelamento durante acúmulo de moedas
    // Inserir R$1,00 + R$1,00, depois cancelar
    // Esperado: credit=0, FSM retorna a IDLE, change_out=200
    // --------------------------------------------------------
    $display("\n--- Cenário 3: Cancelamento ---");
    reset_dut();

    apply_coin(2'b11); // R$1,00
    apply_coin(2'b11); // R$1,00 (total = R$2,00 = 200 centavos)
    wait_cycles(1);
    do_cancel();
    wait_cycles(3);

    check(8'd0,   display,            "C3 credit=0");
    check(8'd0,   {3'b0, state_out},  "C3 state=IDLE(0)");
    check(8'd200, change_out,          "C3 change_out=200");
    wait_cycles(2);

    // --------------------------------------------------------
    // CENÁRIO 4: Estoque zerado
    // Comprar café 5 vezes (estoque inicial=5)
    // Na 6ª tentativa: error=1 (stock=0)
    // --------------------------------------------------------
    $display("\n--- Cenário 4: Estoque zerado ---");
    reset_dut();

    // Comprar café 5 vezes para zerar o estoque
    repeat(5) begin
      automatic logic [1:0] c4[] = '{2'b01}; // R$0,25
      buy_item(2'b00, c4);                    // café
      wait_cycles(2);
    end

    // 6ª tentativa — estoque zerado
    $display("  Tentativa 6 (estoque deve ser 0):");
    begin
      automatic logic [1:0] c4b[] = '{2'b01};
      buy_item(2'b00, c4b);
    end

    check(8'd1, {7'b0, error}, "C4 error=1 (stock=0)");

    // Cancelar para voltar ao IDLE
    do_cancel();
    wait_cycles(2);

    // --------------------------------------------------------
    // Resultado final
    // --------------------------------------------------------
    $display("\n============================================");
    $display("  Resultado: %0d PASS | %0d FAIL", pass_count, fail_count);
    $display("============================================");

    if (fail_count == 0)
      $display("  SIMULACAO CONCLUIDA COM SUCESSO");
    else
      $display("  ATENCAO: %0d verificacao(oes) falharam", fail_count);

    $display("============================================\n");
    $finish;
  end

  // ----------------------------------------------------------
  // Timeout: encerra simulação se travar (10.000 ciclos)
  // ----------------------------------------------------------
  initial begin
    #100000;
    $display("[TIMEOUT] Simulacao excedeu o limite de tempo!");
    $finish;
  end

endmodule
