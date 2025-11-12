// --- INPUT DE MOVIMENTO ---
var move_x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var move_y = keyboard_check(ord("S")) - keyboard_check(ord("W"));

// Normaliza diagonais
if (move_x != 0 || move_y != 0) {
    var len = point_distance(0, 0, move_x, move_y);
    move_x /= len;
    move_y /= len;
}

// --- SISTEMA DE DASH / ROLL ---
if (!is_dashing && keyboard_check_pressed(vk_space)) {
    is_dashing = true;
    dash_timer = dash_duration;

    // Define sprite e direção
    sprite_index = spr_player_roll;
    image_speed = 2;

    // Direção do dash
    if (move_x == 0 && move_y == 0) {
        // Se parado, dash na última direção
        move_x = last_dir;
        move_y = 0;
    }

   dash_dir_x = move_x;
   dash_dir_y = move_y;

    // Flip horizontal baseado na direção
    if (dash_dir_x < 0) {
        image_xscale = -1;
        last_dir = -1;
    } else if (dash_dir_x > 0) {
        image_xscale = 1;
        last_dir = 1;
    }
}

// --- EXECUÇÃO DO DASH ---
if (is_dashing) {
    // Move rapidamente
    x += dash_dir_x * dash_speed;
    y += dash_dir_y * dash_speed;

    dash_timer -= 1;

    // Fim do dash
    if (dash_timer <= 0) {
        is_dashing = false;
        sprite_index = spr_player;
        image_speed = 0;
        image_index = 0;
    }

    exit; // impede o resto do código de movimento enquanto rola
}

// --- MOVIMENTO NORMAL (só roda se não estiver rolando) ---
x += move_x * move_speed;
y += move_y * move_speed;

// Escolhe o sprite e faz o flip
if (move_x != 0 || move_y != 0) {
    sprite_index = spr_player_andando;
    image_speed = 1;

    if (move_x < 0) {
        image_xscale = -1;
        last_dir = -1;
    } else if (move_x > 0) {
        image_xscale = 1;
        last_dir = 1;
    }
} else {
    sprite_index = spr_player;
    image_speed = 0;
    image_index = 0;
    image_xscale = last_dir;
}
