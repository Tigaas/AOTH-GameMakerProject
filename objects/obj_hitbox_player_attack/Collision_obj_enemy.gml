if (!hit) {
    other.hp -= damage;
    hit = true;
    instance_destroy(obj_hitbox_player_attack); // destrói pra não bater 2x
}

obj_enemy.show_hpbar = true;   // ativa barra ao tomar o primeiro hit
