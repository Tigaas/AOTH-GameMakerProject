// =========================================================
// ================= EXECUÇÃO DO DASH =======================
// =========================================================
if (is_dashing)
{
    // DASH COM COLISÃO — NÃO ATRAVESSA PAREDE
    var steps = dash_speed;
    var step_x = dash_dir_x;
    var step_y = dash_dir_y;

    // Se dash_dir for zero (por segurança), usa last_dir na horizontal
    if (step_x == 0 && step_y == 0)
    {
        step_x = last_dir;
    }

    repeat (steps)
    {
        // mover horizontal
        x += step_x;
        if (place_meeting(x, y, obj_solid))
        {
            x -= step_x; 
        }

        // mover vertical
        y += step_y;
        if (place_meeting(x, y, obj_solid))
        {
            y -= step_y; 
        }
    }

    // animação do roll
    sprite_index = spr_player_roll;
    image_speed = 1;
    image_xscale = last_dir * scale;

    dash_timer--;

    if (dash_timer <= 0)
    {
        is_dashing = false;
        image_speed = 0;
        image_index = 0;

        switch (facing)
        {
            case "right":
            case "left": sprite_index = spr_player; break;
            case "up":    sprite_index = spr_player_cima; break;
            case "down":  sprite_index = spr_player_baixo; break;
        }
    }

    // após o dash, pro caso de acabar em cima do sólido, passa pela correção abaixo
    // (não damos exit aqui pra que a correção "anti-stuck" rode)
}


// ==========================================
//  EMPURRAR PLAYER PARA FORA DA PAREDE (FORTE)
// ==========================================
var safety = 8; // máximo de pixels a corrigir (pode aumentar se quiser)

if (place_meeting(x, y, obj_solid))
{
    // tenta empurrar em todas as direções com prioridade horizontal/vertical
    var pushed = false;

    for (var i = 0; i < safety && !pushed; i++)
    {
        // tenta direita
        if (!place_meeting(x + 1, y, obj_solid)) { x += 1; pushed = true; break; }
        // tenta esquerda
        if (!place_meeting(x - 1, y, obj_solid)) { x -= 1; pushed = true; break; }
        // tenta baixo
        if (!place_meeting(x, y + 1, obj_solid)) { y += 1; pushed = true; break; }
        // tenta cima
        if (!place_meeting(x, y - 1, obj_solid)) { y -= 1; pushed = true; break; }

        // se nenhuma direc. liberou 1 px, tenta expandir (2 px, 3 px, ...)
        for (var j = 2; j <= i+1 && !pushed; j++)
        {
            if (!place_meeting(x + j, y, obj_solid)) { x += j; pushed = true; break; }
            if (!place_meeting(x - j, y, obj_solid)) { x -= j; pushed = true; break; }
            if (!place_meeting(x, y + j, obj_solid)) { y += j; pushed = true; break; }
            if (!place_meeting(x, y - j, obj_solid)) { y -= j; pushed = true; break; }
        }
    }

    // se ainda preso após safety, tenta empurrar de forma direcional baseada em facing/last_dir
    if (place_meeting(x, y, obj_solid))
    {
        // força um push baseado no last_dir (horizontal) ou facing vertical
        if (last_dir != 0 && !place_meeting(x + last_dir, y, obj_solid)) x += last_dir;
        else if (facing == "up" && !place_meeting(x, y - 1, obj_solid)) y -= 1;
        else if (facing == "down" && !place_meeting(x, y + 1, obj_solid)) y += 1;
    }
}



// ---------------------------------------------------------
// FUNÇÃO LOCAL: gastar stamina
// ---------------------------------------------------------
function stamina_spend(amount) {
    stamina = max(0, stamina - amount);
    stamina_delay_timer = stamina_delay;
}



