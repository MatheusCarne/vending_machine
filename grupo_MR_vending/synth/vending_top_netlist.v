/////////////////////////////////////////////////////////////
// Created by: Synopsys DC Ultra(TM) in wire load mode
// Version   : X-2025.06-SP2
// Date      : Fri Jul  3 16:07:03 2026
/////////////////////////////////////////////////////////////


module control_unit ( clk, rst, coin_in, confirm, cancel, can_sell, 
        credit_load, mem_read, mem_write, change_load, dispense, error, 
        state_out );
  input [1:0] coin_in;
  output [2:0] state_out;
  input clk, rst, confirm, cancel, can_sell;
  output credit_load, mem_read, mem_write, change_load, dispense, error;
  wire   mem_write, mem_data_valid, N17, n23, n24, n25, n1, n2, n3, n4, n5, n6,
         n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20,
         n21, n22, n26;
  assign dispense = mem_write;

  DFFX1_RVT \state_reg_reg[0]  ( .D(n25), .CLK(clk), .Q(state_out[0]), .QN(n21) );
  DFFX1_RVT mem_data_valid_reg ( .D(N17), .CLK(clk), .Q(mem_data_valid), .QN(
        n26) );
  DFFX1_RVT \state_reg_reg[2]  ( .D(n23), .CLK(clk), .Q(state_out[2]), .QN(n20) );
  DFFX1_RVT \state_reg_reg[1]  ( .D(n24), .CLK(clk), .Q(state_out[1]), .QN(n22) );
  INVX0_RVT U3 ( .A(cancel), .Y(n15) );
  AND4X1_RVT U4 ( .A1(state_out[1]), .A2(n21), .A3(n15), .A4(n20), .Y(mem_read) );
  INVX0_RVT U5 ( .A(rst), .Y(n10) );
  NAND2X0_RVT U6 ( .A1(mem_read), .A2(n10), .Y(n9) );
  INVX0_RVT U7 ( .A(n9), .Y(N17) );
  AND4X1_RVT U8 ( .A1(state_out[0]), .A2(state_out[1]), .A3(n15), .A4(n20), 
        .Y(mem_write) );
  AND4X1_RVT U9 ( .A1(state_out[0]), .A2(state_out[2]), .A3(n22), .A4(n15), 
        .Y(error) );
  NAND2X0_RVT U10 ( .A1(state_out[2]), .A2(n22), .Y(n1) );
  NAND2X0_RVT U11 ( .A1(n15), .A2(n1), .Y(change_load) );
  NOR2X0_RVT U12 ( .A1(state_out[1]), .A2(confirm), .Y(n3) );
  OR2X1_RVT U13 ( .A1(coin_in[0]), .A2(coin_in[1]), .Y(n2) );
  NAND4X0_RVT U14 ( .A1(n3), .A2(state_out[0]), .A3(n20), .A4(n2), .Y(n5) );
  NAND3X0_RVT U15 ( .A1(state_out[2]), .A2(n21), .A3(n22), .Y(n4) );
  NAND3X0_RVT U16 ( .A1(n15), .A2(n5), .A3(n4), .Y(credit_load) );
  AND2X1_RVT U17 ( .A1(state_out[0]), .A2(n15), .Y(n7) );
  NAND2X0_RVT U18 ( .A1(confirm), .A2(n20), .Y(n6) );
  NAND3X0_RVT U19 ( .A1(n7), .A2(n22), .A3(n6), .Y(n8) );
  OA22X1_RVT U20 ( .A1(mem_data_valid), .A2(n9), .A3(rst), .A4(n8), .Y(n18) );
  INVX0_RVT U21 ( .A(n18), .Y(n12) );
  AND4X1_RVT U22 ( .A1(n18), .A2(n10), .A3(n15), .A4(n20), .Y(n13) );
  OA21X1_RVT U23 ( .A1(coin_in[0]), .A2(coin_in[1]), .A3(n13), .Y(n11) );
  AO222X1_RVT U24 ( .A1(state_out[0]), .A2(n12), .A3(n21), .A4(n11), .A5(N17), 
        .A6(n18), .Y(n25) );
  AND3X1_RVT U25 ( .A1(state_out[0]), .A2(n13), .A3(n22), .Y(n14) );
  AO221X1_RVT U26 ( .A1(N17), .A2(can_sell), .A3(N17), .A4(n26), .A5(n14), .Y(
        n24) );
  AND3X1_RVT U27 ( .A1(state_out[1]), .A2(n15), .A3(n20), .Y(n17) );
  NAND2X0_RVT U28 ( .A1(can_sell), .A2(n21), .Y(n16) );
  NAND3X0_RVT U29 ( .A1(n18), .A2(n17), .A3(n16), .Y(n19) );
  OAI22X1_RVT U30 ( .A1(rst), .A2(n19), .A3(n18), .A4(n20), .Y(n23) );
endmodule


