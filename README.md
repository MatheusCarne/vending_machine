# Controlador de Vending Machine — SystemVerilog

Projeto avaliativo da Residência em Microeletrônica — CI Expert  
Trilha: RTL Design | Módulo: Projeto de Controlador Digital  
**Dupla:** Matheus Carneiro · Raissa Crispim

<div style="display: inline_block;" align="center">

<table>
  <tr>
    <td align="center">
      <a href="https://github.com/MatheusCarne" target="_blank">
        <img src="https://avatars.githubusercontent.com/u/88046644?v=4" width="100px;" alt="Avatar Matheus"/><br>
        <sub>
          <b>Matheus Carneiro</b>
        </sub>
      </a>
    </td>
    <td align="center">
      <a href="https://github.com/raissacrispim" target="_blank">
        <img src="https://avatars.githubusercontent.com/u/269824358?v=4" width="100px;" alt="Avatar raissac"/><br>
        <sub>
          <b>Raissa Crispim</b>
        </sub>
      </a>
    </td>
  </tr>
</table>

</div>
---

## Descrição

Controlador digital de uma vending machine com 4 itens (Café, Água, Suco e Snack) implementado em SystemVerilog. O sistema integra três elementos fundamentais de um design digital síncrono:

- **FSM de Moore** com 6 estados e saídas registradas
- **Memória de dados síncrona** 4×16 bits com preços e estoques
- **Caminho de dados combinacional** separado da unidade de controle

O usuário insere moedas, seleciona um item, confirma a compra e recebe o produto e o troco. Toda a lógica de sequenciamento é implementada pela FSM — não há programa armazenado.

---

## Fluxo da FSM

```
IDLE → COLLECT → CHECK → DISPENSE → CHANGE → IDLE   (fluxo normal)
                        ↘ ERROR → IDLE               (crédito insuficiente ou sem estoque)
```

| Estado | Ação |
|--------|------|
| IDLE | Aguarda inserção de moeda |
| COLLECT | Acumula crédito a cada moeda inserida |
| CHECK | Lê memória e avalia can_sell |
| DISPENSE | Libera item (1 ciclo) e decrementa estoque |
| CHANGE | Registra troco e zera crédito |
| ERROR | Mantém error=1, aguarda cancel |

---

## Itens e Preços

| Endereço | Item | Preço | Estoque inicial |
|----------|------|-------|-----------------|
| 0x0 | Café | R$0,25 | 5 |
| 0x1 | Água | R$0,50 | 5 |
| 0x2 | Suco | R$0,75 | 3 |
| 0x3 | Snack | R$1,00 | 2 |

---

## Estrutura do Repositório

```
grupo_MR_vending/
├── rtl/
│   ├── vending_pkg.sv     # Package: tipos, parâmetros e função coin_to_cents
│   ├── credit_reg.sv      # Registrador de crédito síncrono 8 bits
│   ├── memory.sv          # Memória síncrona 4×16 bits (price + stock)
│   ├── comparator.sv      # Lógica combinacional: can_sell
│   ├── subtractor.sv      # Lógica combinacional: change = credit - price
│   ├── control_unit.sv    # FSM de Moore — 6 estados
│   └── vending_top.sv     # Top-level: instancia e interconecta todos os módulos
├── sim/
│   └── tb_vending.sv      # Testbench self-checking — 4 cenários obrigatórios
└── synth/
    ├── synth.tcl           # Script de síntese — Synopsys Design Compiler
    ├── vending.sdc         # Constraints de timing (clock 50 MHz, I/O delays 3 ns)
    ├── vending_top_netlist.v
    └── reports/
        ├── area.rpt        # Relatório de área hierárquica
        ├── timing.rpt      # Relatório de timing e caminho crítico
        ├── power.rpt       # Relatório de potência
        ├── check_design.rpt
        └── violations.rpt  # Violações de constraints
```

---

## Como Compilar e Simular

```bash
# Compilar todos os módulos RTL
vcs -sverilog \
    rtl/vending_pkg.sv \
    rtl/credit_reg.sv \
    rtl/memory.sv \
    rtl/comparator.sv \
    rtl/subtractor.sv \
    rtl/control_unit.sv \
    rtl/vending_top.sv \
    sim/tb_vending.sv \
    -o sim_tb

# Simular
./sim_tb

# Simular com geração de waveform para o DVE
vcs -sverilog -debug_all rtl/*.sv sim/tb_vending.sv -o sim_tb
./sim_tb -gui
```

## Como Sintetizar

```bash
# A partir da raiz do projeto
dc_shell -f synth/synth.tcl | tee synth/synth.log
```

---

## Resultado da Simulação

```
============================================
  Testbench Vending Machine - Iniciando
============================================

--- Cenario 1: Compra bem-sucedida com troco ---
[PASS] C1 dispense=1:    esperado=1   obtido=1
[PASS] C1 change_out=75: esperado=75  obtido=75
[PASS] C1 credit=0:      esperado=0   obtido=0

--- Cenario 2: Credito insuficiente ---
[PASS] C2 error=1:       esperado=1   obtido=1
[PASS] C2 state=ERROR:   esperado=5   obtido=5

--- Cenario 3: Cancelamento ---
[PASS] C3 change_out=200: esperado=200 obtido=200
[PASS] C3 credit=0:       esperado=0   obtido=0
[PASS] C3 state=IDLE:     esperado=0   obtido=0

--- Cenario 4: Estoque zerado ---
[PASS] C4 error=1 stock=0: esperado=1 obtido=1

============================================
  Resultado: 9 PASS | 0 FAIL
  SIMULACAO CONCLUIDA COM SUCESSO
============================================
```

---

## Resultados de Síntese — SAED32 RVT (50 MHz)

| Métrica | Valor |
|---------|-------|
| Área total | 1017.34 µm² |
| Área combinacional | 517.69 µm² |
| Área sequencial | 499.65 µm² |
| Slack do caminho crítico | 13.34 ns (MET) |
| Frequência máxima estimada | > 200 MHz |
| Potência de leakage | 120.37 mW |

### Distribuição de área por módulo

| Módulo | Área (µm²) | % do total |
|--------|-----------|------------|
| `u_memory` | 560.90 | 55.1% |
| `u_credit` | 141.56 | 13.9% |
| `u_control` | 84.12 | 8.3% |
| `u_subtractor` | 54.90 | 5.4% |
| `u_comparator` | 39.90 | 3.9% |
| Lógica local top | 135.97 | 13.4% |

### Caminho crítico

```
cancel → u_control/INVX0_RVT → u_control/AND4X1_RVT → dispense
Atraso total: 3.16 ns | Slack: 13.34 ns
```

---

## Tecnologias

| Ferramenta | Uso |
|------------|-----|
| SystemVerilog (IEEE 1800-2012) | Linguagem de descrição de hardware |
| Synopsys VCS X-2025.06-SP2 | Compilação e simulação |
| Synopsys Verdi | Depuração de waveforms (DVE) |
| Synopsys Design Compiler X-2025.06-SP2 | Síntese lógica |
| SAED32 RVT (tt1p05v25c) | Biblioteca de células padrão |
| Git + GitHub | Controle de versão |
