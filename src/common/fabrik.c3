// Copyright (c) 2024 Tekin Tontu. All rights reserved.
// Use of self source code is governed by the MIT license
// a copy of which can be found in the LICENSE file.
//
module fabrik;
import raylib5::rl;
import std::collections::list, std::io;

struct EndEffector(Printable) {
    Vector2 position;
    float length;
}

def DrawFn = fn void(Limb* limb);

fn usz! EndEffector.to_format(&self, Formatter* formatter) @dynamic
{
	usz n = formatter.print("{")!;
	n += formatter.printf("\n\tposition:\t{%f,%f}", self.position.x, self.position.y)!;
	n += formatter.printf("\n\tlength:\t\t%f", self.length)!;
	n += formatter.print("\n}")!;
	return n;
}

macro EndEffector endEffector(float x, float y, float l) {
    return {
        .position = {x, y},
        .length = l
    };
}

struct Limb(Printable) {
    List(<EndEffector>) segments;
    Vector2 target;
    Vector2 root;
    bool fixed_root;
    DrawFn custom_draw;
}

fn usz! Limb.to_format(&self, Formatter* formatter) @dynamic
{
	usz n = formatter.print("{")!;
	n += formatter.printf("\n\tsegments:\t%s", self.segments)!;
	n += formatter.printf("\n\ttarget:\t{%f,%f}", self.target.x, self.target.y)!;
	n += formatter.printf("\n\troot:\t\t{%f,%f}", self.root.x, self.root.y)!;
	n += formatter.printf("\n\fixed_root:\t{%s}", self.fixed_root ? "true" : "false")!;
	n += formatter.print("\n}")!;
	return n;
}


macro Limb limb(Vector2 root, int numEffectors,  float width, float height, float segment_length=150, float mul=0.8, bool fixed_root=true, DrawFn custom_draw={}) {
    List(<EndEffector>) segments;

    float sum = 0;

    for (int i=0; i < numEffectors; i++) {
        segments.push(endEffector(width / 2, height - sum, segment_length));
        sum += segment_length;
        segment_length *= mul;
    }

    return {
        .segments = segments,
        .target = {0 , 0},
        .root = root,
        .fixed_root = fixed_root,
        .custom_draw = custom_draw
    };
}

fn void Limb.free(&self) {
    self.segments.free();
}

fn void Limb._draw(&self) @private {
    Vector2 c, n;

    c = self.segments[0].position;
    rl::drawCircleV(c, 20, rl::BLACK);
    rl::drawCircleV(c, 10, rl::ORANGE);

    for (usz i=0; i < self.segments.size-1; i++) {
        c = self.segments[i].position;
        n = self.segments[i+1].position;
        rl::drawLineEx(c, n, 20, rl::ORANGE);
        rl::drawCircleV(n, 20, rl::RED);
        rl::drawCircleV(n, 10, rl::ORANGE);
    }
}

fn void Limb.draw(&self) {
    if (self.custom_draw) {
        self.custom_draw(&*self);
    } else {
        self._draw();
    }
}


fn void Limb.fabrik_forward(&self, float delta) @private {

    EndEffector *next = &self.segments[self.segments.size - 1];
    next.position = self.target;
    for (int i = (int)self.segments.size-2; i >= 0; --i) {
        EndEffector *current = &self.segments[i];
        Vector2 direction = next.position.sub(current.position).normalize().scaledby(current.length);
        current.position = next.position.sub(direction);
        next = current;
    }
}

fn void Limb.fabrik_back(&self, float delta) @private {

    EndEffector *previous = &self.segments[0];
    previous.position = self.root;
    for (usz i = 1; i < self.segments.size; i++) {
        EndEffector *current = &self.segments[i];
        Vector2 direction = current.position.sub(previous.position).normalize().scaledby(previous.length);
        current.position = previous.position.add(direction);
        previous = current;
    }
}

fn void Limb.update(&self, float delta) {
    self.fabrik_forward(delta);
    if (self.fixed_root) {
        self.fabrik_back(delta);
    }
}
