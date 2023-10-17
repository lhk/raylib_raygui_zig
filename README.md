# raylib and raygui in zig

This is an example repo of how to get raylib and raygui to work in zig. 
The main challenge here is the fact that raylib has a `build.zig` file as part of the project, but raygui does not.
raylib does have support to enable raygui in its build file, however its written in a way that expects the `raygui.h` file to be provided in a specific location.
Simply adding raygui as a second dependency in your zig project also has the challenge of itself relying on raylib, and so linking them up requires some manual work.

This repo serves as an example on how to do it. 

Big thank you to the ziggit community and specifically IntegratedQuantum who provided the [solution to this problem.](https://ziggit.dev/t/can-you-locate-and-copy-dependency-files-specified-in-zon-files/1934/1)

# version info

This repo builds and runs successfully on my machine:
```
System:
  Kernel: 6.1.0-13-amd64 arch: x86_64 bits: 64 compiler: gcc v: 12.2.0 Desktop: Cinnamon v: 5.8.4
    tk: GTK v: 3.24.38 wm: muffin dm: LightDM Distro: LMDE 6 Faye base: Debian 12.1 bookworm
CPU:
  Info: 8-core model: AMD Ryzen 7 1700 bits: 64 type: MT MCP arch: Zen rev: 1 cache: L1: 768 KiB
    L2: 4 MiB L3: 16 MiB
Graphics:
  Device-1: AMD Ellesmere [Radeon RX 470/480/570/570X/580/580X/590] vendor: Micro-Star MSI
    driver: amdgpu v: kernel arch: GCN-4 pcie: speed: 8 GT/s lanes: 16 ports: active: HDMI-A-2
    empty: DP-1, DP-2, DVI-D-1, HDMI-A-1 bus-ID: 0a:00.0 chip-ID: 1002:67df temp: 54.0 C
  API: OpenGL v: 4.6 Mesa 22.3.6 renderer: AMD Radeon RX 580 Series (polaris10 LLVM 15.0.6 DRM
    3.49 6.1.0-13-amd64) direct-render: Yes
```

with the following zig version:
```
pavocracy@minty:~/git/personal/raylib-and-raygui-in-zig$ zig version
0.12.0-dev.817+54e7f58fc
```
