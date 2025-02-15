# Springs Test

Simple module implementing spring physics. Learning how to create reusable
modules in C3. Sample application demonstrating usage of spring.c3 module.

Added fabrik module to program procedural animation using inverse kinematics.

Tested on MacOS 15.0.

## Running the examples
You can check out the examples with:

1. Install the [C3 compiler](https://c3-lang.org/getting-started/prebuilt-binaries/)
2. Open a command prompt in the directory of the cloned repository
3. `c3c vendor-fetch raylib55`
4. `c3c vendor-fetch raygui`
4. `c3c run springs`
5. `c3c run fabrik`


## vendor-fetch fails
1. Manually download the modules from [Forked Vendor Repository](https://github.com/tekin-tontu/vendor)
2. copy `vendor/libraries/raylib55.cl, vendor/libraries/raygui.cl` folder to the `lib` folder
