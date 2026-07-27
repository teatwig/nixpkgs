{
  stdenv,
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook3,
  wayfire,
  wf-shell,
  wayland-scanner,
  fmt,
  gtk3,
  gtkmm3,
  libevdev,
  libxml2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wcm";
  version = "0.11.0-unstable-2026-04-27";

  src = fetchFromGitHub {
    owner = "WayfireWM";
    repo = "wcm";
    rev = "84063a07ccfc5be2a96b98d934271761a1730c2b";
    fetchSubmodules = true;
    hash = "sha256-WL4hXbiCDAKTkeB2zTUlMetS199a+fpnHqGuBTHRVDA=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wayland-scanner
    wrapGAppsHook3
  ];

  buildInputs = [
    wayfire
    wf-shell
    fmt
    gtk3
    gtkmm3
    libevdev
    libxml2
  ];

  meta = {
    homepage = "https://github.com/WayfireWM/wcm";
    description = "Wayfire Config Manager";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      teatwig
      wucke13
      wineee
    ];
    platforms = lib.platforms.unix;
    mainProgram = "wcm";
  };
})
