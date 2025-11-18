// =========================================================
// STEP EVENT - OBJ_PLAYER (VERSÃO A2: souls-modern -> desliza)
// =========================================================

// -------------------------
// Função local (coloque aqui para garantir ordem)
// -------------------------
function stamina_spend(amount) {
    stamina = max(0, stamina - amount);
    stamina_delay_timer = stamina_delay;
}

// =========================================================
// 1) INÍCIO DO DASH (PRIORIDADE MÁXIMA)
// - Garante que o dash comece no mesmo frame em que o jogador apertou
// =========================================================
if (!is_dashing && !is_attacking && keyboard_check_pressed(vk_space) && stamina >= stamina_roll_cost)
{
    // gasta stamina imediatamente
    stamina_spend(stamina_roll_cost);

    is_dashing = true;
    dash_timer = dash_duration;
    dash_blocked = false;

    // captura input atual
    var mx = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    var my = keyboard_check(ord("S")) - keyboard_check(ord("W"));

    // se parado, usa facing/last_dir
    if (mx == 0 && my == 0)
    {
        switch (facing)
        {
            case "right": mx = 1; break;
            case "left":  mx = -1; break;
            case "up":    my = -1; break;
            case "down":  my = 1; break;
            default: mx = last_dir; my = 0;
        }
    }

    // normaliza vetor e guarda direção imutável do dash
    var mlen = point_distance(0,0,mx,my);
    if (mlen != 0)
    {
        dash_dir_x = mx / mlen;
        dash_dir_y = my / mlen;
    }
    else
    {
        dash_dir_x = last_dir;
        dash_dir_y = 0;
    }

    // atualiza last_dir pra espelhar sprite corretamente
    if (dash_dir_x != 0) last_dir = sign(dash_dir_x);

    // força animação do roll pra iniciar imediatamente
    sprite_index = spr_player_roll;
    image_speed = 1;
    image_xscale = last_dir * scale;
}

// =========================================================
// 2) EXECUÇÃO DO DASH (PRIORIDADE: impede o resto do Step)
// - Implementa A2: tenta avançar nas duas componentes; se bate numa
//   componente, tenta continuar pela componente livre (slide).
// =========================================================
if (is_dashing)
{
    // dx/dy = 0 se dash_blocked (totalmente travado); caso contrário usamos dash_dir unitário
    var dx = dash_blocked ? 0 : dash_dir_x;
    var dy = dash_blocked ? 0 : dash_dir_y;

    // movimento por sub-steps: cada iteração move dx, dy (componentes ≤ 1)
    var i = 0;
    var hit_wall = false;

    while (i < dash_speed)
    {
        var moved_this_step = false;

        // tentamos mover nas duas componentes (prioridade: manter direção desejada)
        if (!place_meeting(x + dx, y + dy, obj_solid))
        {
            // espaço livre na diagonal composta (melhor caso)
            x += dx;
            y += dy;
            moved_this_step = true;
        }
        else
        {
            // caso diagonal bloqueada, tenta mover X sozinho
            if (!place_meeting(x + dx, y, obj_solid))
            {
                x += dx;
                moved_this_step = true;
            }
            // tenta mover Y sozinho
            else if (!place_meeting(x, y + dy, obj_solid))
            {
                y += dy;
                moved_this_step = true;
            }
            else
            {
                // ambas componentes bloqueadas -> bateu na parede
                hit_wall = true;
                // A2: Ao bater, tentamos um pequeno "slide" suave:
                // tentamos mover uma pequena fração perpendicular (0.5) para dar leve escorregada
                // primeiro tenta deslocamento perpendicular em +90 graus e -90 graus
                var perp_ang = point_direction(0, 0, dx, dy) + 90;
                var sx = lengthdir_x(0.5, perp_ang);
                var sy = lengthdir_y(0.5, perp_ang);
                if (!place_meeting(x + sx, y + sy, obj_solid))
                {
                    x += sx; y += sy;
                    moved_this_step = true;
                }
                else
                {
                    perp_ang = perp_ang - 180; // tenta a outra direção perpendicular
                    sx = lengthdir_x(0.5, perp_ang);
                    sy = lengthdir_y(0.5, perp_ang);
                    if (!place_meeting(x + sx, y + sy, obj_solid))
                    {
                        x += sx; y += sy;
                        moved_this_step = true;
                    }
                }
            }
        }

        // se nada foi movido neste sub-step, não adianta continuar tentando
        if (!moved_this_step)
        {
            // marca bloqueio e sai do loop para evitar clip/overshoot
            dash_blocked = true;
            break;
        }

        i++;
    }

    // se bateu em algum momento, mantém dash_blocked = true para impedir retrigger de movimento
    if (hit_wall) dash_blocked = true;

    // animação do roll continua sempre
    sprite_index = spr_player_roll;
    image_speed = 1;
    image_xscale = last_dir * scale;

    // decrementa timer e encerra dash quando acabar
    dash_timer--;
    if (dash_timer <= 0 || image_index >= image_number - 1)
    {
        is_dashing = false;
        dash_blocked = false;
    }

    // impede o restante do Step de rodar (proteção absoluta)
    exit;
}


