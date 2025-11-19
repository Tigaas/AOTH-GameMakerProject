// =========================================================
// SISTEMA DE MORTE
// =========================================================
if (morto) {
    instance_destroy();
}

if (hp <= 0) {
    morto = true;
}


// =========================================================
// REFERÊNCIA AO PLAYER
// =========================================================
if (instance_exists(obj_player)) {

    var p = instance_nearest(x, y, player_obj);
    var dist = point_distance(x, y, p.x, p.y);

    // =========================================================
    // RESET DO MOVIMENTO
    // =========================================================
    hsp = 0;
    vsp = 0;

    // =========================================================
    // MAQUINA DE ESTADOS
    // =========================================================
    switch (state)
    {

    // ----------------------------------------------------------
    // 1) PATRULHA
    // ----------------------------------------------------------
    case state_patrol:

        is_attacking = false;

        hsp = dir * spd_patrol;

        patrol_timer--;

        if (patrol_timer <= 0) {
            dir *= -1;
            patrol_timer = irandom_range(60, 180);
        }

        if (place_meeting(x + hsp, y, obj_solid)) {
            dir *= -1;
        }

        if (dist <= alert_range) {
            state = state_chase;
        }

    break;


    // ----------------------------------------------------------
    // 2) CHASE
    // ----------------------------------------------------------
    case state_chase:

        is_attacking = false;

        var dx = p.x - x;
        var dy = p.y - y;
        var d = point_distance(0, 0, dx, dy);

        if (d > 0) {
            hsp = (dx / d) * spd_chase;
            vsp = (dy / d) * spd_chase;
        }

        if (dist <= attack_range) {
            state = state_attack;
            attack_timer = attack_duration;
            is_attacking = true;
        }

    break;


    // ----------------------------------------------------------
    // 3) ATTACK
    // ----------------------------------------------------------
    case state_attack:

        hsp = 0;
        vsp = 0;

        is_attacking = true;

        attack_timer--;

        // cria hitbox no momento certo do ataque
        if (attack_timer == attack_duration - 25) {

            var ang = point_direction(x, y, p.x, p.y);
            var dist_hit = 8;

            var hx = x + lengthdir_x(dist_hit, ang);
            var hy = y + lengthdir_y(dist_hit, ang);

            instance_create_layer(hx, hy, "Instances", obj_hitbox_enemy_attack);
        }

        if (attack_timer <= 0) {
            state = state_recover;
            recover_timer = recover_duration;
            is_attacking = false;
        }

    break;


    // ----------------------------------------------------------
    // 4) RECOVER
    // ----------------------------------------------------------
    case state_recover:

        hsp = 0;
        vsp = 0;
        is_attacking = false;

        recover_timer--;

        if (recover_timer <= 0) {
            state = state_chase;
        }

    break;

    } // fim switch
} // fim instance_exists



// =========================================================
// MOVIMENTO FINAL
// =========================================================
x += hsp;
y += vsp;


// =========================================================
// ANIMAÇÃO — ESCALA FIXA
// =========================================================
image_yscale = 0.5;

// direção do movimento (para andar)
var mov_dir = point_direction(0, 0, hsp, vsp);

// direção real para ataque (sempre mirando o player)
var atk_dir = point_direction(x, y, p.x, p.y);


// =========================================================
// 1) SPRITES DE ATAQUE
// =========================================================
if (is_attacking)
{
    image_speed = 0.75;

    // usa direção do ataque, não do movimento
    var d = atk_dir;

    if (d > 45 && d <= 135) {
        // BAIXO
        if (sprite_index != spr_enemy_attack_baixo) {
            sprite_index = spr_enemy_attack_baixo;
            image_index = 0;
        }
        image_xscale = 0.5;

    } 
    else if (d > -135 && d <= -45) {
        // CIMA
        if (sprite_index != spr_enemy_attack_cima) {
            sprite_index = spr_enemy_attack_cima;
            image_index = 0;
        }
        image_xscale = 0.5;

    } 
    else {
        // LATERAL
        if (sprite_index != spr_enemy_attack) {
            sprite_index = spr_enemy_attack;
            image_index = 0;
        }

        // DIREITA / ESQUERDA
        if (d > 135 || d <= -135) {
            image_xscale = -0.5; // esquerda
        } else {
            image_xscale = 0.5;  // direita
        }
    }

    exit;
}



// =========================================================
// 2) SPRITES DE ANDAR
// =========================================================
if (hsp == 0 && vsp == 0) {
    image_speed = 0;
    exit;
}

image_speed = 0.8;

var d = mov_dir;

if (d > 45 && d <= 135) {
    // BAIXO
    if (sprite_index != spr_enemy_andando_baixo) {
        sprite_index = spr_enemy_andando_baixo;
        image_index = 0;
    }
    image_xscale = 0.5;

} 
else if (d > -135 && d <= -45) {
    // CIMA
    if (sprite_index != spr_enemy_andando_cima) {
        sprite_index = spr_enemy_andando_cima;
        image_index = 0;
    }
    image_xscale = 0.5;

} 
else {
    // LATERAL
    if (sprite_index != spr_enemy_andando) {
        sprite_index = spr_enemy_andando;
        image_index = 0;
    }

    if (d > 135 || d <= -135) {
        image_xscale = -0.5; // esquerda
    } else {
        image_xscale = 0.5;  // direita
    }
}
