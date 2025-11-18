if (morto = true) {
	instance_destroy()
}

if (hp <= 0) {
	morto = !morto
} 
// =========================================================
// REFERÊNCIA AO PLAYER
// =========================================================
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
// 1) PATRULHA — inimigo anda horizontalmente até ver o player
// ----------------------------------------------------------
    case state_patrol:

        // move horizontalmente
        hsp = dir * spd_patrol;

        // timer para mudar direção
        patrol_timer -= 1;
        if (patrol_timer <= 0) {
            dir *= -1;
            patrol_timer = irandom_range(60, 180);
        }

        // evita atravessar parede
        if (place_meeting(x + hsp, y, obj_solid)) {
            dir *= -1;
        }

        // se o player entrar na zona de alerta → CHASE
        if (dist <= alert_range) {
            state = state_chase;
        }

    break;



// ----------------------------------------------------------
// 2) CHASE — perseguição 2D completa
// ----------------------------------------------------------
    case state_chase:

        // direção até o player
        var dx = p.x - x;
        var dy = p.y - y;
        var d = point_distance(0, 0, dx, dy);

        if (d > 0) {
            hsp = (dx / d) * spd_chase;
            vsp = (dy / d) * spd_chase;
        }

        // chegou perto? → ATAQUE
        if (dist <= attack_range) {
            state = state_attack;
            attack_timer = attack_duration;
        }

    break;



// ----------------------------------------------------------
// 3) ATTACK — ataque (parado), depois vai para RECOVER
// ----------------------------------------------------------
    case state_attack:

        hsp = 0;
        vsp = 0;

        // aqui você coloca a hitbox mais tarde

        attack_timer -= 1;

        if (attack_timer <= 0) {
            state = state_recover;
            recover_timer = recover_duration;
        }

    break;



// ----------------------------------------------------------
// 4) RECOVER — pausa após o ataque
// ----------------------------------------------------------
    case state_recover:

        hsp = 0;
        vsp = 0;

        recover_timer -= 1;

        if (recover_timer <= 0) {
            // volta a perseguir o player
            state = state_chase;
        }

    break;
}


// =========================================================
// MOVIMENTO FINAL
// =========================================================
x += hsp;
y += vsp;
