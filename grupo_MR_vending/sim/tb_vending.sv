module tb_vending
  import vending_pkg::*;
();

  logic       clk, rst;
  logic [1:0] coin_in, sel_item;
  logic       confirm, cancel;
  logic       dispense, error;
  logic [7:0] change_out, display;
  logic [2:0] state_out;

  int pass_count = 0;
  int fail_count = 0;

  vending_top dut (
    .clk(clk), .rst(rst), .coin_in(coin_in), .sel_item(sel_item),
    .confirm(confirm), .cancel(cancel), .dispense(dispense),
    .error(error), .change_out(change_out), .display(display),
    .state_out(state_out)
  );

  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    $dumpfile("tb_vending.vcd");
    $dumpvars(0, tb_vending);
  end

  task automatic check(
    input logic [7:0] expected,
    input logic [7:0] actual,
    input string      label
  );
    if (expected === actual) begin
      $display("[PASS] %s: esperado=%0d obtido=%0d", label, expected, actual);
      pass_count++;
    end else begin
      $display("[FAIL] %s: esperado=%0d obtido=%0d", label, expected, actual);
      fail_count++;
    end
  endtask

  task automatic reset_dut();
    rst=1; coin_in=0; sel_item=0; confirm=0; cancel=0;
    @(posedge clk); #1;
    @(posedge clk); #1;
    rst=0;
    @(posedge clk); #1;
  endtask

  task automatic apply_coin(input logic [1:0] value);
    coin_in = value;
    @(posedge clk); #1;
    @(posedge clk); #1;
    coin_in = 2'b00;
  endtask

  task automatic do_confirm();
    confirm=1; @(posedge clk); #1; confirm=0;
  endtask

  task automatic do_cancel();
    cancel=1; @(posedge clk); #1; cancel=0;
  endtask

  task automatic wait_cycles(input int n);
    repeat(n) @(posedge clk); #1;
  endtask

  task automatic buy_item(
    input logic [1:0] item,
    input logic [1:0] coins []
  );
    sel_item = item;
    foreach (coins[i]) apply_coin(coins[i]);
    do_confirm();
    wait_cycles(7);
  endtask

  initial begin
    $display("============================================");
    $display("  Testbench Vending Machine - Iniciando    ");
    $display("============================================");

    // Cenário 1: Compra bem-sucedida com troco
    $display("\n--- Cenario 1: Compra bem-sucedida com troco ---");
    reset_dut();
    begin
      automatic logic [1:0] c[] = '{2'b11};
      buy_item(2'b00, c);
    end
    check(8'd1,  {7'b0, dispense}, "C1 dispense");
    check(8'd75, change_out,        "C1 change_out=75");
    check(8'd0,  display,           "C1 credit=0");
    wait_cycles(2);

    // Cenário 2: Crédito insuficiente
    $display("\n--- Cenario 2: Credito insuficiente ---");
    reset_dut();
    begin
      automatic logic [1:0] c[] = '{2'b01};
      buy_item(2'b11, c);
    end
    check(8'd1, {7'b0, error},     "C2 error=1");
    check(8'd5, {5'b0, state_out}, "C2 state=ERROR");
    do_cancel();
    wait_cycles(2);

    // Cenário 3: Cancelamento
    $display("\n--- Cenario 3: Cancelamento ---");
    reset_dut();
    apply_coin(2'b11);
    apply_coin(2'b11);
    wait_cycles(1);
    do_cancel();
    wait_cycles(3);
    check(8'd0,   display,           "C3 credit=0");
    check(8'd0,   {3'b0, state_out}, "C3 state=IDLE");
    check(8'd200, change_out,         "C3 change_out=200");
    wait_cycles(2);

    // Cenário 4: Estoque zerado
    $display("\n--- Cenario 4: Estoque zerado ---");
    reset_dut();
    repeat(5) begin
      automatic logic [1:0] c[] = '{2'b01};
      buy_item(2'b00, c);
      wait_cycles(2);
    end
    $display("  Tentativa 6 (estoque deve ser 0):");
    begin
      automatic logic [1:0] c[] = '{2'b01};
      buy_item(2'b00, c);
    end
    check(8'd1, {7'b0, error}, "C4 error=1 stock=0");
    do_cancel();
    wait_cycles(2);

    $display("\n============================================");
    $display("  Resultado: %0d PASS | %0d FAIL", pass_count, fail_count);
    if (fail_count == 0)
      $display("  SIMULACAO CONCLUIDA COM SUCESSO");
    else
      $display("  ATENCAO: %0d falha(s)", fail_count);
    $display("============================================\n");
    $finish;
  end

  initial begin
    #200000;
    $display("[TIMEOUT] Simulacao excedeu o limite!");
    $finish;
  end

endmodule
