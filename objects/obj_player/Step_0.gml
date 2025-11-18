// =========================================================
// STEP EVENT - OBJ_PLAYER (OTIMIZADO, MESMA LÓGICA)
// =========================================================


// =========================================================
// FUNÇÃO LOCAL — GASTA STAMINA
// =========================================================
function stamina_spend(amount) {
    stamina = max(0, stamina - amount);
    stamina_delay_timer = stamina_delay;
}


// =========================================================
// 1) INÍCIO DO DASH
// =========================================================
if (!is_dashing && !is_attacking && keyboard_check_pressed(vk_space) && stamina >= stamina_roll_cost)
{
    stamina_spend(stamina_roll_cost);

    is_dashing   = true;
    dash_timer   = dash_duration;
    dash_blocked = false;

    // input bruto
    var mx = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    var my = keyboard_check(ord("S")) - keyboard_check(ord("W"));

    // se parado → usa facing
    if (mx == 0 && my == 0)
    {
        switch (facing) {
            case "right": mx =  1; break;
            case "left":  mx = -1; break;
            case "up":    my = -1; break;
            case "down":  my =  1; break;
            default:      mx = last_dir;
        }
    }

    // normaliza
    var len = point_distance(0,0,mx,my);
    if (len != 0) {
        dash_dir_x = mx / len;
        dash_dir_y = my / len;
    } else {
        dash_dir_x = last_dir;
        dash_dir_y = 0;
    }

    if (dash_dir_x != 0) last_dir = sign(dash_dir_x);

    // animação do roll
    sprite_index = spr_player_roll;
    image_speed  = 1;
    image_xscale = last_dir * scale;
}


// =========================================================
// 2) EXECUÇÃO DO DASH (A2 — sem clipping)
// =========================================================
if (is_dashing)
{
    var dx = dash_blocked ? 0 : dash_dir_x;
    var dy = dash_blocked ? 0 : dash_dir_y;

    var i = 0;
    var hit_wall = false;

    while (i < dash_speed)
    {
        var moved = false;

        // diagonal
        if (!place_meeting(x + dx, y + dy, obj_solid)) {
            x += dx; y += dy; moved = true;
        }
        else
        {
            // X
            if (!place_meeting(x + dx, y, obj_solid)) {
                x += dx; moved = true;
            }
            // Y
            else if (!place_meeting(x, y + dy, obj_solid)) {
                y += dy; moved = true;
            }
            else
            {
                hit_wall = true;

                var ang = point_direction(0,0,dx,dy) + 90;

                repeat (2)
                {
                    var sx = lengthdir_x(0.5, ang);
                    var sy = lengthdir_y(0.5, ang);

                    if (!place_meeting(x + sx, y + sy, obj_solid)) {
                        x += sx; y += sy; moved = true; break;
                    }

                    ang -= 180;
                }
            }
        }

        if (!moved) {
            dash_blocked = true;
            break;
        }

        i++; // ❗ só incrementa quando realmente moveu
    }

    if (hit_wall) dash_blocked = true;

    sprite_index = spr_player_roll;
    image_speed = 1;
    image_xscale = last_dir * scale;

    dash_timer--;
    if (dash_timer <= 0 || image_index >= image_number - 1)
    {
        is_dashing = false;
        dash_blocked = false;
    }

    exit;
}