module credit_reg ( clk, rst, cancel, credit_load, coin_in, state, credit );
  input [1:0] coin_in;
  input [2:0] state;
  output [7:0] credit;
  input clk, rst, cancel, credit_load;
  wire   n7, n8, n9, n10, n11, n12, n13, n14, \intadd_0/B[1] , \intadd_0/B[0] ,
         \intadd_0/CI , \intadd_0/SUM[2] , \intadd_0/SUM[1] ,
         \intadd_0/SUM[0] , \intadd_0/n3 , \intadd_0/n2 , \intadd_0/n1 , n1,
         n2, n3, n4, n5, n6, n15, n16, n17, n18, n19, n20, n21, n22, n23, n24,
         n25, n26, n27, n28, n29, n30, n31, n32;

  DFFX1_RVT \credit_reg[7]  ( .D(n7), .CLK(clk), .Q(credit[7]) );
  DFFX1_RVT \credit_reg[6]  ( .D(n8), .CLK(clk), .Q(credit[6]), .QN(n32) );
  DFFX1_RVT \credit_reg[5]  ( .D(n9), .CLK(clk), .Q(credit[5]) );
  DFFX1_RVT \credit_reg[4]  ( .D(n10), .CLK(clk), .Q(credit[4]) );
  DFFX1_RVT \credit_reg[3]  ( .D(n11), .CLK(clk), .Q(credit[3]) );
  DFFX1_RVT \credit_reg[2]  ( .D(n12), .CLK(clk), .Q(credit[2]) );
  DFFX1_RVT \credit_reg[1]  ( .D(n13), .CLK(clk), .Q(credit[1]) );
  DFFX1_RVT \credit_reg[0]  ( .D(n14), .CLK(clk), .Q(credit[0]) );
  FADDX1_RVT \intadd_0/U4  ( .A(\intadd_0/B[0] ), .B(credit[3]), .CI(
        \intadd_0/CI ), .CO(\intadd_0/n3 ), .S(\intadd_0/SUM[0] ) );
  FADDX1_RVT \intadd_0/U3  ( .A(\intadd_0/B[1] ), .B(credit[4]), .CI(
        \intadd_0/n3 ), .CO(\intadd_0/n2 ), .S(\intadd_0/SUM[1] ) );
  FADDX1_RVT \intadd_0/U2  ( .A(coin_in[1]), .B(credit[5]), .CI(\intadd_0/n2 ), 
        .CO(\intadd_0/n1 ), .S(\intadd_0/SUM[2] ) );
  INVX0_RVT U3 ( .A(coin_in[0]), .Y(n21) );
  OR2X1_RVT U4 ( .A1(n21), .A2(coin_in[1]), .Y(n23) );
  INVX0_RVT U5 ( .A(n23), .Y(\intadd_0/B[0] ) );
  NAND2X0_RVT U6 ( .A1(coin_in[1]), .A2(coin_in[0]), .Y(n24) );
  AO22X1_RVT U7 ( .A1(coin_in[1]), .A2(n21), .A3(\intadd_0/B[0] ), .A4(
        credit[0]), .Y(n16) );
  NAND2X0_RVT U8 ( .A1(n16), .A2(credit[1]), .Y(n15) );
  NAND2X0_RVT U9 ( .A1(n24), .A2(n15), .Y(n19) );
  NAND2X0_RVT U10 ( .A1(credit[2]), .A2(n19), .Y(n18) );
  INVX0_RVT U11 ( .A(n18), .Y(\intadd_0/CI ) );
  NOR3X0_RVT U12 ( .A1(rst), .A2(cancel), .A3(credit_load), .Y(n31) );
  HADDX1_RVT U13 ( .A0(credit[0]), .B0(\intadd_0/B[0] ), .SO(n6) );
  NOR2X0_RVT U14 ( .A1(rst), .A2(cancel), .Y(n1) );
  AND2X1_RVT U15 ( .A1(credit_load), .A2(n1), .Y(n5) );
  INVX0_RVT U16 ( .A(state[1]), .Y(n2) );
  NAND2X0_RVT U17 ( .A1(state[2]), .A2(n2), .Y(n3) );
  OR2X1_RVT U18 ( .A1(n3), .A2(state[0]), .Y(n4) );
  AND2X1_RVT U19 ( .A1(n5), .A2(n4), .Y(n29) );
  AO22X1_RVT U20 ( .A1(credit[0]), .A2(n31), .A3(n6), .A4(n29), .Y(n14) );
  OA21X1_RVT U21 ( .A1(n16), .A2(credit[1]), .A3(n15), .Y(n17) );
  AO22X1_RVT U22 ( .A1(n29), .A2(n17), .A3(credit[1]), .A4(n31), .Y(n13) );
  OA21X1_RVT U23 ( .A1(credit[2]), .A2(n19), .A3(n18), .Y(n20) );
  AO22X1_RVT U24 ( .A1(n29), .A2(n20), .A3(credit[2]), .A4(n31), .Y(n12) );
  AO22X1_RVT U25 ( .A1(n29), .A2(\intadd_0/SUM[0] ), .A3(n31), .A4(credit[3]), 
        .Y(n11) );
  NAND2X0_RVT U26 ( .A1(coin_in[1]), .A2(n21), .Y(n22) );
  NAND2X0_RVT U27 ( .A1(n23), .A2(n22), .Y(\intadd_0/B[1] ) );
  AO22X1_RVT U28 ( .A1(n29), .A2(\intadd_0/SUM[1] ), .A3(n31), .A4(credit[4]), 
        .Y(n10) );
  AO22X1_RVT U29 ( .A1(n29), .A2(\intadd_0/SUM[2] ), .A3(n31), .A4(credit[5]), 
        .Y(n9) );
  INVX0_RVT U30 ( .A(n24), .Y(n27) );
  AO22X1_RVT U31 ( .A1(n27), .A2(n32), .A3(n24), .A4(credit[6]), .Y(n25) );
  HADDX1_RVT U32 ( .A0(\intadd_0/n1 ), .B0(n25), .SO(n26) );
  AO22X1_RVT U33 ( .A1(n29), .A2(n26), .A3(n31), .A4(credit[6]), .Y(n8) );
  AO222X1_RVT U34 ( .A1(n27), .A2(credit[6]), .A3(n27), .A4(\intadd_0/n1 ), 
        .A5(credit[6]), .A6(\intadd_0/n1 ), .Y(n28) );
  HADDX1_RVT U35 ( .A0(credit[7]), .B0(n28), .SO(n30) );
  AO22X1_RVT U36 ( .A1(credit[7]), .A2(n31), .A3(n30), .A4(n29), .Y(n7) );
