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
set lib_path "/Tools/synopsys/libraries/SAED32_EDK/lib/stdcell_rvt/db_nldm"
set target_lib "saed32rvt_tt1p05vn40c.db"

set target_library  "$lib_path/$target_lib"
set link_library    [list "*" "$lib_path/$target_lib"]

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
check_design > reports/check_design.rpt
puts "check_design salvo em reports/check_design.rpt"

# ------------------------------------------------------------
# 6. Sintetizar
# ------------------------------------------------------------
compile_ultra -no_autoungroup

# ------------------------------------------------------------
# 7. Gerar relatórios
# ------------------------------------------------------------
report_area                          > reports/report_area.rpt
report_timing                        > reports/report_timing.rpt
report_power                         > reports/report_power.rpt
report_constraint -all_violators     > reports/report_constraint.rpt

puts "Relatórios salvos em reports/"

# ------------------------------------------------------------
# 8. Exportar netlist sintetizada
# ------------------------------------------------------------
write -format verilog -hierarchy -output reports/vending_top_netlist.v

puts "Netlist exportada: reports/vending_top_netlist.v"
puts "Síntese concluída com sucesso."

