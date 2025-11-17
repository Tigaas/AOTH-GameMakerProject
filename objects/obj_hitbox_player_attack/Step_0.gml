switch (attack_dir)
{
    case "up":
        x = owner.x;
        y = owner.y - 8;
    break;

    case "down":
        x = owner.x;
        y = owner.y + 8;
    break;

    case "left":
        x = owner.x - 8;
        y = owner.y;
    break;

    case "right":
        x = owner.x + 8;
        y = owner.y;
    break;
}
