{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wayfire,
  wayland-scanner,
  boost,
  glibmm,
  libdrm,
  libevdev,
  libinput,
  vulkan-headers,
  libxcb-wm,
  gtkmm3,
  withFiltersPlugin ? true,
  withFocusRequestPlugin ? true,
  withPixdecorPlugin ? true,
  withWayfireShadowsPlugin ? true,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wayfire-plugins-extra";
  version = "0.11.0-unstable-2026-07-17";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wayfire-plugins-extra";
    rev = "4290ddf13bfadb344d45cb25c47f7825bbdc8a30";
    hash = "sha256-HhCGB4ZslglB4o+xZ1gUmeUKWTR1VPnYS2Maqi++OaY=";
    fetchSubmodules = true;
  };

  # fix pixdecor to not generate files outside the sandbox
  patches = [ ./pixdecor-submodule-build.patch ];
  patchFlags = [ "-p1" "-d" "subprojects/pixdecor" ];

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
  ];

  buildInputs = [
    wayfire
    boost
    glibmm
    libdrm
    libevdev
    libinput
    vulkan-headers
    libxcb-wm
    gtkmm3
  ];

  mesonFlags = [
    (lib.mesonBool "enable_filters" withFiltersPlugin)
    (lib.mesonBool "enable_focus_request" withFocusRequestPlugin)
    (lib.mesonBool "enable_pixdecor" withPixdecorPlugin)
    (lib.mesonBool "enable_wayfire_shadows" withWayfireShadowsPlugin)
  ];

  env = {
    PKG_CONFIG_WAYFIRE_METADATADIR = "${placeholder "out"}/share/wayfire/metadata";
  };

  meta = {
    homepage = "https://github.com/WayfireWM/wayfire-plugins-extra";
    description = "Additional plugins for Wayfire";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ wineee ];
    inherit (wayfire.meta) platforms;
  };
})
