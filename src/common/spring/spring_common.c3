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
