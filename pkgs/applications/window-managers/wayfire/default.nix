{
  lib,
  stdenv,
  fetchFromGitHub,
  nixosTests,
  cmake,
  meson,
  ninja,
  pkg-config,
  wf-config,
  cairo,
  doctest,
  libGL,
  libdrm,
  libexecinfo,
  libevdev,
  libinput,
  libjpeg,
  libxkbcommon,
  openssl,
  vulkan-headers,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlroots_0_20,
  pango,
  libxcb-wm,
  yyjson,
}:
let
  wlroots = wlroots_0_20;
in

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire";
  version = "0.11.0";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire";
    rev = "v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-G6GakEpnqw3xORXP7mr2YoyAEymozV0CYeof+a1Nh74=";
  };

  # wayfire doesn't declare `drm` as a dependency for all plugins, which is why some files can't be resolved
  postPatch = ''
    substituteInPlace plugins/common/wayfire/plugins/common/cairo-util.hpp \
      --replace "<drm_fourcc.h>" "<libdrm/drm_fourcc.h>"
    substituteInPlace plugins/ipc-rules/meson.build \
      --replace \
      "all_deps = [wlroots, pixman, wfconfig, wftouch, json, plugin_pch_dep]" \
      "all_deps = [wlroots, pixman, drm, wfconfig, wftouch, json, plugin_pch_dep]"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    libGL
    libdrm
    libexecinfo
    libevdev
    libinput
    libjpeg
    vulkan-headers
    libxcb-wm
  ];

  propagatedBuildInputs = [
    cairo
    libxkbcommon
    openssl
    pango
    wayland
    wayland-protocols
    wf-config
    wlroots
    yyjson
  ];

  nativeCheckInputs = [
    cmake
    doctest
  ];

  # CMake is just used for finding doctest.
  dontUseCmakeConfigure = true;

  doCheck = true;

  mesonFlags = [
    "--sysconfdir /etc"
    "-Duse_system_wlroots=enabled"
    "-Duse_system_wfconfig=enabled"
    (lib.mesonEnable "wf-touch:tests" (stdenv.buildPlatform.canExecute stdenv.hostPlatform))
  ];

  passthru.providedSessions = [ "wayfire" ];

  passthru.tests.mate = nixosTests.mate-wayland;

  meta = {
    homepage = "https://wayfire.org/";
    description = "3D Wayland compositor";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      teatwig
      wucke13
      wineee
    ];
    platforms = lib.platforms.unix;
    mainProgram = "wayfire";
  };
})
