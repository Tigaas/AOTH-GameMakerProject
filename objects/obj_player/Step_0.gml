// ------------------------------
// INPUT
// ------------------------------
var move_x = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var move_y = keyboard_check(ord("S")) - keyboard_check(ord("W"));

// Normaliza diagonais
if (move_x != 0 || move_y != 0) {
    var len = point_distance(0, 0, move_x, move_y);
    move_x /= len;
    move_y /= len;
}

// ------------------------------
// DASH / ROLL
// ------------------------------
if (!is_dashing && keyboard_check_pressed(vk_space)) {

    is_dashing = true;
    dash_timer = dash_duration;

    sprite_index = spr_player_roll;
    image_speed = 1;

    // Se não há movimento → usa facing
    if (move_x == 0 && move_y == 0) {
        switch (facing) {
            case "right": move_x = 1; break;
            case "left":  move_x = -1; break;
            case "up":    move_y = -1; break;
            case "down":  move_y = 1; break;
        }
    }

    dash_dir_x = move_x;
    dash_dir_y = move_y;

    // Registrar lado horizontal
    if (dash_dir_x < 0) last_dir = -1;
    else if (dash_dir_x > 0) last_dir = 1;

    // Flip no dash só horizontal
    if (dash_dir_x != 0)
        image_xscale = scale * last_dir;
    else
        image_xscale = scale;
}

// ------------------------------
// EXECUÇÃO DO DASH
// ------------------------------
if (is_dashing) {

    x += dash_dir_x * dash_speed;
    y += dash_dir_y * dash_speed;

    dash_timer--;

    if (dash_timer <= 0) {
        is_dashing = false;
        sprite_index = spr_player;
        image_speed = 0;
        image_index = 0;
    }

    exit;
}

// ------------------------------
// MOVIMENTO NORMAL
// ------------------------------
x += move_x * move_speed;
y += move_y * move_speed;


// ------------------------------
// ATUALIZA O FACING
// ------------------------------
if (move_x != 0 || move_y != 0) {

    if (abs(move_x) > abs(move_y)) {
        facing = (move_x > 0) ? "right" : "left";
        last_dir = (move_x > 0) ? 1 : -1;
    } else {
        facing = (move_y > 0) ? "down" : "up";
    }
}


// ------------------------------
// SISTEMA DE SPRITES
// ------------------------------
if (move_x != 0 || move_y != 0) {

    image_speed = 1;

    switch (facing) {
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

} else {

    image_speed = 0;
    image_index = 0;

    switch (facing) {
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


// ------------------------------
// FLIP (horizontal apenas)
// ------------------------------
if (facing == "left")
    image_xscale = -scale;
else
    image_xscale = scale;


// ------------------------------
// CORRER (Shift)
// ------------------------------
move_speed = keyboard_check(vk_shift) ? 2 : 1;
