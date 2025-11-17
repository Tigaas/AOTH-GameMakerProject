/// --- BARRA DE VIDA ---

// fundo
draw_set_color(c_black);
draw_rectangle(20, 20, 220, 35, false); // posição e tamanho iguais à stamina, só que mais abaixo

// porcentagem de vida
var hp_p = hp / hp_max;

// barra de vida
draw_set_color(c_red);
draw_rectangle(20, 20, 20 + hp_p * 200, 35, false);

//---STAMINA-----

// fundo
draw_set_color(c_black);
draw_rectangle(20, 50, 220, 65, false);

// barra
var p = stamina / stamina_max;

draw_set_color(c_lime);
draw_rectangle(20, 50, 20 + p * 200, 65, false);


