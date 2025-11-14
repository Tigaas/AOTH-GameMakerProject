// fundo
draw_set_color(c_black);
draw_rectangle(20, 20, 220, 35, false);

// barra
var p = stamina / stamina_max;

draw_set_color(c_lime);
draw_rectangle(20, 20, 20 + p * 200, 35, false);
