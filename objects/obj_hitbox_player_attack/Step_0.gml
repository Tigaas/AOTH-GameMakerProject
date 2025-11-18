/// HITBOX DE ATAQUE COM 8 DIREÇÕES
var ox = owner.x;
var oy = owner.y;

switch (attack_dir)
{
    case "up":         x = ox;      y = oy - 10; break;
    case "down":       x = ox;      y = oy + 10; break;
    case "left":       x = ox - 10; y = oy;      break;
    case "right":      x = ox + 10; y = oy;      break;

    case "up_right":   x = ox + 8;  y = oy - 8;  break;
    case "up_left":    x = ox - 8;  y = oy - 8;  break;
    case "down_right": x = ox + 8;  y = oy + 8;  break;
    case "down_left":  x = ox - 8;  y = oy + 8;  break;
}
