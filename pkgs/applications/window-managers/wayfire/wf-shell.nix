{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  gobject-introspection,
  vala,
  wayland-scanner,
  wayfire,
  alsa-lib,
  ddcutil,
  gtk4-layer-shell,
  gtkmm4,
  libGL,
  libdbusmenu-gtk3,
  libgbm,
  libepoxy,
  linux-pam,
  pipewire,
  pulseaudio,
  wireplumber,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wf-shell";
  version = "0.11.0-unstable-2026-07-26";
  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wf-shell";
    rev = "5c595e4821c992da3f1ce4a3b052bdfef00a7794";
    fetchSubmodules = true;
    hash = "sha256-1im7GQKmhueMslvg8X5+iwOINThTEA3/RHoVgHewF0w=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    gobject-introspection
    vala
    wayland-scanner
  ];

  buildInputs = [
    wayfire
    alsa-lib
    ddcutil
    gtk4-layer-shell
    gtkmm4
    libGL
    libepoxy
    libgbm
    libdbusmenu-gtk3
    linux-pam
    pipewire
    pulseaudio
    wireplumber
  ];

  postPatch = ''
    substituteInPlace data/meson.build \
      --replace-fail "/etc/pam.d/" "etc/pam.d/"
    substituteInPlace data/meson.build \
      --replace-fail "/etc/xdg/" "etc/xdg/"
  '';

  meta = {
    homepage = "https://github.com/WayfireWM/wf-shell";
    description = "GTK3-based panel for Wayfire";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      wucke13
      wineee
    ];
    platforms = lib.platforms.unix;
  };
})
