

move_speed = 1;

// Direções de movimento
hsp = 0;
vsp = 0;

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
dash_speed = 3;          // velocidade do roll
dash_duration = 20;      // tempo em frames (15 = 0.25s se 60fps)
dash_timer = 0;          // contador


// direção do dash (precisa existir pra não dar erro)
dash_dir_x = 0;
dash_dir_y = 0;

facing = "right"; // controla cima/baixo/esquerda/direita
