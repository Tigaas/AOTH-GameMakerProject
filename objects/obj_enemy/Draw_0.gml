// Primeiro desenha o sprite do inimigo normalmente
draw_self();

// Agora desenha a barra de vida
if (show_hpbar)
{
    var bar_w = 30;   // largura da barra
    var bar_h = 1;    // altura da barra

    var offset_y = -sprite_height - 10; // coloca acima da cabeça (ajuste o -5 se quiser mais pra cima)
    
    var xx = x - bar_w / 2;
    var yy = y + offset_y;

    // fundo da barra
    draw_set_color(c_black);
    draw_rectangle(xx - 1, yy - 1, xx + bar_w + 1, yy + bar_h + 1, false);

    // porcentagem da vida
    var hp_percent = hp / hp_max;

    // barra preenchida
    draw_set_color(c_red);
    draw_rectangle(xx, yy, xx + (bar_w * hp_percent), yy + bar_h, false);
}
