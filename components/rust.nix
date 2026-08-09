{
  lib,
  authentik-src,
  authentik-version,
  rustPlatform,
  authentikComponents,
  cmake,
  go,
  perl,
  clangStdenv,
  cacert,
  python,
}:

(rustPlatform.buildRustPackage.override { stdenv = clangStdenv; }) (finalAttrs: {
  pname = "authentik-rust";
  version = authentik-version;
  src = authentik-src;

  __structuredAttrs = true;
  strictDeps = true;

  env = {
    RUSTFLAGS = "--cfg tokio_unstable";
    HOST_CC = "clang";
    PYO3_PYTHON = lib.getExe python;
  };

  cargoHash = "sha256-nClhO2uB/glXymdgrg0ccRc+dG23XY6C5gcYYDfleNc=";
  nativeBuildInputs = [
    cmake
    go
    perl
  ];

  buildInputs = [ python ];

  cargoBuildFlags = [
    "--package"
    "authentik"
    "--no-default-features"
    "--features"
    "core"
    "--locked"
  ];

  nativeCheckInputs = [
    cacert
  ];

  checkFlags = [
    # requieres db with migrations applied
    "--skip=outpost::proxy::session::postgres::tests::save_load_expire_logout"
  ];

  preBuild = ''
    ln -s ${authentikComponents.frontend}/dist web/dist
  '';
})