// =========================================================
// ===================== MOVIMENTO =========================
// =========================================================
if (!is_attacking && !is_dashing)
{
    move_x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    move_y = keyboard_check(ord("S")) - keyboard_check(ord("W"));

    if (move_x != 0 || move_y != 0) {
        var len = point_distance(0, 0, move_x, move_y);
        move_x /= len;
        move_y /= len;
    }

    // DASH (início)
    if (keyboard_check_pressed(vk_space) && stamina >= stamina_roll_cost)
    {
        stamina_spend(stamina_roll_cost);

        is_dashing = true;
        dash_timer = dash_duration;

        sprite_index = spr_player_roll;
        image_speed = 1;

        if (move_x == 0 && move_y == 0)
        {
            switch (facing)
            {
                case "right": move_x = 1; break;
                case "left":  move_x = -1; break;
                case "up":    move_y = -1; break;
                case "down":  move_y = 1; break;
            }
        }

        dash_dir_x = move_x;
        dash_dir_y = move_y;

        if (dash_dir_x < 0) last_dir = -1;
        if (dash_dir_x > 0) last_dir = 1;

        image_xscale = (dash_dir_x != 0 ? scale * last_dir : scale);

        exit;
    }


    // MOVIMENTO (somente registra, colisão aplica depois)
    h = move_x * move_speed;
    v = move_y * move_speed;

    // FACING
    if (move_x != 0 || move_y != 0)
    {
        if (abs(move_x) > abs(move_y))
        {
            facing = (move_x > 0) ? "right" : "left";
            last_dir = (move_x > 0) ? 1 : -1;
        }
        else
        {
            facing = (move_y > 0) ? "down" : "up";
        }
    }

    // SPRITES MOVIMENTO
    if (move_x != 0 || move_y != 0)
    {
        image_speed = 1;

        switch (facing)
        {
            case "right":
            case "left":  sprite_index = spr_player_andando; break;
            case "up":    sprite_index = spr_player_andando_cima; break;
            case "down":  sprite_index = spr_player_andando_baixo; break;
        }
    }
    else
    {
        image_speed = 0;
        image_index = 0;

        switch (facing)
        {
            case "right":
            case "left": sprite_index = spr_player; break;
            case "up":   sprite_index = spr_player_cima; break;
            case "down": sprite_index = spr_player_baixo; break;
        }
    }

    image_xscale = (facing == "left") ? -scale : scale;

    // CORRER
    var running = keyboard_check(vk_shift) && (move_x != 0 || move_y != 0);

    if (running && stamina > 0)
    {
        move_speed = 2;
        stamina_spend(stamina_run_cost);

        h = move_x * move_speed;
        v = move_y * move_speed;
    }
    else move_speed = 1;
}



// =========================================================
// ===================== STAMINA REGEN =====================
// =========================================================
if (!is_dashing && !is_attacking && !(keyboard_check(vk_shift) && (move_x != 0 || move_y != 0)))
{
    if (stamina_delay_timer > 0)
        stamina_delay_timer--;
    else
        stamina = min(stamina_max, stamina + stamina_regen);
}



// =========================================================
// ========================= ATAQUE ========================
// =========================================================
if (!is_dashing && !is_attacking && stamina >= attack_stamina_cost)
{
    if (mouse_check_button_pressed(mb_left))
    {
        is_attacking = true;
        attack_timer = attack_time;

        stamina_spend(attack_stamina_cost);

        attack_facing = facing;

        var hb = instance_create_layer(x, y, "Instances", obj_hitbox_player_attack);
        hb.attack_dir = attack_facing;
        hb.owner = id;

        switch (attack_facing)
        {
            case "up":    sprite_index = spr_player_atacando_cima;      break;
            case "down":  sprite_index = spr_player_atacando_baixo;     break;
            case "right": sprite_index = spr_player_atacando; image_xscale = scale;  break;
            case "left":  sprite_index = spr_player_atacando; image_xscale = -scale; break;
        }

        image_speed = 1;
    }
}



// =========================================================
// ================= LÓGICA DO ATAQUE ======================
// =========================================================
if (is_attacking)
{
    attack_timer--;

    h = 0;
    v = 0;

    if (attack_timer <= 0)
    {
        is_attacking = false;
        image_speed = 0;

        switch (facing)
        {
            case "right":
            case "left": sprite_index = spr_player; break;
            case "up":    sprite_index = spr_player_cima; break;
            case "down":  sprite_index = spr_player_baixo; break;
        }
    }
}



// =========================================================
// ====================== COLISÃO FINAL ====================
// =========================================================

// ======= COLISÃO COM OBJ_SÓLIDO (normal, não dash) =======
if (!is_dashing)
{
    // horizontal
    x += h;

    if (place_meeting(x, y, obj_solid))
    {
        // calcula direção de saída (fallback para last_dir se h == 0)
        var sx = sign(h);
        if (sx == 0) sx = last_dir != 0 ? last_dir : 1;

        var safe = 0;
        while (place_meeting(x, y, obj_solid) && safe < 32)
        {
            x -= sx;
            safe++;
        }
        h = 0;
    }

    // vertical
    y += v;

    if (place_meeting(x, y, obj_solid))
    {
        var sy = sign(v);
        if (sy == 0) sy = (facing == "up") ? -1 : (facing == "down" ? 1 : 1);

        var safe2 = 0;
        while (place_meeting(x, y, obj_solid) && safe2 < 32)
        {
            y -= sy;
            safe2++;
        }
        v = 0;
    }
}



// ======= COLISÃO COM INIMIGO (empurrar) =======
if (!is_dashing)
{
    var e = instance_place(x, y, obj_enemy);

    if (e != noone)
    {
        var ang = point_direction(e.x, e.y, x, y);

        x += lengthdir_x(4, ang);
        y += lengthdir_y(4, ang);
    }
}
