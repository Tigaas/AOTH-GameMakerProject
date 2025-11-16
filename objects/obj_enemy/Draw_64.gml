if (show_hpbar)
{
    var bar_w = 30;   // largura da barra
    var bar_h = 5;    // altura
    var xx = x - bar_w / 2;
    var yy = y + hpbar_offset;

    // fundo da barra
    draw_set_color(c_black);
    draw_rectangle(xx - 1, yy - 1, xx + bar_w + 1, yy + bar_h + 1, false);

    // vida atual
    var hp_percent = hp / hp_max;
    draw_set_color(c_red);
    draw_rectangle(xx, yy, xx + (bar_w * hp_percent), yy + bar_h, false);
}
