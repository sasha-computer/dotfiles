# Cursor CLI (Agent) - AI-powered coding assistant for the terminal
{ lib, stdenv, fetchurl, autoPatchelfHook, gcc-unwrapped }:

let
  version = "2026.01.28-fd13201";
  arch = if stdenv.hostPlatform.isAarch64 then "arm64" else "x64";
in
stdenv.mkDerivation {
  pname = "cursor-cli";
  inherit version;

  src = fetchurl {
    url = "https://downloads.cursor.com/lab/${version}/linux/${arch}/agent-cli-package.tar.gz";
    hash = "sha256-Nj6q11iaa++b5stsEu1eBRAYUFRPft84XcHuTCZL5D0=";
  };

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [ gcc-unwrapped.lib stdenv.cc.cc.lib ];

  sourceRoot = "dist-package";

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin $out/lib/cursor-cli

    # Copy all files to lib
    cp -r . $out/lib/cursor-cli/

    # Create symlinks in bin
    ln -s $out/lib/cursor-cli/cursor-agent $out/bin/cursor-agent
    ln -s $out/lib/cursor-cli/cursor-agent $out/bin/agent
    runHook postInstall
  '';

  meta = with lib; {
    description = "Cursor Agent - AI-powered coding assistant for the terminal";
    homepage = "https://cursor.com/cli";
    license = licenses.unfree;
    platforms = [ "x86_64-linux" "aarch64-linux" ];
    mainProgram = "agent";
  };
}