endmodule


module memory ( clk, rst, sel_item, mem_read, mem_write, price, stock );
  input [1:0] sel_item;
  output [7:0] price;
  output [7:0] stock;
  input clk, rst, mem_read, mem_write;
  wire   \mem[0][7] , \mem[0][6] , \mem[0][5] , \mem[0][4] , \mem[0][3] ,
         \mem[0][2] , \mem[0][1] , \mem[0][0] , \mem[1][7] , \mem[1][6] ,
         \mem[1][5] , \mem[1][4] , \mem[1][3] , \mem[1][2] , \mem[1][1] ,
         \mem[1][0] , \mem[2][7] , \mem[2][6] , \mem[2][5] , \mem[2][4] ,
         \mem[2][3] , \mem[2][2] , \mem[2][1] , \mem[2][0] , \mem[3][7] ,
         \mem[3][6] , \mem[3][5] , \mem[3][4] , \mem[3][3] , \mem[3][2] ,
         \mem[3][1] , \mem[3][0] , n26, n27, n28, n29, n30, n31, n32, n33, n34,
         n35, n36, n37, n38, n39, n40, n41, n42, n43, n44, n45, n46, n47, n48,
         n49, n50, n51, n52, n53, n54, n55, n56, n57, n58, n59, n60, n61, n62,
         n63, n64, n65, n66, n67, n68, n69, n70, n71, n72, n1, n2, n3, n4, n5,
         n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16, n17, n18, n19, n20,
         n21, n22, n23, n24, n25, n73, n74, n75, n76, n77, n78, n79, n80, n81,
         n82, n83, n84, n85, n86, n87, n88, n89, n90, n91, n92, n93, n94, n95,
         n96, n97, n98, n99, n100, n101;

  DFFX1_RVT \mem_reg[0][7]  ( .D(n39), .CLK(clk), .Q(\mem[0][7] ) );
  DFFX1_RVT \mem_reg[0][6]  ( .D(n38), .CLK(clk), .Q(\mem[0][6] ) );
  DFFX1_RVT \mem_reg[0][5]  ( .D(n37), .CLK(clk), .Q(\mem[0][5] ) );
  DFFX1_RVT \mem_reg[0][4]  ( .D(n36), .CLK(clk), .Q(\mem[0][4] ) );
  DFFX1_RVT \mem_reg[0][3]  ( .D(n35), .CLK(clk), .Q(\mem[0][3] ) );
  DFFX1_RVT \mem_reg[0][2]  ( .D(n34), .CLK(clk), .Q(\mem[0][2] ) );
  DFFX1_RVT \mem_reg[0][1]  ( .D(n33), .CLK(clk), .Q(\mem[0][1] ) );
  DFFX1_RVT \mem_reg[0][0]  ( .D(n40), .CLK(clk), .Q(\mem[0][0] ) );
  DFFX1_RVT \mem_reg[1][7]  ( .D(n47), .CLK(clk), .Q(\mem[1][7] ) );
  DFFX1_RVT \mem_reg[1][6]  ( .D(n46), .CLK(clk), .Q(\mem[1][6] ) );
  DFFX1_RVT \mem_reg[1][5]  ( .D(n45), .CLK(clk), .Q(\mem[1][5] ) );
  DFFX1_RVT \mem_reg[1][4]  ( .D(n44), .CLK(clk), .Q(\mem[1][4] ) );
  DFFX1_RVT \mem_reg[1][3]  ( .D(n43), .CLK(clk), .Q(\mem[1][3] ) );
  DFFX1_RVT \mem_reg[1][2]  ( .D(n42), .CLK(clk), .Q(\mem[1][2] ) );
  DFFX1_RVT \mem_reg[1][1]  ( .D(n41), .CLK(clk), .Q(\mem[1][1] ) );
  DFFX1_RVT \mem_reg[1][0]  ( .D(n48), .CLK(clk), .Q(\mem[1][0] ) );
  DFFX1_RVT \mem_reg[2][7]  ( .D(n55), .CLK(clk), .Q(\mem[2][7] ) );
  DFFX1_RVT \mem_reg[2][6]  ( .D(n54), .CLK(clk), .Q(\mem[2][6] ) );
  DFFX1_RVT \mem_reg[2][5]  ( .D(n53), .CLK(clk), .Q(\mem[2][5] ) );
  DFFX1_RVT \mem_reg[2][4]  ( .D(n52), .CLK(clk), .Q(\mem[2][4] ) );
  DFFX1_RVT \mem_reg[2][3]  ( .D(n51), .CLK(clk), .Q(\mem[2][3] ) );
  DFFX1_RVT \mem_reg[2][2]  ( .D(n50), .CLK(clk), .Q(\mem[2][2] ) );
  DFFX1_RVT \mem_reg[2][1]  ( .D(n49), .CLK(clk), .Q(\mem[2][1] ) );
  DFFX1_RVT \mem_reg[2][0]  ( .D(n56), .CLK(clk), .Q(\mem[2][0] ) );
  DFFX1_RVT \mem_reg[3][7]  ( .D(n63), .CLK(clk), .Q(\mem[3][7] ) );
  DFFX1_RVT \stock_reg[7]  ( .D(n64), .CLK(clk), .Q(stock[7]) );
  DFFX1_RVT \mem_reg[3][6]  ( .D(n62), .CLK(clk), .Q(\mem[3][6] ) );
  DFFX1_RVT \stock_reg[6]  ( .D(n65), .CLK(clk), .Q(stock[6]) );
  DFFX1_RVT \mem_reg[3][5]  ( .D(n61), .CLK(clk), .Q(\mem[3][5] ) );
  DFFX1_RVT \stock_reg[5]  ( .D(n66), .CLK(clk), .Q(stock[5]) );
  DFFX1_RVT \mem_reg[3][4]  ( .D(n60), .CLK(clk), .Q(\mem[3][4] ) );
  DFFX1_RVT \stock_reg[4]  ( .D(n67), .CLK(clk), .Q(stock[4]) );
  DFFX1_RVT \mem_reg[3][3]  ( .D(n59), .CLK(clk), .Q(\mem[3][3] ) );
  DFFX1_RVT \stock_reg[3]  ( .D(n68), .CLK(clk), .Q(stock[3]) );
  DFFX1_RVT \mem_reg[3][2]  ( .D(n58), .CLK(clk), .Q(\mem[3][2] ) );
  DFFX1_RVT \stock_reg[2]  ( .D(n69), .CLK(clk), .Q(stock[2]) );
  DFFX1_RVT \mem_reg[3][1]  ( .D(n57), .CLK(clk), .Q(\mem[3][1] ) );
  DFFX1_RVT \stock_reg[1]  ( .D(n70), .CLK(clk), .Q(stock[1]) );
  DFFX1_RVT \mem_reg[3][0]  ( .D(n72), .CLK(clk), .Q(\mem[3][0] ) );
  DFFX1_RVT \stock_reg[0]  ( .D(n71), .CLK(clk), .Q(stock[0]) );
  DFFX1_RVT \price_reg[6]  ( .D(n32), .CLK(clk), .Q(price[6]) );
  DFFX1_RVT \price_reg[5]  ( .D(n31), .CLK(clk), .Q(price[5]) );
  DFFX1_RVT \price_reg[4]  ( .D(n30), .CLK(clk), .Q(price[4]) );
  DFFX1_RVT \price_reg[3]  ( .D(n29), .CLK(clk), .Q(price[3]) );
  DFFX1_RVT \price_reg[2]  ( .D(n28), .CLK(clk), .Q(price[2]) );
  DFFX1_RVT \price_reg[1]  ( .D(n27), .CLK(clk), .Q(price[1]) );
  DFFX1_RVT \price_reg[0]  ( .D(n26), .CLK(clk), .Q(price[0]) );
  INVX0_RVT U3 ( .A(rst), .Y(n83) );
  AND2X1_RVT U4 ( .A1(sel_item[0]), .A2(sel_item[1]), .Y(n95) );
  AO21X1_RVT U5 ( .A1(n95), .A2(mem_write), .A3(rst), .Y(n20) );
  INVX0_RVT U6 ( .A(n20), .Y(n21) );
  MUX41X1_RVT U7 ( .A1(\mem[0][0] ), .A3(\mem[1][0] ), .A2(\mem[2][0] ), .A4(
        \mem[3][0] ), .S0(sel_item[0]), .S1(sel_item[1]), .Y(n22) );
  INVX0_RVT U8 ( .A(n22), .Y(n18) );
  AND2X1_RVT U9 ( .A1(n83), .A2(n20), .Y(n16) );
  AO22X1_RVT U10 ( .A1(\mem[3][0] ), .A2(n21), .A3(n18), .A4(n16), .Y(n72) );
  NOR2X0_RVT U11 ( .A1(rst), .A2(mem_read), .Y(n101) );
  AND2X1_RVT U12 ( .A1(mem_read), .A2(n83), .Y(n100) );
  AO22X1_RVT U13 ( .A1(stock[0]), .A2(n101), .A3(n100), .A4(n22), .Y(n71) );
  MUX41X1_RVT U14 ( .A1(\mem[0][1] ), .A3(\mem[1][1] ), .A2(\mem[2][1] ), .A4(
        \mem[3][1] ), .S0(sel_item[0]), .S1(sel_item[1]), .Y(n1) );
  AO22X1_RVT U15 ( .A1(stock[1]), .A2(n101), .A3(n100), .A4(n1), .Y(n70) );
  MUX41X1_RVT U16 ( .A1(\mem[0][2] ), .A3(\mem[1][2] ), .A2(\mem[2][2] ), .A4(
        \mem[3][2] ), .S0(sel_item[0]), .S1(sel_item[1]), .Y(n15) );
  AO22X1_RVT U17 ( .A1(stock[2]), .A2(n101), .A3(n100), .A4(n15), .Y(n69) );
  MUX41X1_RVT U18 ( .A1(\mem[0][3] ), .A3(\mem[1][3] ), .A2(\mem[2][3] ), .A4(
        \mem[3][3] ), .S0(sel_item[0]), .S1(sel_item[1]), .Y(n13) );
  AO22X1_RVT U19 ( .A1(stock[3]), .A2(n101), .A3(n100), .A4(n13), .Y(n68) );
  MUX41X1_RVT U20 ( .A1(\mem[0][4] ), .A3(\mem[1][4] ), .A2(\mem[2][4] ), .A4(
        \mem[3][4] ), .S0(sel_item[0]), .S1(sel_item[1]), .Y(n10) );
  AO22X1_RVT U21 ( .A1(stock[4]), .A2(n101), .A3(n100), .A4(n10), .Y(n67) );
  MUX41X1_RVT U22 ( .A1(\mem[0][5] ), .A3(\mem[1][5] ), .A2(\mem[2][5] ), .A4(
        \mem[3][5] ), .S0(sel_item[0]), .S1(sel_item[1]), .Y(n7) );
  AO22X1_RVT U23 ( .A1(stock[5]), .A2(n101), .A3(n100), .A4(n7), .Y(n66) );
  MUX41X1_RVT U24 ( .A1(\mem[0][6] ), .A3(\mem[1][6] ), .A2(\mem[2][6] ), .A4(
        \mem[3][6] ), .S0(sel_item[0]), .S1(sel_item[1]), .Y(n4) );
  AO22X1_RVT U25 ( .A1(stock[6]), .A2(n101), .A3(n100), .A4(n4), .Y(n65) );
  MUX41X1_RVT U26 ( .A1(\mem[0][7] ), .A3(\mem[1][7] ), .A2(\mem[2][7] ), .A4(
        \mem[3][7] ), .S0(sel_item[0]), .S1(sel_item[1]), .Y(n2) );
  AO22X1_RVT U27 ( .A1(stock[7]), .A2(n101), .A3(n100), .A4(n2), .Y(n64) );
  INVX0_RVT U28 ( .A(n1), .Y(n19) );
  NAND2X0_RVT U29 ( .A1(n19), .A2(n18), .Y(n17) );
  OR2X1_RVT U30 ( .A1(n17), .A2(n15), .Y(n14) );
  OR2X1_RVT U31 ( .A1(n14), .A2(n13), .Y(n11) );
  OR2X1_RVT U32 ( .A1(n11), .A2(n10), .Y(n8) );
  OR2X1_RVT U33 ( .A1(n8), .A2(n7), .Y(n5) );
  NOR2X0_RVT U34 ( .A1(n5), .A2(n4), .Y(n3) );
  HADDX1_RVT U35 ( .A0(n3), .B0(n2), .SO(n84) );
  AO22X1_RVT U36 ( .A1(\mem[3][7] ), .A2(n21), .A3(n16), .A4(n84), .Y(n63) );
  AO21X1_RVT U37 ( .A1(n5), .A2(n4), .A3(n3), .Y(n85) );
  AO22X1_RVT U38 ( .A1(\mem[3][6] ), .A2(n21), .A3(n16), .A4(n85), .Y(n62) );
  INVX0_RVT U39 ( .A(n5), .Y(n6) );
  AO21X1_RVT U40 ( .A1(n8), .A2(n7), .A3(n6), .Y(n86) );
  AO22X1_RVT U41 ( .A1(\mem[3][5] ), .A2(n21), .A3(n16), .A4(n86), .Y(n61) );
  INVX0_RVT U42 ( .A(n8), .Y(n9) );
  AO21X1_RVT U43 ( .A1(n11), .A2(n10), .A3(n9), .Y(n87) );
  AO22X1_RVT U44 ( .A1(\mem[3][4] ), .A2(n21), .A3(n16), .A4(n87), .Y(n60) );
  INVX0_RVT U45 ( .A(n11), .Y(n12) );
  AO21X1_RVT U46 ( .A1(n14), .A2(n13), .A3(n12), .Y(n88) );
  AO22X1_RVT U47 ( .A1(\mem[3][3] ), .A2(n21), .A3(n16), .A4(n88), .Y(n59) );
  HADDX1_RVT U48 ( .A0(n17), .B0(n15), .SO(n75) );
  INVX0_RVT U49 ( .A(n75), .Y(n23) );
  AO22X1_RVT U50 ( .A1(\mem[3][2] ), .A2(n21), .A3(n16), .A4(n23), .Y(n58) );
  OA21X1_RVT U51 ( .A1(n19), .A2(n18), .A3(n17), .Y(n77) );
  NAND2X0_RVT U52 ( .A1(n77), .A2(n83), .Y(n25) );
  AO22X1_RVT U53 ( .A1(n21), .A2(\mem[3][1] ), .A3(n20), .A4(n25), .Y(n57) );
  INVX0_RVT U54 ( .A(sel_item[0]), .Y(n99) );
  NAND2X0_RVT U55 ( .A1(sel_item[1]), .A2(n99), .Y(n97) );
  INVX0_RVT U56 ( .A(mem_write), .Y(n80) );
  OA21X1_RVT U57 ( .A1(n97), .A2(n80), .A3(n83), .Y(n74) );
  INVX0_RVT U58 ( .A(n74), .Y(n73) );
  NAND2X0_RVT U59 ( .A1(n22), .A2(n83), .Y(n82) );
  AO22X1_RVT U60 ( .A1(n74), .A2(\mem[2][0] ), .A3(n73), .A4(n82), .Y(n56) );
  AND2X1_RVT U61 ( .A1(n83), .A2(n73), .Y(n24) );
  AO22X1_RVT U62 ( .A1(\mem[2][7] ), .A2(n74), .A3(n24), .A4(n84), .Y(n55) );
  AO22X1_RVT U63 ( .A1(\mem[2][6] ), .A2(n74), .A3(n24), .A4(n85), .Y(n54) );
  AO22X1_RVT U64 ( .A1(\mem[2][5] ), .A2(n74), .A3(n24), .A4(n86), .Y(n53) );
  AO22X1_RVT U65 ( .A1(\mem[2][4] ), .A2(n74), .A3(n24), .A4(n87), .Y(n52) );
  AO22X1_RVT U66 ( .A1(\mem[2][3] ), .A2(n74), .A3(n24), .A4(n88), .Y(n51) );
  AO22X1_RVT U67 ( .A1(\mem[2][2] ), .A2(n74), .A3(n24), .A4(n23), .Y(n50) );
  AO22X1_RVT U68 ( .A1(n74), .A2(\mem[2][1] ), .A3(n73), .A4(n25), .Y(n49) );
  INVX0_RVT U69 ( .A(sel_item[1]), .Y(n94) );
  NAND2X0_RVT U70 ( .A1(sel_item[0]), .A2(n94), .Y(n96) );
  OA21X1_RVT U71 ( .A1(n96), .A2(n80), .A3(n83), .Y(n79) );
  INVX0_RVT U72 ( .A(n79), .Y(n76) );
  AO22X1_RVT U73 ( .A1(n79), .A2(\mem[1][0] ), .A3(n76), .A4(n82), .Y(n48) );
  AND2X1_RVT U74 ( .A1(n83), .A2(n76), .Y(n78) );
  AO22X1_RVT U75 ( .A1(\mem[1][7] ), .A2(n79), .A3(n78), .A4(n84), .Y(n47) );
  AO22X1_RVT U76 ( .A1(\mem[1][6] ), .A2(n79), .A3(n78), .A4(n85), .Y(n46) );
  AO22X1_RVT U77 ( .A1(\mem[1][5] ), .A2(n79), .A3(n78), .A4(n86), .Y(n45) );
  AO22X1_RVT U78 ( .A1(\mem[1][4] ), .A2(n79), .A3(n78), .A4(n87), .Y(n44) );
  AO22X1_RVT U79 ( .A1(\mem[1][3] ), .A2(n79), .A3(n78), .A4(n88), .Y(n43) );
  NAND2X0_RVT U80 ( .A1(n75), .A2(n83), .Y(n89) );
  AO22X1_RVT U81 ( .A1(n79), .A2(\mem[1][2] ), .A3(n76), .A4(n89), .Y(n42) );
  INVX0_RVT U82 ( .A(n77), .Y(n91) );
  AO22X1_RVT U83 ( .A1(\mem[1][1] ), .A2(n79), .A3(n78), .A4(n91), .Y(n41) );
  NAND2X0_RVT U84 ( .A1(n99), .A2(n94), .Y(n81) );
  OA21X1_RVT U85 ( .A1(n81), .A2(n80), .A3(n83), .Y(n93) );
  INVX0_RVT U86 ( .A(n93), .Y(n90) );
  AO22X1_RVT U87 ( .A1(n93), .A2(\mem[0][0] ), .A3(n90), .A4(n82), .Y(n40) );
  AND2X1_RVT U88 ( .A1(n83), .A2(n90), .Y(n92) );
  AO22X1_RVT U89 ( .A1(\mem[0][7] ), .A2(n93), .A3(n92), .A4(n84), .Y(n39) );
  AO22X1_RVT U90 ( .A1(\mem[0][6] ), .A2(n93), .A3(n92), .A4(n85), .Y(n38) );
  AO22X1_RVT U91 ( .A1(\mem[0][5] ), .A2(n93), .A3(n92), .A4(n86), .Y(n37) );
  AO22X1_RVT U92 ( .A1(\mem[0][4] ), .A2(n93), .A3(n92), .A4(n87), .Y(n36) );
  AO22X1_RVT U93 ( .A1(\mem[0][3] ), .A2(n93), .A3(n92), .A4(n88), .Y(n35) );
  AO22X1_RVT U94 ( .A1(n93), .A2(\mem[0][2] ), .A3(n90), .A4(n89), .Y(n34) );
  AO22X1_RVT U95 ( .A1(\mem[0][1] ), .A2(n93), .A3(n92), .A4(n91), .Y(n33) );
  AO22X1_RVT U96 ( .A1(sel_item[1]), .A2(n100), .A3(n101), .A4(price[6]), .Y(
        n32) );
  AO22X1_RVT U97 ( .A1(sel_item[0]), .A2(n100), .A3(n101), .A4(price[5]), .Y(
        n31) );
  AO22X1_RVT U98 ( .A1(price[4]), .A2(n101), .A3(n100), .A4(n94), .Y(n30) );
  AO22X1_RVT U99 ( .A1(price[3]), .A2(n101), .A3(n100), .A4(n99), .Y(n29) );
  AO22X1_RVT U100 ( .A1(n95), .A2(n100), .A3(n101), .A4(price[2]), .Y(n28) );
  NAND2X0_RVT U101 ( .A1(n97), .A2(n96), .Y(n98) );
  AO22X1_RVT U102 ( .A1(n100), .A2(n98), .A3(n101), .A4(price[1]), .Y(n27) );
  AO22X1_RVT U103 ( .A1(price[0]), .A2(n101), .A3(n100), .A4(n99), .Y(n26) );
