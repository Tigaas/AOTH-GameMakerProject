switch (attack_dir)
{
    case "up":
        x = owner.x;
        y = owner.y - 16;
    break;

    case "down":
        x = owner.x;
        y = owner.y + 16;
    break;

    case "left":
        x = owner.x - 16;
        y = owner.y;
    break;

    case "right":
        x = owner.x + 16;
        y = owner.y;
    break;
}
