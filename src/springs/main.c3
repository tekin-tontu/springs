// Copyright (c) 2024 Tekin Tontu. All rights reserved.
// Use of self source code is governed by the MIT license
// a copy of which can be found in the LICENSE file.

module springs;
import raylib5::rl;
import std::io;
import spring;

const int SCREENWIDTH = 1024;
const int SCREENHEIGHT = 768;
const int JUMP = 100;

def SpringVector2 = Spring(<Vector2>);
def SpringFloat = Spring(<float>);

fn int main()
{

    rl::setConfigFlags(rl::FLAG_MSAA_4X_HINT);
    rl::initWindow(SCREENWIDTH, SCREENHEIGHT, "Spring Testing");

    Vector2 ballPosition = { rl::getScreenWidth()/2.0f, rl::getScreenHeight()/2.0f };
    Vector2 ballPositionX = { rl::getScreenWidth()/2.0f, rl::getScreenHeight()/2.0f };
    Vector2 ballPositionY = { rl::getScreenWidth()/2.0f, rl::getScreenHeight()/2.0f };
    int ballRadius = 20;
    Vector2 offset = { 0, 0 };

    bool pause = false;

    SpringVector2 spring = spring::new(<Vector2>)(ballPosition, ballPosition);
    SpringFloat springx = spring::new(<float>)(ballPositionX.x, ballPositionX.x);
    SpringFloat springy = spring::new(<float>)(ballPositionY.y, ballPositionY.y);

    rl::setTargetFPS(60);
    rl::setTextLineSpacing(16);

    for (int framesCounter=0; !rl::windowShouldClose(); framesCounter++) @pool()
    {
        if (rl::isKeyPressed(rl::KEY_SPACE)) pause = !pause;

        float delta = rl::getFrameTime();

        if (!pause)
        {
            if (rl::isKeyPressed(rl::KEY_R)) {
                ballPosition = { rl::getScreenWidth()/2.0f, rl::getScreenHeight()/2.0f };
                ballPositionX = { rl::getScreenWidth()/2.0f, rl::getScreenHeight()/2.0f };
                ballPositionY = { rl::getScreenWidth()/2.0f, rl::getScreenHeight()/2.0f };
                spring.reset();
                springx.reset();
                springy.reset();
                spring.end_value = ballPosition;
                springx.end_value = ballPositionX.x;
                springy.end_value = ballPositionY.y;
            }
            if (rl::isKeyPressed(rl::KEY_M)) {
                bool shiftPressed = rl::isKeyDown(rl::KEY_RIGHT_SHIFT) || rl::isKeyDown(rl::KEY_LEFT_SHIFT);
                spring.mass += shiftPressed ? 0.05 : -0.05;
            }

            if (rl::isKeyDown(rl::KEY_D)) {
                bool shiftPressed = rl::isKeyDown(rl::KEY_RIGHT_SHIFT) || rl::isKeyDown(rl::KEY_LEFT_SHIFT);
                spring.damping += shiftPressed ? 0.5 : -0.5;
            }

            if (rl::isKeyDown(rl::KEY_S)) {
                bool shiftPressed = rl::isKeyDown(rl::KEY_RIGHT_SHIFT) || rl::isKeyDown(rl::KEY_LEFT_SHIFT);
                spring.stiffness += shiftPressed ? 0.5 : -0.5;
            }

            offset = {0,0};

            if (rl::isKeyPressed(rl::KEY_LEFT))
            {
                offset.x = -JUMP;
                springx.reset(offset.x);
                ballPositionX.x = springx.start_value;
            }
            if (rl::isKeyPressed(rl::KEY_RIGHT))
            {
                offset.x = JUMP;
                springx.reset(offset.x);
                ballPositionX.x = springx.start_value;
            }
            if (rl::isKeyPressed(rl::KEY_UP))
            {
                offset.y = -JUMP;
                springy.reset(offset.y);
                ballPositionY.y = springy.start_value;
            }
            if (rl::isKeyPressed(rl::KEY_DOWN))
            {
                offset.y = JUMP;
                springy.reset(offset.y);
                ballPositionY.y = springy.start_value;
            }

            if (rl::isKeyPressed(rl::KEY_LEFT) ||
                rl::isKeyPressed(rl::KEY_RIGHT) ||
                rl::isKeyPressed(rl::KEY_UP) ||
                rl::isKeyPressed(rl::KEY_DOWN) ) {

                spring.reset(offset);
                ballPosition = spring.start_value;
            }

            if (!spring.completed) { ballPosition = spring.apply(delta); }
            if (!springx.completed) { ballPositionX.x = springx.apply(delta); }
            if (!springy.completed) { ballPositionY.y = springy.apply(delta); }
       }


        rl::@drawing()
        {
            rl::clearBackground(rl::RAYWHITE);

            rl::drawCircleV(ballPosition, (float)ballRadius, rl::MAROON);
            rl::drawCircleV(ballPositionX, (float)ballRadius, rl::ORANGE);
            rl::drawCircleV(ballPositionY, (float)ballRadius, rl::GREEN);

            rl::drawText("PRESS KEYS to modify [sS]-Stiffness, [dD]-Daming, [mM]-Mass ", 10, rl::getScreenHeight() - 55, 20, rl::LIGHTGRAY);
            rl::drawText("PRESS SPACE to PAUSE BALL MOVEMENT AND INPUT - R to RESET", 10, rl::getScreenHeight() - 25, 20, rl::LIGHTGRAY);

            // On pause, we draw a blinking message
            if (pause && ((framesCounter/30)%2)) rl::drawText("PAUSED", rl::getScreenWidth() / 2 - 60, rl::getScreenHeight()/2 - 15, 30, rl::GRAY);

            rl::drawFPS(10, 10);
            rl::drawText(string::tformat_zstr("Spring: %s", spring), 10, 60, 10, rl::LIGHTGRAY);
            rl::drawText(string::tformat_zstr("SpringX: %s", springx), 10, 360, 10, rl::LIGHTGRAY);
            rl::drawText(string::tformat_zstr("SpringY: %s", springy), 370, 360, 10, rl::LIGHTGRAY);

        };

    };

    // De-Initialization
    rl::closeWindow();
    return 0;

}