endmodule


module comparator ( credit, price, stock, can_sell );
  input [7:0] credit;
  input [7:0] price;
  input [7:0] stock;
  output can_sell;
  wire   n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, n15, n16
;

  INVX0_RVT U1 ( .A(price[1]), .Y(n3) );
  INVX0_RVT U2 ( .A(credit[0]), .Y(n1) );
  NAND2X0_RVT U3 ( .A1(price[0]), .A2(n1), .Y(n2) );
  AO222X1_RVT U4 ( .A1(credit[1]), .A2(n3), .A3(credit[1]), .A4(n2), .A5(n3), 
        .A6(n2), .Y(n5) );
  INVX0_RVT U5 ( .A(price[2]), .Y(n4) );
  AO222X1_RVT U6 ( .A1(credit[2]), .A2(n5), .A3(credit[2]), .A4(n4), .A5(n5), 
        .A6(n4), .Y(n7) );
  INVX0_RVT U7 ( .A(price[3]), .Y(n6) );
  AO222X1_RVT U8 ( .A1(credit[3]), .A2(n7), .A3(credit[3]), .A4(n6), .A5(n7), 
        .A6(n6), .Y(n9) );
  INVX0_RVT U9 ( .A(price[4]), .Y(n8) );
  AO222X1_RVT U10 ( .A1(credit[4]), .A2(n9), .A3(credit[4]), .A4(n8), .A5(n9), 
        .A6(n8), .Y(n11) );
  INVX0_RVT U11 ( .A(price[5]), .Y(n10) );
  AO222X1_RVT U12 ( .A1(credit[5]), .A2(n11), .A3(credit[5]), .A4(n10), .A5(
        n11), .A6(n10), .Y(n13) );
  INVX0_RVT U13 ( .A(price[6]), .Y(n12) );
  AO222X1_RVT U14 ( .A1(credit[6]), .A2(n13), .A3(credit[6]), .A4(n12), .A5(
        n13), .A6(n12), .Y(n16) );
  OR4X1_RVT U15 ( .A1(stock[3]), .A2(stock[2]), .A3(stock[1]), .A4(stock[0]), 
        .Y(n15) );
  OR4X1_RVT U16 ( .A1(stock[7]), .A2(stock[6]), .A3(stock[5]), .A4(stock[4]), 
        .Y(n14) );
  OA22X1_RVT U17 ( .A1(credit[7]), .A2(n16), .A3(n15), .A4(n14), .Y(can_sell)
         );
