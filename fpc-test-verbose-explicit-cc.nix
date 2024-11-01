(import <nixpkgs> {}).callPackage ({stdenv, lib, fpc, writeText}: stdenv.mkDerivation {
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
    nativeBuildInputs = [fpc];
    # env.NIX_DEBUG = 7;
    buildPhase = "fpc -va -FD${lib.getBin stdenv.cc}/bin -o./hello $src";
    checkPhase = ''[[ "$(./hello)" == "Hello, world." ]]'';
    doCheck = true;
    installPhase = "install -Dm755 hello $out/bin/hello";
}) {}
