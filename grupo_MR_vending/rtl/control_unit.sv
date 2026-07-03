// ============================================================
// control_unit.sv — FSM de Moore com 6 estados
// ============================================================

module control_unit
  import vending_pkg::*;
(
  input  logic       clk,
  input  logic       rst,
  input  logic [1:0] coin_in,
  input  logic       confirm,
  input  logic       cancel,
  input  logic       can_sell,
  output logic       credit_load,
  output logic       mem_read,
  output logic       mem_write,
  output logic       change_load,
  output logic       dispense,
  output logic       error,
  output state_t     state_out
);

  state_t state_reg, next_state;

  // Registrador auxiliar: indica que mem_read foi ativado
  // no ciclo anterior — price/stock agora são válidos
  logic mem_data_valid;

  assign state_out = state_reg;

  // Bloco 1: transição de estados
  always_ff @(posedge clk) begin
    if (rst) begin
      state_reg      <= IDLE;
      mem_data_valid <= 1'b0;
    end else begin
      state_reg      <= next_state;
      mem_data_valid <= mem_read; // valid um ciclo após mem_read=1
    end
  end

  // Bloco 2: lógica de saídas e próximo estado
  always_comb begin
    next_state  = state_reg;
    credit_load = 1'b0;
    mem_read    = 1'b0;
    mem_write   = 1'b0;
    change_load = 1'b0;
    dispense    = 1'b0;
    error       = 1'b0;

    if (cancel) begin
      next_state  = IDLE;
      credit_load = 1'b1; // zera crédito
      change_load = 1'b1; // registra crédito como troco (devolução)
    end else begin
      case (state_reg)

        IDLE: begin
          if (coin_in != 2'b00)
            next_state = COLLECT;
        end

        COLLECT: begin
          if (confirm)
            next_state = CHECK;
          else if (coin_in != 2'b00)
            credit_load = 1'b1;
        end

        // CHECK fica 2 ciclos:
        // Ciclo 1: ativa mem_read → memória latcha price/stock
        // Ciclo 2: mem_data_valid=1 → avalia can_sell e transiciona
        CHECK: begin
          mem_read = 1'b1;
          if (mem_data_valid) begin
            if (can_sell)
              next_state = DISPENSE;
            else
              next_state = ERROR;
          end
          // else: permanece em CHECK aguardando dados da memória
        end

        DISPENSE: begin
          dispense   = 1'b1;
          mem_write  = 1'b1;
          next_state = CHANGE;
        end

        CHANGE: begin
          change_load = 1'b1;
          credit_load = 1'b1;
          next_state  = IDLE;
        end

        ERROR: begin
          error       = 1'b1;
          change_load = 1'b1;
        end

        default: next_state = IDLE;

      endcase
    end
  end

endmodule