endmodule


module subtractor ( credit, price, change );
  input [7:0] credit;
  input [7:0] price;
  output [7:0] change;
  wire   \intadd_1/B[5] , \intadd_1/B[4] , \intadd_1/B[3] , \intadd_1/B[2] ,
         \intadd_1/B[1] , \intadd_1/B[0] , \intadd_1/CI , \intadd_1/SUM[5] ,
         \intadd_1/SUM[4] , \intadd_1/SUM[3] , \intadd_1/SUM[2] ,
         \intadd_1/SUM[1] , \intadd_1/SUM[0] , \intadd_1/n6 , \intadd_1/n5 ,
         \intadd_1/n4 , \intadd_1/n3 , \intadd_1/n2 , \intadd_1/n1 , n1;

  FADDX1_RVT \intadd_1/U7  ( .A(\intadd_1/B[0] ), .B(price[1]), .CI(
        \intadd_1/CI ), .CO(\intadd_1/n6 ), .S(\intadd_1/SUM[0] ) );
  FADDX1_RVT \intadd_1/U6  ( .A(\intadd_1/B[1] ), .B(price[2]), .CI(
        \intadd_1/n6 ), .CO(\intadd_1/n5 ), .S(\intadd_1/SUM[1] ) );
  FADDX1_RVT \intadd_1/U5  ( .A(\intadd_1/B[2] ), .B(price[3]), .CI(
        \intadd_1/n5 ), .CO(\intadd_1/n4 ), .S(\intadd_1/SUM[2] ) );
  FADDX1_RVT \intadd_1/U4  ( .A(\intadd_1/B[3] ), .B(price[4]), .CI(
        \intadd_1/n4 ), .CO(\intadd_1/n3 ), .S(\intadd_1/SUM[3] ) );
  FADDX1_RVT \intadd_1/U3  ( .A(\intadd_1/B[4] ), .B(price[5]), .CI(
        \intadd_1/n3 ), .CO(\intadd_1/n2 ), .S(\intadd_1/SUM[4] ) );
  FADDX1_RVT \intadd_1/U2  ( .A(\intadd_1/B[5] ), .B(price[6]), .CI(
        \intadd_1/n2 ), .CO(\intadd_1/n1 ), .S(\intadd_1/SUM[5] ) );
  INVX0_RVT U1 ( .A(\intadd_1/SUM[2] ), .Y(change[3]) );
  INVX0_RVT U2 ( .A(\intadd_1/SUM[4] ), .Y(change[5]) );
  INVX0_RVT U3 ( .A(\intadd_1/SUM[3] ), .Y(change[4]) );
  INVX0_RVT U4 ( .A(\intadd_1/SUM[1] ), .Y(change[2]) );
  INVX0_RVT U5 ( .A(\intadd_1/SUM[0] ), .Y(change[1]) );
  INVX0_RVT U6 ( .A(\intadd_1/SUM[5] ), .Y(change[6]) );
  INVX0_RVT U7 ( .A(price[0]), .Y(n1) );
  NOR2X0_RVT U8 ( .A1(n1), .A2(credit[0]), .Y(\intadd_1/CI ) );
  XOR2X1_RVT U9 ( .A1(\intadd_1/n1 ), .A2(credit[7]), .Y(change[7]) );
  INVX0_RVT U10 ( .A(credit[1]), .Y(\intadd_1/B[0] ) );
  INVX0_RVT U11 ( .A(credit[2]), .Y(\intadd_1/B[1] ) );
  INVX0_RVT U12 ( .A(credit[3]), .Y(\intadd_1/B[2] ) );
  INVX0_RVT U13 ( .A(credit[4]), .Y(\intadd_1/B[3] ) );
  INVX0_RVT U14 ( .A(credit[5]), .Y(\intadd_1/B[4] ) );
  INVX0_RVT U15 ( .A(credit[6]), .Y(\intadd_1/B[5] ) );
  AO21X1_RVT U16 ( .A1(credit[0]), .A2(n1), .A3(\intadd_1/CI ), .Y(change[0])
         );
