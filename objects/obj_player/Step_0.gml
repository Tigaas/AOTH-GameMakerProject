// =========================================================
// ================= EXECUÇÃO DO DASH =======================
// =========================================================
if (is_dashing)
{
    x += dash_dir_x * dash_speed;
    y += dash_dir_y * dash_speed;

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

    exit; 
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

    // DASH
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
    }

    // MOVIMENTO
    x += move_x * move_speed;
    y += move_y * move_speed;

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
    }
    else move_speed = 1;
}



// =========================================================
// ================= EXECUÇÃO do DASH ======================
// =========================================================
if (is_dashing)
{
    x += dash_dir_x * dash_speed;
    y += dash_dir_y * dash_speed;

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

    exit;
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

        // HITBOX DO ATAQUE
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
// ================ LÓGICA DO ATAQUE =======================
// =========================================================
if (is_attacking)
{
    attack_timer--;

    move_x = 0;
    move_y = 0;

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

// ----------- COLISÃO COM OBJETOS SÓLIDOS (paredes etc.) ----------
if (!is_dashing)
{
    // salvamos movimento
    var old_x = x;
    var old_y = y;

    // tenta mover na horizontal
    x = old_x;
    if (instance_place(x, old_y, obj_solid) != noone)
    {
        // empurra para trás até sair
        var safe = 0;
        while (instance_place(x, old_y, obj_solid) != noone && safe < 20)
        {
            x -= sign(move_x);
            safe++;
        }
    }

    // tenta mover na vertical
    y = old_y;
    if (instance_place(old_x, y, obj_solid) != noone)
    {
        var safe2 = 0;
        while (instance_place(old_x, y, obj_solid) != noone && safe2 < 20)
        {
            y -= sign(move_y);
            safe2++;
        }
    }
}


// ----------- COLISÃO COM INIMIGOS (FORA DO DASH) ----------
if (!is_dashing)
{
    var e = instance_place(x, y, obj_enemy);

    if (e != noone)
    {
        var safety = 0;

        // empurra o player para fora do inimigo
        while (instance_place(x, y, obj_enemy) != noone && safety < 20)
        {
            // empurra para longe do inimigo
            var ang = point_direction(e.x, e.y, x, y);
            x += lengthdir_x(1, ang);
            y += lengthdir_y(1, ang);

            safety++;
        }
    }
}


// ----------- SE O DASH ACABAR E VOCÊ FICAR DENTRO DO INIMIGO ----------
if (!is_dashing && !is_attacking)
{
    var inside = instance_place(x, y, obj_enemy);

    if (inside != noone)
    {
        var safety3 = 0;

        while (instance_place(x, y, obj_enemy) != noone && safety3 < 30)
        {
            // empurra para trás conforme a direção do dash anterior
            var ang2 = point_direction(inside.x, inside.y, x, y);

            x += lengthdir_x(1.5, ang2);
            y += lengthdir_y(1.5, ang2);

            safety3++;
        }
    }
}
