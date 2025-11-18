
morto = false;

hp = 74;
hp_max = 74;

show_hpbar = false;   // só aparece depois do primeiro hit
hpbar_offset = -20;   // posição acima da cabeça

image_xscale = 0.5;
image_yscale = 0.5;

// ============================================
// ESTADOS DO INIMIGO
// ============================================
state_patrol = 0;   // anda de um lado para o outro
state_chase  = 1;   // persegue o player
state_attack = 2;   // ataque
state_recover = 3;  // pausa depois do ataque

state = state_patrol;


// ============================================
// VELOCIDADES
// ============================================
spd_patrol = 1;
spd_chase  = 1.4;  // inimigo mais lento que o player


// ============================================
// ALERTA
// ============================================
alert_range = 140;   // distância para começar perseguição
attack_range = 24;   // distância para atacar


// ============================================
// TIMERS
// ============================================
attack_duration  = 20;  // duração do ataque (em frames)
recover_duration = 30;  // tempo parado após ataque

attack_timer  = 0;
recover_timer = 0;


// ============================================
// PATRULHA SIMPLES
// ============================================
dir = choose(-1, 1);               // direção inicial
patrol_timer = irandom_range(60, 180);


// ============================================
// PLAYER
// ============================================
player_obj = obj_player;


// MOVIMENTO
hsp = 0;
vsp = 0;