// =========================================================
// 3) MOVIMENTO NORMAL (executa apenas quando NÃO estiver atacando/nem dashando)
// =========================================================
if (!is_attacking && !is_dashing)
{
    move_x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    move_y = keyboard_check(ord("S")) - keyboard_check(ord("W"));

    if (move_x != 0 || move_y != 0)
    {
        var mlen2 = point_distance(0,0,move_x,move_y);
        move_x /= mlen2;
        move_y /= mlen2;
    }

    h = move_x * move_speed;
    v = move_y * move_speed;

    // facing / last_dir
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

    // sprites de movimento / idle
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

    // corrida (ajusta move_speed e recalcula h/v)
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
// 4) STAMINA REGEN
// =========================================================
if (!is_dashing && !is_attacking && !(keyboard_check(vk_shift) && (move_x != 0 || move_y != 0)))
{
    if (stamina_delay_timer > 0) stamina_delay_timer--;
    else stamina = min(stamina_max, stamina + stamina_regen);
}


// =========================================================
// 5) ATAQUE (inicia apenas quando não dash/attacking)
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
// 6) LÓGICA DO ATAQUE (timer e reset de sprite)
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
// 7) COLISÃO FINAL COM OBJ_SÓLIDO (movimento normal apenas)
// - Movimento em passos de até 1px para evitar clip
// =========================================================
if (!is_dashing)
{
    // horizontal
    var remaining_h = h;
    var sign_h = sign(remaining_h);
    while (abs(remaining_h) > 0.0001)
    {
        var step_h = sign_h * min(1, abs(remaining_h));
        if (!place_meeting(x + step_h, y, obj_solid))
        {
            x += step_h;
            remaining_h -= step_h;
        }
        else
        {
            remaining_h = 0;
            break;
        }
    }

    // vertical
    var remaining_v = v;
    var sign_v = sign(remaining_v);
    while (abs(remaining_v) > 0.0001)
    {
        var step_v = sign_v * min(1, abs(remaining_v));
        if (!place_meeting(x, y + step_v, obj_solid))
        {
            y += step_v;
            remaining_v -= step_v;
        }
        else
        {
            remaining_v = 0;
            break;
        }
    }
}


// =========================================================
// 8) COLISÃO COM INIMIGO (empurrar player para fora)
// =========================================================
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


// =========================================================
// 9) ANTI-STUCK (varredura curta se ainda estiver dentro)
// =========================================================
if (place_meeting(x, y, obj_solid))
{
    var found = false;
    var maxr = 6;
    for (var r = 1; r <= maxr && !found; r++)
    {
        for (var ox = -r; ox <= r && !found; ox++)
        {
            for (var oy = -r; oy <= r && !found; oy++)
            {
                if (!place_meeting(x + ox, y + oy, obj_solid))
                {
                    x += ox;
                    y += oy;
                    found = true;
                }
            }
        }
    }
}
