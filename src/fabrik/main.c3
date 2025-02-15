module fabrik_test;

import raylib5::rl, raygui::rg, std::io, std::collections::list, spring, fabrik;

const int SCREENWIDTH = 1240;
const int SCREENHEIGHT = 1000;


def SpringVector2 = Spring(<Vector2>);

fn void noroot_draw(Limb* self) {
    Vector2 c, n;

    c = self.segments[0].position;
    rl::drawCircleV(c, 20, rl::YELLOW);
    rl::drawCircleV(c, 10, rl::MAROON);


    for (usz i=0; i < self.segments.size-1; i++) {
        c = self.segments[i].position;
        n = self.segments[i+1].position;
        rl::drawLineEx(c, n, 20, rl::BROWN);
        rl::drawCircleV(n, 20, rl::GREEN);
        rl::drawCircleV(n, 10, rl::BROWN);
    }
}

fn int main()
{

    List(<Limb>) limbs;

    Vector2 mousePosition;

    rl::initWindow(SCREENWIDTH, SCREENHEIGHT, "Fabrik");

    limbs.add_array({
        //l, l2, l3, l4, l_noroot
        fabrik::limb({SCREENWIDTH * 0.5, SCREENHEIGHT}, 6, SCREENWIDTH, SCREENHEIGHT, segment_length: 100),
        fabrik::limb({0, SCREENHEIGHT * 0.5}, 8, SCREENWIDTH, SCREENHEIGHT, segment_length: 100),
        fabrik::limb({SCREENWIDTH, SCREENHEIGHT * 0.5}, 8, SCREENWIDTH, SCREENHEIGHT, segment_length: 100),
        fabrik::limb({SCREENWIDTH * 0.5, 0}, 6, SCREENWIDTH / 2, SCREENHEIGHT / 2, segment_length: 100),
        fabrik::limb({SCREENWIDTH * 0.5, 0}, 6, SCREENWIDTH, SCREENHEIGHT, segment_length: 50, fixed_root: false, custom_draw: &noroot_draw)
    });


    SpringVector2 spring = spring::new(<Vector2>)({}, {}, stiffness: 140.0, damping: 8, mass: 0.2);
    spring.end_value = {SCREENWIDTH * 0.5, SCREENHEIGHT * 0.5};

    rl::setTargetFPS(60);

    while (!rl::windowShouldClose())
    {
        float delta = rl::getFrameTime();
        mousePosition = rl::getMousePosition();

        if (rl::isMouseButtonPressed(MouseButton.LEFT) && !(mousePosition.x < 120 && mousePosition.y < 120)) {

            spring.end_value = mousePosition;
            spring.completed = false;
        }

        if (!spring.completed)
        {

            Vector2 target = spring.apply(delta);
            foreach(&limb : limbs) {
                limb.target = target;
                limb.update(delta);
            }

        }

        rl::beginDrawing();
            rl::clearBackground(rl::RAYWHITE);
            foreach(&limb : limbs) { limb.draw(); }

            rl::drawCircleV(spring.end_value, 20, rl::GREEN);

            rg::guiSliderBar({ 70, 10, 120, 20}, "Stiffness", rl::textFormat("%.2f", spring.stiffness), &spring.stiffness, 0, 400);
            rg::guiSliderBar({ 70, 40, 120, 20}, "Damping", rl::textFormat("%.2f", spring.damping), &spring.damping, 0, 200);
            rg::guiSliderBar({ 70, 70, 120, 20}, "Mass", rl::textFormat("%.2f", spring.mass), &spring.mass, 0.1, 10);

        rl::endDrawing();

    }

    // De-Initialization
    rl::closeWindow();
    foreach(&limb : limbs) {
        limb.free();
    }
    limbs.free();
    io::printn("Exiting now");
    return 0;

}