// =========================================================
// 3) MOVIMENTO NORMAL
// =========================================================
if (!is_attacking)
{
    move_x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
    move_y = keyboard_check(ord("S")) - keyboard_check(ord("W"));

    var moving = (move_x != 0 || move_y != 0);

    if (moving) {
        var l = point_distance(0,0,move_x,move_y);
        move_x /= l;
        move_y /= l;
    }

    h = move_x * move_speed;
    v = move_y * move_speed;

    // facing
    if (moving)
    {
        if (abs(move_x) > abs(move_y)) {
            facing = move_x > 0 ? "right" : "left";
            last_dir = move_x > 0 ? 1 : -1;
        } else {
            facing = move_y > 0 ? "down" : "up";
        }
    }

    // sprites
    if (moving)
    {
        image_speed = 1;
        switch (facing) {
            case "right":
            case "left": sprite_index = spr_player_andando; break;
            case "up":   sprite_index = spr_player_andando_cima; break;
            case "down": sprite_index = spr_player_andando_baixo; break;
        }
    }
    else
    {
        image_speed = 0;
        image_index = 0;
        switch (facing) {
            case "right":
            case "left": sprite_index = spr_player; break;
            case "up":   sprite_index = spr_player_cima; break;
            case "down": sprite_index = spr_player_baixo; break;
        }
    }

    image_xscale = (facing == "left") ? -scale : scale;

    // corrida
    var running = keyboard_check(vk_shift) && moving;
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
// 5) ATAQUE (inicio)
// =========================================================
if (!is_dashing && !is_attacking && stamina >= attack_stamina_cost)
if (mouse_check_button_pressed(mb_left))
{
    is_attacking = true;
    attack_timer = attack_time;
    stamina_spend(attack_stamina_cost);

    // ===============================================
// HABILITAR ATAQUE EM 8 DIREÇÕES
// ===============================================

// Coleta a direção REAL (input analógico digital)
var mx = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var my = keyboard_check(ord("S")) - keyboard_check(ord("W"));

// Se parado → usar facing normal
if (mx == 0 && my == 0)
{
    switch (facing) {
        case "right": mx = 1; break;
        case "left":  mx = -1; break;
        case "down":  my = 1; break;
        case "up":    my = -1; break;
    }
}

// Normaliza
var l = point_distance(0,0,mx,my);
if (l != 0) {
    mx /= l; 
    my /= l;
}

// Detecta direção entre 8 possíveis
if (mx > 0.5 && abs(my) < 0.4) attack_facing = "right";
else if (mx < -0.5 && abs(my) < 0.4) attack_facing = "left";
else if (my > 0.5 && abs(mx) < 0.4) attack_facing = "down";
else if (my < -0.5 && abs(mx) < 0.4) attack_facing = "up";
else if (mx > 0.4 && my < -0.4) attack_facing = "up_right";
else if (mx < -0.4 && my < -0.4) attack_facing = "up_left";
else if (mx > 0.4 && my > 0.4) attack_facing = "down_right";
else if (mx < -0.4 && my > 0.4) attack_facing = "down_left";

// Criar hitbox
var hb = instance_create_layer(x, y, "Instances", obj_hitbox_player_attack);
hb.attack_dir = attack_facing;
hb.owner      = id;

// Animação (por enquanto usa as 4 normais)
switch (attack_facing)
{
    case "up":    sprite_index = spr_player_atacando_cima;  break;
    case "down":  sprite_index = spr_player_atacando_baixo; break;

    case "right": 
    case "up_right":
    case "down_right":
        sprite_index = spr_player_atacando; 
        image_xscale = scale;  
    break;

    case "left":  
    case "up_left":
    case "down_left":
        sprite_index = spr_player_atacando; 
        image_xscale = -scale;  
    break;
}

image_speed = 1;


    image_speed = 1;
}


// =========================================================
// 6) ATAQUE (execução)
// =========================================================
if (is_attacking)
{
    attack_timer--;
    h = 0;  v = 0;

    if (attack_timer <= 0)
    {
        is_attacking = false;
        image_speed  = 0;

        switch (facing) {
            case "right":
            case "left": sprite_index = spr_player; break;
            case "up":   sprite_index = spr_player_cima; break;
            case "down": sprite_index = spr_player_baixo; break;
        }
    }
}


// =========================================================
// 7) COLISÃO FINAL — paredes + inimigos
// =========================================================
function move_normal_collision(nx, ny)
{
    var rem, step, s;

    // HORIZONTAL
    rem = nx;
    s   = sign(nx);
    while (abs(rem) > 0.0001)
    {
        step = s * min(1, abs(rem));
        if (!place_meeting(x + step, y, obj_solid) &&
            !place_meeting(x + step, y, obj_enemy))
        {
            x += step; rem -= step;
        }
        else break;
    }

    // VERTICAL
    rem = ny;
    s   = sign(ny);
    while (abs(rem) > 0.0001)
    {
        step = s * min(1, abs(rem));
        if (!place_meeting(x, y + step, obj_solid) &&
            !place_meeting(x, y + step, obj_enemy))
        {
            y += step; rem -= step;
        }
        else break;
    }
}

if (!is_dashing) move_normal_collision(h, v);


// =========================================================
// 8) ANTI-STUCK COM INIMIGO
// =========================================================
if (!is_dashing)
{
    var e = instance_place(x, y, obj_enemy);
    if (e != noone) {
        var ang = point_direction(e.x, e.y, x, y);
        x += lengthdir_x(4, ang);
        y += lengthdir_y(4, ang);
    }
}


// =========================================================
// 9) ANTI-STUCK EM PAREDE (SUBSTITUIÇÃO MAIS SEGURO)
// =========================================================
// Só tenta se realmente estivermos dentro do solid.
// Usa busca por "raios", priorizando correções ortogonais para evitar teleportes diagonais.
if (place_meeting(x, y, obj_solid))
{
    var found = false;
    var maxr = 6;

    // primeiro tenta correções ortogonais pequenas: (±1,0) e (0,±1)
    for (var dist = 1; dist <= maxr && !found; dist++)
    {
        // checa passos ortogonais primeiro (horizontal/vertical)
        var ortho = [
            [dist, 0],
            [-dist, 0],
            [0, dist],
            [0, -dist]
        ];

        var diagStep = dist; // para usar depois, se ortho falhar

        // testar ortogonais
        for (var oi = 0; oi < array_length(ortho) && !found; oi++)
        {
            var tox = ortho[oi][0];
            var toy = ortho[oi][1];
            if (!place_meeting(x + tox, y + toy, obj_solid))
            {
                x += tox;
                y += toy;
                found = true;
                break;
            }
        }

        if (found) break;

        // se nenhuma ortogonal foi livre, só então verificar a "borda" em volta (diagonais)
        // varre a circunferência manhattan de raio dist
        for (var ox = -dist; ox <= dist && !found; ox++)
        {
            var oy_top = -dist;
            var oy_bot = dist;

            if (!place_meeting(x + ox, y + oy_top, obj_solid))
            {
                x += ox; y += oy_top; found = true; break;
            }
            if (!place_meeting(x + ox, y + oy_bot, obj_solid))
            {
                x += ox; y += oy_bot; found = true; break;
            }
        }

        for (var oy = -dist+1; oy <= dist-1 && !found; oy++)
        {
            var ox_left = -dist;
            var ox_right = dist;

            if (!place_meeting(x + ox_left, y + oy, obj_solid))
            {
                x += ox_left; y += oy; found = true; break;
            }
            if (!place_meeting(x + ox_right, y + oy, obj_solid))
            {
                x += ox_right; y += oy; found = true; break;
            }
        }
    }

    // Se não achou nenhuma posição (muito raro), não faz nada — evita teleporte perigoso.
}