endmodule


module vending_top ( clk, rst, coin_in, sel_item, confirm, cancel, dispense, 
        error, change_out, display, state_out );
  input [1:0] coin_in;
  input [1:0] sel_item;
  output [7:0] change_out;
  output [7:0] display;
  output [2:0] state_out;
  input clk, rst, confirm, cancel;
  output dispense, error;
  wire   state_out_0, state_out_2, can_sell, credit_load, mem_read, mem_write,
         change_load, n4, n5, n6, n7, n8, n9, n10, n11, n12, n13, n14, net1689,
         net1690;
  wire   [7:0] credit;
  wire   [7:0] price;
  wire   [7:0] stock;
  wire   [7:0] change;
  wire   SYNOPSYS_UNCONNECTED__0;
  assign state_out[2] = state_out_0;
  assign state_out[0] = state_out_2;

  control_unit u_control ( .clk(clk), .rst(rst), .coin_in(coin_in), .confirm(
        confirm), .cancel(cancel), .can_sell(can_sell), .credit_load(
        credit_load), .mem_read(mem_read), .mem_write(mem_write), 
        .change_load(change_load), .dispense(dispense), .error(error), 
        .state_out({state_out_0, state_out[1], state_out_2}) );
  credit_reg u_credit ( .clk(clk), .rst(rst), .cancel(cancel), .credit_load(
        credit_load), .coin_in(coin_in), .state({state_out_0, state_out[1], 
        state_out_2}), .credit(credit) );
  memory u_memory ( .clk(clk), .rst(rst), .sel_item(sel_item), .mem_read(
        mem_read), .mem_write(mem_write), .price({SYNOPSYS_UNCONNECTED__0, 
        price[6:0]}), .stock(stock) );
  comparator u_comparator ( .credit(credit), .price({net1690, price[6:0]}), 
        .stock(stock), .can_sell(can_sell) );
  subtractor u_subtractor ( .credit(credit), .price({net1689, price[6:0]}), 
        .change(change) );
  DFFX1_RVT \change_out_reg[7]  ( .D(n11), .CLK(clk), .Q(change_out[7]) );
  DFFX1_RVT \change_out_reg[6]  ( .D(n10), .CLK(clk), .Q(change_out[6]) );
  DFFX1_RVT \change_out_reg[5]  ( .D(n9), .CLK(clk), .Q(change_out[5]) );
  DFFX1_RVT \change_out_reg[4]  ( .D(n8), .CLK(clk), .Q(change_out[4]) );
  DFFX1_RVT \change_out_reg[3]  ( .D(n7), .CLK(clk), .Q(change_out[3]) );
  DFFX1_RVT \change_out_reg[2]  ( .D(n6), .CLK(clk), .Q(change_out[2]) );
  DFFX1_RVT \change_out_reg[1]  ( .D(n5), .CLK(clk), .Q(change_out[1]) );
  DFFX1_RVT \change_out_reg[0]  ( .D(n4), .CLK(clk), .Q(change_out[0]) );
  DFFSSRX1_RVT \display_reg[7]  ( .D(1'b0), .SETB(rst), .RSTB(credit[7]), 
        .CLK(clk), .Q(display[7]) );
  DFFSSRX1_RVT \display_reg[1]  ( .D(1'b0), .SETB(rst), .RSTB(credit[1]), 
        .CLK(clk), .Q(display[1]) );
  DFFSSRX1_RVT \display_reg[2]  ( .D(1'b0), .SETB(rst), .RSTB(credit[2]), 
        .CLK(clk), .Q(display[2]) );
  DFFSSRX1_RVT \display_reg[0]  ( .D(1'b0), .SETB(rst), .RSTB(credit[0]), 
        .CLK(clk), .Q(display[0]) );
  DFFSSRX1_RVT \display_reg[6]  ( .D(1'b0), .SETB(rst), .RSTB(credit[6]), 
        .CLK(clk), .Q(display[6]) );
  DFFSSRX1_RVT \display_reg[5]  ( .D(1'b0), .SETB(rst), .RSTB(credit[5]), 
        .CLK(clk), .Q(display[5]) );
  DFFSSRX1_RVT \display_reg[4]  ( .D(1'b0), .SETB(rst), .RSTB(credit[4]), 
        .CLK(clk), .Q(display[4]) );
  DFFSSRX1_RVT \display_reg[3]  ( .D(1'b0), .SETB(rst), .RSTB(credit[3]), 
        .CLK(clk), .Q(display[3]) );
  INVX0_RVT U22 ( .A(rst), .Y(n12) );
  NOR2X0_RVT U31 ( .A1(rst), .A2(change_load), .Y(n14) );
  AND2X1_RVT U32 ( .A1(change_load), .A2(n12), .Y(n13) );
  AO22X1_RVT U33 ( .A1(n14), .A2(change_out[7]), .A3(n13), .A4(change[7]), .Y(
        n11) );
  AO22X1_RVT U34 ( .A1(n14), .A2(change_out[6]), .A3(n13), .A4(change[6]), .Y(
        n10) );
  AO22X1_RVT U35 ( .A1(n14), .A2(change_out[5]), .A3(n13), .A4(change[5]), .Y(
        n9) );
  AO22X1_RVT U36 ( .A1(n14), .A2(change_out[4]), .A3(n13), .A4(change[4]), .Y(
        n8) );
  AO22X1_RVT U37 ( .A1(n14), .A2(change_out[3]), .A3(n13), .A4(change[3]), .Y(
        n7) );
  AO22X1_RVT U38 ( .A1(n14), .A2(change_out[2]), .A3(n13), .A4(change[2]), .Y(
        n6) );
  AO22X1_RVT U39 ( .A1(n14), .A2(change_out[1]), .A3(n13), .A4(change[1]), .Y(
        n5) );
  AO22X1_RVT U40 ( .A1(n14), .A2(change_out[0]), .A3(n13), .A4(change[0]), .Y(
        n4) );
endmodule

