// =========================================================
// ================= EXECUÇÃO DO DASH =======================
// =========================================================
if (is_dashing)
{
    // Aplicar movimento do roll
    x += dash_dir_x * dash_speed;
    y += dash_dir_y * dash_speed;

    // Animação do roll
    sprite_index = spr_player_roll;
    image_speed = 1;
    image_xscale = last_dir * scale;

    dash_timer--;

    // termina o roll
    if (dash_timer <= 0)
    {
        is_dashing = false;
        image_speed = 0;
        image_index = 0;

        // volta para idle correto
        switch (facing)
        {
            case "right":
            case "left": sprite_index = spr_player; break;
            case "up":    sprite_index = spr_player_cima; break;
            case "down":  sprite_index = spr_player_baixo; break;
        }
    }

    exit; // ← ESSENCIAL
}


// ---------------------------------------------------------
// FUNÇÃO LOCAL: gastar stamina
// ---------------------------------------------------------
function stamina_spend(amount) {
    stamina = max(0, stamina - amount);
    stamina_delay_timer = stamina_delay; // delay souls-like
}



// =========================================================
// ===================== MOVIMENTO =========================
// =========================================================
if (!is_attacking && !is_dashing)
{
    // ------------------------------
    // INPUT
    // ------------------------------
    move_x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    move_y = keyboard_check(ord("S")) - keyboard_check(ord("W"));

    // Normaliza movimento diagonal
    if (move_x != 0 || move_y != 0) {
        var len = point_distance(0, 0, move_x, move_y);
        move_x /= len;
        move_y /= len;
    }


    // -----------------------------------------------------
    // DASH / ROLL
    // -----------------------------------------------------
    if (keyboard_check_pressed(vk_space) && stamina >= stamina_roll_cost)
    {
        stamina_spend(stamina_roll_cost);

        is_dashing = true;
        dash_timer = dash_duration;

        sprite_index = spr_player_roll;
        image_speed = 1;

        // Se parado → pega direção do facing
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

        // Flip horizontal
        if (dash_dir_x < 0) last_dir = -1;
        if (dash_dir_x > 0) last_dir = 1;

        image_xscale = (dash_dir_x != 0 ? scale * last_dir : scale);
    }


    // -----------------------------------------------------
    // MOVIMENTO NORMAL
    // -----------------------------------------------------
    x += move_x * move_speed;
    y += move_y * move_speed;


    // -----------------------------------------------------
    // ATUALIZA FACING
    // -----------------------------------------------------
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


    // -----------------------------------------------------
    // SISTEMA DE SPRITES DE MOVIMENTO
    // -----------------------------------------------------
    if (move_x != 0 || move_y != 0)
    {
        image_speed = 1;

        switch (facing)
        {
            case "right":
            case "left":
                sprite_index = spr_player_andando;
            break;

            case "up":
                sprite_index = spr_player_andando_cima;
            break;

            case "down":
                sprite_index = spr_player_andando_baixo;
            break;
        }
    }
    else
    {
        image_speed = 0;
        image_index = 0;

        switch (facing)
        {
            case "right":
            case "left":
                sprite_index = spr_player;
            break;

            case "up":
                sprite_index = spr_player_cima;
            break;

            case "down":
                sprite_index = spr_player_baixo;
            break;
        }
    }

    // Flip horizontal
    image_xscale = (facing == "left") ? -scale : scale;


    // -----------------------------------------------------
    // CORRER (consome stamina)
    // -----------------------------------------------------
    var running = keyboard_check(vk_shift) && (move_x != 0 || move_y != 0);

    if (running && stamina > 0)
    {
        move_speed = 2;
        stamina_spend(stamina_run_cost);
    }
    else
        move_speed = 1;
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

        // Volta para a pose parada correta
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

// não regenera enquanto rola
if (is_dashing) { }
// não regenera enquanto ataca
else if (is_attacking) { }
// não regenera enquanto corre
else if (keyboard_check(vk_shift) && (move_x != 0 || move_y != 0)) { }
else
{
    if (stamina_delay_timer > 0)
        stamina_delay_timer--;
    else
        stamina = min(stamina_max, stamina + stamina_regen);
}



// =========================================================
// ========================= ATAQUE ========================
// =========================================================

// Pode atacar?
if (!is_dashing && !is_attacking && stamina >= attack_stamina_cost)
{
    if (mouse_check_button_pressed(mb_left))
    {
        is_attacking = true;
        attack_timer = attack_time;

        stamina_spend(attack_stamina_cost);

        // salva direção do ataque
        attack_facing = facing;

        // ====================================
        // CRIA HITBOX DO ATAQUE
        // ====================================
        var hb = instance_create_layer(x, y, "Instances", obj_hitbox_player_attack);
        hb.attack_dir = attack_facing;
        hb.owner = id;


        switch (attack_facing)
        {
            case "up":
                sprite_index = spr_player_atacando_cima;
            break;

            case "down":
                sprite_index = spr_player_atacando_baixo;
            break;

            case "right":
                sprite_index = spr_player_atacando;
                image_xscale = scale;
            break;

            case "left":
                sprite_index = spr_player_atacando;
                image_xscale = -scale;
            break;
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

    // trava o player estilo Souls
    move_x = 0;
    move_y = 0;

    if (attack_timer <= 0)
    {
        is_attacking = false;
        image_speed = 0;

        // volta ao sprite parado correto
        switch (facing)
        {
            case "right":
            case "left": sprite_index = spr_player; break;
            case "up":    sprite_index = spr_player_cima; break;
            case "down":  sprite_index = spr_player_baixo; break;
        }
    }
	
}
