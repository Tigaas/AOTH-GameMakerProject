

move_speed = 1;

// Direções de movimento
hsp = 0;
vsp = 0;

//colisao
collision_enabled = true;

// Guarda o último lado que ele estava olhando
last_dir = 1; // 1 = direita, -1 = esquerda

// Define o sprite inicial
sprite_index = spr_player;
image_speed = 0;

scale = 0.5;
image_xscale = scale;
image_yscale = scale;


// ---- DASH / ROLL ----
is_dashing = false;      // indica se está rolando
dash_speed = 2;          // velocidade do roll
dash_duration = 25;      // tempo em frames (15 = 0.25s se 60fps)
dash_timer = 0;          // contador



// direção do dash (precisa existir pra não dar erro)
dash_dir_x = 0;
dash_dir_y = 0;

facing = "right"; // controla cima/baixo/esquerda/direita


// ------ STAMINA ------
stamina_max = 100;
stamina = stamina_max;

stamina_regen = 0.5;      // regen por frame
stamina_run_cost = 0.25;  // custo por frame correndo
stamina_roll_cost = 12;   // custo do roll

stamina_delay = 40;       // delay antes de regenerar
stamina_delay_timer = 0;  // timer do delay

// --- ATAQUE ---
is_attacking = false;
attack_time = 20;     // duração total da animação (em frames) = ~0.33s
attack_timer = 0;

attack_stamina_cost = 15;   // custo de stamina para atacar

//------VIDA-----
hp = 100;
hp_max = 100;
