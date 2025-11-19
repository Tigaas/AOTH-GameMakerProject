if (obj_player.is_dashing == false){// verifica colisão com player
var p = instance_place(x, y, obj_player);

if (p != noone && !hit)
{
    // aplica o dano no player
    p.hp -= damage;

    // marcar que já bateu
    hit = true;

    // destruir a hitbox imediatamente
    instance_destroy();
}


// tempo de vida da hitbox
life--;
if (life <= 0) {
    instance_destroy();
}
}