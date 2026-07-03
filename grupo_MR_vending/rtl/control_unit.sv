// ============================================================
// control_unit.sv
// Unidade de controle — FSM de Moore com 6 estados
//
// Implementação com dois blocos always separados:
//   1. always_ff  → transição de estados (sequencial)
//   2. always_comb → lógica de saídas e próximo estado (combinacional)
//
// Fluxo normal:  IDLE → COLLECT → CHECK → DISPENSE → CHANGE → IDLE
// Desvio erro:   CHECK → ERROR → IDLE (aguarda cancel)
// Cancel:        qualquer estado → IDLE (prioridade máxima após rst)
//
// FSM de Moore: saídas dependem APENAS do estado atual,
// nunca diretamente das entradas.
// ============================================================


module control_unit
  import vending_pkg::*;
(
  input  logic       clk,
  input  logic       rst,         // reset síncrono, ativo alto
  input  logic [1:0] coin_in,     // moeda inserida (00 = nenhuma)
  input  logic [1:0]  sel_item,     
  input  logic       confirm,     // usuário confirma compra
  input  logic       cancel,      // usuário cancela — retorna ao IDLE
  input  logic       can_sell,    // comparador: crédito OK e estoque > 0
  input  logic [7:0]  change,
  input  logic [7:0]  credit,
  // Sinais de controle para o caminho de dados
  output logic       credit_load, // habilita escrita no registrador de crédito
  output logic        credit_clr,
  output logic       mem_read,    // habilita leitura da memória
  output logic       mem_write,   // habilita escrita na memória (decrementa stock)
  output logic       change_load, // habilita registro do troco em change_out
  // Saídas da máquina (decodificadas de state_reg — Moore)
  output logic       dispense,    // pulso de 1 ciclo: libera o item físico
  output logic       error,       // crédito insuficiente ou sem estoque
  output logic [7:0]  change_out,
  output logic [7:0]  display,
  output logic [2:0]  state_out
);

  // ----------------------------------------------------------
  // Registrador de estado (state_reg) — único elemento sequencial
  // ----------------------------------------------------------
  state_t state_reg, next_state;

  // Expõe o estado atual para o top-level (display e testbench)
  assign state_out = state_reg;

  // ----------------------------------------------------------
  // Bloco 1: Transição de estados — sempre síncrono
  // ----------------------------------------------------------
  always_ff @(posedge clk) begin
    if (rst)
      state_reg <= IDLE;
    else
      state_reg <= next_state;
  end

  // ----------------------------------------------------------
  // Bloco 2: Lógica de próximo estado e saídas — combinacional
  // Separado do always_ff para satisfazer o estilo Moore de dois blocos
  // ----------------------------------------------------------
  always_comb begin
    // Valores default: todos os sinais desativados
    // Evita latches — todo sinal recebe valor em todos os caminhos
    next_state  = state_reg;
    credit_load = 1'b0;
    mem_read    = 1'b0;
    mem_write   = 1'b0;
    change_load = 1'b0;
    dispense    = 1'b0;
    error       = 1'b0;
    change_out  = 8'd0;
    display     = credit;
    state_out   = state;

    // Cancel tem prioridade máxima em qualquer estado (exceto rst)
    if (cancel) begin
      next_state  = IDLE;
      credit_load = 1'b1; // sinaliza ao credit_reg para zerar (state=qualquer != COLLECT)

    end else begin
      case (state_reg)

        // ----------------------------------------------------
        // IDLE: aguarda inserção de moeda
        // Nenhuma saída ativa — máquina em repouso
        // ----------------------------------------------------
        IDLE: begin
          if (coin_in != 2'b00)
            next_state = COLLECT;
        end

        // ----------------------------------------------------
        // COLLECT: acumula moedas ciclo a ciclo
        // credit_load=1 enquanto houver moeda inserida
        // Avança para CHECK quando confirm=1
        // ----------------------------------------------------
        COLLECT: begin
          if (confirm) begin
            next_state = CHECK;
          end else if (coin_in != 2'b00) begin
            credit_load = 1'b1; // soma coin_value ao crédito
          end
        end

        // ----------------------------------------------------
        // CHECK: lê memória e aguarda can_sell do comparador
        // mem_read=1 → price e stock disponíveis no próximo ciclo
        // can_sell já está válido neste ciclo (latência da memória)
        // ----------------------------------------------------
        CHECK: begin
          mem_read = 1'b1;
          if (can_sell)
            next_state = DISPENSE;
          else
            next_state = ERROR;
        end

        // ----------------------------------------------------
        // DISPENSE: libera o item por exatamente 1 ciclo
        // dispense=1  → pulso detectado pelo mecanismo físico
        // mem_write=1 → decrementa stock na memória
        // Avança imediatamente para CHANGE
        // ----------------------------------------------------
        DISPENSE: begin
          dispense   = 1'b1;
          mem_write  = 1'b1;
          next_state = CHANGE;
        end

        // ----------------------------------------------------
        // CHANGE: registra troco e zera crédito
        // change_load=1 → captura (credit - price) em change_out
        // credit_load=1 → credit_reg zera (state=CHANGE)
        // Retorna ao IDLE
        // ----------------------------------------------------
        CHANGE: begin
          change_load = 1'b1;
          credit_load = 1'b1; // credit_reg detecta state=CHANGE e zera
          next_state  = IDLE;
        end

        // ----------------------------------------------------
        // ERROR: crédito insuficiente ou sem estoque
        // error=1 mantido enquanto aguarda cancel
        // cancel (tratado acima) retorna ao IDLE e zera crédito
        // ----------------------------------------------------
        ERROR: begin
          error       = 1'b1;
          change_load = 1'b1; // registra crédito como troco (devolução)
          // next_state permanece ERROR até cancel=1
        end

        // Cobertura defensiva: estado inválido → IDLE
        default: begin
          next_state = IDLE;
        end

      endcase
    end
  end

endmodule
