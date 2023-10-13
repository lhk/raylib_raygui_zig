const std = @import("std");

// Although this function looks imperative, note that its job is to
// declaratively construct a build graph that will be executed by an external
// runner.
pub fn build(b: *std.Build) void {
    // Standard target options allows the person running `zig build` to choose
    // what target to build for. Here we do not override the defaults, which
    // means any target is allowed, and the default is native. Other options
    // for restricting supported target set are available.
    const target = b.standardTargetOptions(.{});

    // Standard optimization options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall. Here we do not
    // set a preferred release mode, allowing the user to decide how to optimize.
    const optimize = b.standardOptimizeOption(.{});

    // Add in any project dependencies. We pull these down from the urls in build.zig.zon
    const raylib_package = b.dependency("raylib", .{
        .optimize = optimize,
        .target = target,
        // Add in optional modules in raylib. These match up to the options struct
        // https://github.com/raysan5/raylib/blob/bc15c19518968878b68bbfe8eac3fe4297f11770/src/build.zig#L161
        .raudio = true,
        .rmodels = true,
        .rshapes = true,
        .rtext = true,
        .rtextures = true,
        // we need to have raygui as a seperate dependency because the current build script
        // in raylib for including raygui is broken :( Raylib raygui.c supposes that raygui 
        // is in a nearby directory, this is not true when using the package manager
        .raygui = false,
        .platform_drm = false,
    });
    // This is a convenience for when we need to link raygui to raylib
    const raylib_artifact = raylib_package.artifact("raylib");

    // We can use the raygui repo. But it doesn't have a build.zig script
    // so we will need to manage linking the important files ourselves
    const raygui_package = b.dependency("raygui", .{
        .optimize = optimize,
        .target = target,
    });

    // We need to generate the implementation for raygui.h in raygui.c
    // https://github.com/raysan5/raylib/blob/bc15c19518968878b68bbfe8eac3fe4297f11770/src/build.zig#L60  
    const generate_raygui_c = b.addWriteFiles();
    const generated_file = generate_raygui_c.add("src/raygui.c", "#define RAYGUI_IMPLEMENTATION\n#define RAYGUI_STANDALONE\n#include \"raygui.h\"\n");
    // Since this repo doesn't have a build.zig, we will add it as a static library to link to the exe
    const raygui_lib = b.addStaticLibrary(.{
        .name = "raygui",
        .root_source_file = generated_file,
        .link_libc = true,
        .optimize = optimize,
        .target = target,
    });
    raygui_lib.step.dependOn(&generate_raygui_c.step);
    raygui_lib.addIncludePath(raygui_package.path("src/"));
    raygui_lib.addIncludePath(raylib_package.path("src/"));
    raygui_lib.linkLibrary(raylib_artifact); // raygui depends on raylib

    // This is where we specify the main executable
    const exe = b.addExecutable(.{
        .name = "raylib-and-raygui-example",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    // We need to link any of the depedencies we build
    exe.linkLibrary(raylib_artifact);
    exe.linkLibrary(raygui_lib);

    // This declares intent for the executable to be installed into the
    // standard location when the user invokes the "install" step (the default
    // step when running `zig build`).
    b.installArtifact(exe);

    // This *creates* a Run step in the build graph, to be executed when another
    // step is evaluated that depends on it. The next line below will establish
    // such a dependency.
    const run_cmd = b.addRunArtifact(exe);

    // By making the run step depend on the install step, it will be run from the
    // installation directory rather than directly from within the cache directory.
    // This is not necessary, however, if the application depends on other installed
    // files, this ensures they will be present and in the expected location.
    run_cmd.step.dependOn(b.getInstallStep());

    // This allows the user to pass arguments to the application in the build
    // command itself, like this: `zig build run -- arg1 arg2 etc`
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    // This creates a build step. It will be visible in the `zig build --help` menu,
    // and can be selected like this: `zig build run`
    // This will evaluate the `run` step rather than the default, which is "install".
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // Creates a step for unit testing. This only builds the test executable
    // but does not run it.
    const unit_tests = b.addTest(.{
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const run_unit_tests = b.addRunArtifact(unit_tests);

    // Similar to creating the run step earlier, this exposes a `test` step to
    // the `zig build --help` menu, providing a way for the user to request
    // running the unit tests.
    const test_step = b.step("test", "Run unit tests");
    test_step.dependOn(&run_unit_tests.step);
}
