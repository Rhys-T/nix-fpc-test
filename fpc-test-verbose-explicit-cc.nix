(import <nixpkgs> {}).callPackage ({stdenv, lib, symlinkJoin, makeBinaryWrapper, fpc, writeText}: let
    fpc-wrapper = symlinkJoin {
        name = "${lib.getName fpc}-wrapper-${lib.getVersion fpc}";
        paths = [fpc];
        nativeBuildInputs = [makeBinaryWrapper];
        postBuild = ''
            wrapProgram "$out"/bin/fpc --add-flags '-FD${lib.getBin stdenv.cc}/bin'
        '';
    };
in stdenv.mkDerivation {
    name = "aaa-fpc-test";
    allowSubstitutes = false;
    src = writeText "hello.pas" ''
        program Hello;
        {$LINKLIB m}
        begin
            writeln ('Hello, world.');
        end.
    '';
    dontUnpack = true;
    nativeBuildInputs = [fpc-wrapper];
    # env.NIX_DEBUG = 7;
    buildPhase = "fpc -va -o./hello $src";
    checkPhase = ''[[ "$(./hello)" == "Hello, world." ]]'';
    doCheck = true;
    installPhase = "install -Dm755 hello $out/bin/hello";
}) {}
