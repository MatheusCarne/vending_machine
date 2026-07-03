// ============================================================
// comparator.sv
// Comparador combinacional — decide se a venda pode ser realizada
//
// Avalia duas condições simultaneamente:
//   Condição 1 — crédito suficiente: credit >= price
//   Condição 2 — item disponível:    stock  >  0
//
// can_sell = 1 somente se AMBAS forem verdadeiras
//
// Por que combinacional e não registrado:
//   A FSM ativa mem_read em CHECK; no ciclo seguinte price e stock
//   já estão nos registradores de saída da memória. O comparador
//   avalia can_sell nesse mesmo ciclo, e a FSM usa o resultado
//   imediatamente para decidir DISPENSE ou ERROR.
//   Não há clock aqui — a saída muda instantaneamente com as entradas.
// ============================================================

module comparator
  import vending_pkg::*;
(
  input  logic [DATA_WIDTH-1:0] credit,
  input  logic [DATA_WIDTH-1:0] price,
  input  logic [DATA_WIDTH-1:0] stock,
  output logic                  can_sell
);

  // ----------------------------------------------------------
  // Lógica combinacional pura — sem clock, sem estado
  //
  // Condição 1: credit >= price
  //   Comparação de magnitude entre dois inteiros de 8 bits sem sinal.
  //   O hardware implementa como subtrator: (credit - price) sem sinal →
  //   se não houve borrow, credit >= price.
  //
  // Condição 2: stock > 0
  //   Redução OR de todos os bits: se qualquer bit for 1, stock != 0.
  //   Equivalente a (stock != 8'b0) mas mais eficiente em área.
  // ----------------------------------------------------------
  assign can_sell = (credit >= price) && (|stock);

endmodule
