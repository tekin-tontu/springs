# Springs Test

Simple module implementing spring physics. Learning how to create reusable
modules in C3. Sample application demonstrating usage of spring.c3 module.

Added fabrik module to program procedural animation using forward and backward reaching inverse kinematics.

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
On the occasion the c3c vender-fetch fails, you can manually download vendor repository. The files in this repository
have been checked to work with the vendor files in the forked repository.

1. Manually download the modules from [Forked Vendor Repository](https://github.com/tekin-tontu/vendor)
2. copy or create symbolic link `vendor/libraries/raylib55.cl, vendor/libraries/raygui.cl` folder to the contents of `lib` folder

```
├── LICENSE
├── README.md
├── build
├── docs
├── lib
│   ├── raygui.c3l -> ../../vendor/libraries/raygui.c3l
│   └── raylib55.c3l -> ../../vendor/libraries/raylib55.c3l
├── project.json
├── resources
├── scripts
├── src
│   ├── common
│   │   ├── fabrik.c3
│   │   └── spring.c3
│   ├── fabrik
│   │   └── main.c3
│   └── springs
│       └── main.c3
```
