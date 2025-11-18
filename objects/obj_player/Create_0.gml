// =========================================================
// ========================= MOVIMENTO =====================
// =========================================================
move_speed = 1;

// Direções de movimento
hsp = 0;
vsp = 0;

// Colisão
collision_enabled = true;

// Guarda o último lado que ele estava olhando
last_dir = 1; // 1 = direita, -1 = esquerda

// Define o sprite inicial
sprite_index = spr_player;
image_speed = 0;

scale = 0.5;
image_xscale = scale;
image_yscale = scale;

// =========================================================
// ========================= DASH ===========================
// =========================================================
is_dashing = false;
dash_blocked = false;

dash_timer = 0;         
dash_duration = 20;     // <-- TEMPO DO ROLL
dash_speed = 2;         // <-- VELOCIDADE DO ROLL (IMPORTANTE!!)

dash_dir_x = 0;
dash_dir_y = 0;

// Direção para cima/baixo/esquerda/direita
facing = "right";

// =========================================================
// ======================== STAMINA =========================
// =========================================================
stamina_max = 100;
stamina = stamina_max;

stamina_regen = 0.5;      // regen por frame
stamina_run_cost = 0.25;  // custo por frame correndo
stamina_roll_cost = 12;   // custo do roll

stamina_delay = 40;       // delay antes de regenerar
stamina_delay_timer = 0;  // timer do delay

// =========================================================
// ======================== ATAQUE ==========================
// =========================================================
is_attacking = false;
attack_time = 20;     // duração total da animação (em frames)
attack_timer = 0;

attack_stamina_cost = 15;   // custo de stamina para atacar

// =========================================================
// ========================= VIDA ===========================
// =========================================================
hp = 100;
hp_max = 100;
