// ============================================================
// memory.sv
// Memória síncrona 4×16 bits — preços e estoques dos 4 itens
//
// Organização de cada posição (16 bits):
//   [15:8] = price[7:0]  → preço em centavos (fixo, nunca escrito)
//   [7:0]  = stock[7:0]  → estoque disponível (decrementado a cada venda)
//
// Endereçamento: sel_item[1:0] → 0=Café, 1=Água, 2=Suco, 3=Snack
//
// Leitura síncrona:  mem_read=1  → price e stock disponíveis no ciclo seguinte
// Escrita síncrona:  mem_write=1 → stock ← stock - 1 no endereço sel_item
//
// Inicialização via initial begin (valores da especificação):
//   0x0: Café  — price=25,  stock=5
//   0x1: Água  — price=50,  stock=5
//   0x2: Suco  — price=75,  stock=3
//   0x3: Snack — price=100, stock=2
// ============================================================

import vending_pkg::*;

module memory (
  input  logic                     clk,
  input  logic                     rst,
  input  logic [ADDR_WIDTH-1:0]    sel_item,   // endereço: 0..3
  input  logic                     mem_read,   // habilita leitura síncrona
  input  logic                     mem_write,  // habilita escrita (decrementa stock)
  output logic [DATA_WIDTH-1:0]    price,      // preço do item lido (centavos)
  output logic [DATA_WIDTH-1:0]    stock       // estoque do item lido
);

  // ----------------------------------------------------------
  // Array de memória: 4 posições de 16 bits
  // mem[addr][15:8] = price | mem[addr][7:0] = stock
  // ----------------------------------------------------------
  logic [MEM_WIDTH-1:0] mem [0:NUM_ITEMS-1];

  // ----------------------------------------------------------
  // Inicialização com valores da especificação
  // Feita via initial (sintetizável com DC usando init_reg)
  // ----------------------------------------------------------
  initial begin
    mem[0] = {PRICE_CAFE,  STOCK_CAFE};   // {8'd25,  8'd5}
    mem[1] = {PRICE_AGUA,  STOCK_AGUA};   // {8'd50,  8'd5}
    mem[2] = {PRICE_SUCO,  STOCK_SUCO};   // {8'd75,  8'd3}
    mem[3] = {PRICE_SNACK, STOCK_SNACK};  // {8'd100, 8'd2}
  end

  // ----------------------------------------------------------
  // Lógica síncrona: leitura e escrita na borda de subida
  // Prioridade: rst > mem_write > mem_read
  // ----------------------------------------------------------
  always_ff @(posedge clk) begin
    if (rst) begin
      // Reset: restaura todos os estoques e preços aos valores iniciais
      mem[0] <= {PRICE_CAFE,  STOCK_CAFE};
      mem[1] <= {PRICE_AGUA,  STOCK_AGUA};
      mem[2] <= {PRICE_SUCO,  STOCK_SUCO};
      mem[3] <= {PRICE_SNACK, STOCK_SNACK};
      price  <= 8'd0;
      stock  <= 8'd0;

    end else begin
      // Escrita: decrementa stock do item selecionado (ativado em DISPENSE)
      // Só altera o campo stock [7:0]; price [15:8] permanece intacto
      if (mem_write) begin
        mem[sel_item][7:0] <= mem[sel_item][7:0] - 8'd1;
      end

      // Leitura: captura price e stock do item selecionado (ativado em CHECK)
      // Resultado disponível no ciclo seguinte (leitura síncrona)
      if (mem_read) begin
        price <= mem[sel_item][15:8];
        stock <= mem[sel_item][7:0];
      end
    end
  end

endmodule

