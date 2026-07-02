# ============================================================
# vending.sdc
# Constraints de timing — Synopsys Design Compiler
#
# Clock inicial: 20 ns (50 MHz)
# I/O delays:   3 ns entrada e saída
# ============================================================

# ------------------------------------------------------------
# 1. Clock — 20 ns de período (50 MHz)
# ------------------------------------------------------------
create_clock -name clk \
             -period 20 \
             -waveform {0 10} \
             [get_ports clk]

# ------------------------------------------------------------
# 2. Incerteza do clock — modela jitter e skew
# ------------------------------------------------------------
set_clock_uncertainty 0.5 [get_clocks clk]
set_clock_transition  0.1 [get_clocks clk]

# ------------------------------------------------------------
# 3. Input delay — todas as entradas exceto clk
# ------------------------------------------------------------
set_input_delay 3 -clock clk [get_ports {
    rst
    coin_in
    sel_item
    confirm
    cancel
}]

# ------------------------------------------------------------
# 4. Output delay — todas as saídas
# ------------------------------------------------------------
set_output_delay 3 -clock clk [get_ports {
    dispense
    error
    change_out
    display
    state_out
}]

# ------------------------------------------------------------
# 5. Carga e célula de drive
# ------------------------------------------------------------
set_max_fanout 8 [current_design]
set_load      0.05 [all_outputs]


