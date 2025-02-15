// Copyright (c) 2024 Tekin Tontu. All rights reserved.
// Use of self source code is governed by the MIT license
// a copy of which can be found in the LICENSE file.

module spring(<Type>);
import raylib5::rl, std::io, spring::spring_common;

const float EPSILON = 0.005;

struct Spring
{
    Type start_value;
    Type end_value;
    Type value;
    Type velocity;
    float stiffness;
    float damping;
    float mass;
    bool completed;
}

fn usz! Spring.to_format(&self, Formatter* formatter) @dynamic
{
	usz n = formatter.print("{")!;
	n += formatter.printf("\n\tstart_value:\t%s", self.start_value)!;
	n += formatter.printf("\n\tend_value:\t%s", self.end_value)!;
	n += formatter.printf("\n\tvalue:\t\t%s", self.value)!;
	n += formatter.printf("\n\tvelocity:\t%s", self.velocity)!;
	n += formatter.printf("\n\tstiffness:\t%f", self.stiffness)!;
	n += formatter.printf("\n\tdamping:\t%f", self.damping)!;
	n += formatter.printf("\n\tmass:\t\t%f", self.mass)!;
	n += formatter.printf("\n\tcompleted:\t%s", self.completed ? "True" : "False")!;
	n += formatter.print("\n}")!;
	return n;
}


fn Spring new(
    Type start_value,
    Type end_value,
    float stiffness=157.91367041742973,
    float damping=25.132741228718345,
    float mass=1.0,
    Type velocity = {}
)
{
    return {
        .start_value = start_value,
        .end_value = end_value,
        .value = {},
        .velocity = velocity,
        .stiffness = stiffness,
        .damping = damping,
        .mass = mass,
        .completed = false
    };
}

/*
macro add(a, b)
{
    $if ( @typeis(a, Vector2)  &&  @typeis(b, Vector2) ):
        return TypeA { a.x + b.x, a.y + b.y };
    $else
        return a + b;
    $endif
}

macro sub(a, b)
{
$if ( @typeis(a, Vector2)  &&  @typeis(b, Vector2) ):
    return TypeA { a.x - b.x, a.y - b.y };
$else
    return a - b;
$endif
}
*/

fn Type Spring.apply(&self, float time_delta)
{
    Type displacement = self.start_value.add(self.value).sub(self.end_value);

    // Hooke's law
    Type spring_force = displacement.scaledby( -self.stiffness );
    Type damping_force = self.velocity.scaledby( -self.damping );


    Type resultant_force = spring_force.add(damping_force);
    Type acceleration = resultant_force.scaledby( self.mass );


    self.velocity = self.velocity.add(acceleration.scaledby( time_delta));
    self.value = self.value.add(self.velocity.scaledby( time_delta));

    if ( self.velocity.magnitude_squared() < EPSILON && displacement.magnitude_squared() < EPSILON ) {
        self.completed = true;
        return self.end_value;
    }

    return self.start_value.add(self.value);
}

fn void Spring.reset(&self, Type offset = {}) {
    self.start_value = self.end_value;
    self.end_value = self.start_value.add(offset);
    self.value = {};
    self.completed = false;
}

module spring::spring_common;
import std::io, std::math, raylib5::rl;

fn usz! Vector2.to_format(&self, Formatter* formatter) @dynamic
{
	return formatter.printf("{x:%f, y:%f}",self.x, self.y)!;
}

// fn Vector2 Vector2.zero(self) => {0, 0};
fn float Vector2.magnitude_squared(self) @inline => self.x * self.x + self.y * self.y;
fn Vector2 Vector2.scaledby(self, float scale) => { self.x * scale, self.y * scale };
fn Vector2 Vector2.add(self, Vector2 to) => { self.x + to.x, self.y + to.y };
fn Vector2 Vector2.sub(self, Vector2 to) => { self.x - to.x, self.y - to.y };

// fn float float.zero(self) => 0;
fn float float.magnitude_squared(self) => self * self;
fn float float.scaledby(self, float scale) => self * scale;
fn float float.add(self, float to) => self + to;
fn float float.sub(self, float to) => self - to;

fn Vector2 Vector2.normalize(self) {
    Vector2 result = {};
    float length = math::sqrt((self.x*self.x) + (self.y*self.y));
    if (length > 0)
    {
        float ilength = 1.0f / length;
        result.x = self.x * ilength;
        result.y = self.y * ilength;
    }
    return result;
}
