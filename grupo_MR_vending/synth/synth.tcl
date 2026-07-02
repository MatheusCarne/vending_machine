# ============================================================
# synth.tcl
# Script de síntese — Synopsys Design Compiler
#
# Etapas:
#   1. Configurar bibliotecas
#   2. Analisar e elaborar o RTL
#   3. Ler constraints (vending.sdc)
#   4. Verificar design
#   5. Sintetizar
#   6. Gerar relatórios
#   7. Exportar netlist
# ============================================================

# ------------------------------------------------------------
# 1. Bibliotecas
# Caminho conforme a biblioteca disponível no lab
# ------------------------------------------------------------
source synth/.synopsys_dc.setup

# ------------------------------------------------------------
# 2. Analisar os arquivos RTL (ordem de dependência)
# ------------------------------------------------------------
analyze -format sverilog rtl/vending_pkg.sv
analyze -format sverilog rtl/credit_reg.sv
analyze -format sverilog rtl/memory.sv
analyze -format sverilog rtl/comparator.sv
analyze -format sverilog rtl/subtractor.sv
analyze -format sverilog rtl/control_unit.sv
analyze -format sverilog rtl/vending_top.sv

# ------------------------------------------------------------
# 3. Elaborar o design — define o módulo de topo
# ------------------------------------------------------------
elaborate vending_top
link

# ------------------------------------------------------------
# 4. Ler constraints de timing
# ------------------------------------------------------------
read_sdc synth/vending.sdc

# ------------------------------------------------------------
# 5. Verificar design — corrigir erros antes de sintetizar
# ------------------------------------------------------------
check_design
redirect synth/reports/check_design.rpt { check_design }

# ------------------------------------------------------------
# 6. Sintetizar
# ------------------------------------------------------------
compile_ultra -no_autoungroup

# ------------------------------------------------------------
# 7. Gerar relatórios
# ------------------------------------------------------------
redirect synth/reports/area.rpt       { report_area -hierarchy }
redirect synth/reports/timing.rpt     { report_timing -max_paths 10 }
redirect synth/reports/power.rpt      { report_power }
redirect synth/reports/violations.rpt { report_constraint -all_violators }

puts "Relatórios salvos em reports/"

# ------------------------------------------------------------
# 8. Exportar netlist sintetizada
# ------------------------------------------------------------
write -format verilog -hierarchy -output synth/vending_top_netlist.v
write -format ddc     -hierarchy -output synth/vending_syn.ddc

puts "Netlist exportada: reports/vending_top_netlist.v"
puts "Síntese concluída com sucesso."
