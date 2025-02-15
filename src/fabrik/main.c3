module fabrik_test;

import raylib5::rl, raygui::rg, std::io, std::collections::list, spring, fabrik;

const int SCREENWIDTH = 1240;
const int SCREENHEIGHT = 1000;


def SpringVector2 = Spring(<Vector2>);

fn void noroot_draw(Limb* self)
{
    Vector2 c, n;

    c = self.segments[0].position;
    rl::drawCircleV(c, 20, rl::YELLOW);
    rl::drawCircleV(c, 10, rl::LIME);

    for (usz i=0; i < self.segments.size-1; i++)
    {
        c = self.segments[i].position;
        n = self.segments[i+1].position;
        rl::drawLineEx(c, n, 20 , rl::LIME);

        rl::drawCircleV(n, 20, rl::GREEN);
        rl::drawCircleV(n, 12, rl::LIME);
    }
}

fn int main()
{
    Vector2 mousePosition;
    bool menushow = true;

    rl::initWindow(SCREENWIDTH, SCREENHEIGHT, "Fabrik");

    Limb[*] limbs = {
        fabrik::limb({SCREENWIDTH * 0.5, SCREENHEIGHT}, 6, SCREENWIDTH, SCREENHEIGHT, segment_length: 100),
        fabrik::limb({0, SCREENHEIGHT * 0.5}, 8, SCREENWIDTH, SCREENHEIGHT, segment_length: 100),
        fabrik::limb({SCREENWIDTH, SCREENHEIGHT * 0.5}, 8, SCREENWIDTH, SCREENHEIGHT, segment_length: 100),
        fabrik::limb({SCREENWIDTH * 0.5, 0}, 6, SCREENWIDTH / 2, SCREENHEIGHT / 2, segment_length: 100),
        fabrik::limb({SCREENWIDTH * 0.5, 0}, 6, SCREENWIDTH, SCREENHEIGHT, segment_length: 50, fixed_root: false, custom_draw: &noroot_draw),
    };

    defer {
        foreach(&limb : limbs) {
            limb.free();
        }
    }

    Vector2 menupos = { 0, 0 };
    SpringVector2 spring = spring::new(<Vector2>)({}, {}, stiffness: 140.0, damping: 8, mass: 0.2);
    SpringVector2 menuanim = spring::new(<Vector2>)(menupos, menupos);
    spring.end_value = {SCREENWIDTH * 0.5, SCREENHEIGHT * 0.5};

    rl::setTargetFPS(60);

    for (int framesCounter=0; !rl::windowShouldClose(); framesCounter++) @pool()
    {
        float delta = rl::getFrameTime();
        mousePosition = rl::getMousePosition();

        if (rl::isKeyPressed(rl::KEY_M))
        {
            menushow = !menushow;
            menuanim.end_value = menushow ? {0,0} : {0, -200};
            menuanim.completed = false;
        }

        if (rl::isMouseButtonPressed(MouseButton.LEFT) && !(mousePosition.x < 230 && mousePosition.y < 100))
        {
            spring.end_value = mousePosition;
            spring.completed = false;
        }

        if (!menuanim.completed) { menupos = menuanim.apply(delta);}
        if (!spring.completed)
        {
            Vector2 target = spring.apply(delta);
            foreach(&limb : limbs)
            {
                limb.target = target;
                limb.update(delta);
            }
        }

        rl::@drawing()
        {
            rl::clearBackground(rl::RAYWHITE);

            foreach(&limb : limbs) { limb.draw(); }
            rl::drawCircleV(spring.end_value, 24, spring.completed ? rl::RED : rl::GREEN);

            rl::drawRectangleRounded({10 + menupos.x, 10 + menupos.y, 230, 100}, 0.1, 4, rl::WHITE);
            rg::guiSliderBar({ 70 + menupos.x, 20 + menupos.y, 120, 20}, "Stiffness", rl::textFormat("%.2f", spring.stiffness), &spring.stiffness, 0, 400);
            rg::guiSliderBar({ 70 + menupos.x, 50 + menupos.y, 120, 20}, "Damping", rl::textFormat("%.2f", spring.damping), &spring.damping, 0, 200);
            rg::guiSliderBar({ 70 + menupos.x, 80 + menupos.y, 120, 20}, "Mass", rl::textFormat("%.2f", spring.mass), &spring.mass, 0.1, 10);

            rl::drawText(menushow ? "M - Hide Controls" : "M - Show Controls", 14, SCREENHEIGHT - 24, 20, rl::GRAY);
        };
    };

    // De-Initialization
    rl::closeWindow();

    io::printn("Exiting now");
    return 0;

}
