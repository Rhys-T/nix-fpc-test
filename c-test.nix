(import <nixpkgs> {}).callPackage ({stdenv, writeText}: stdenv.mkDerivation {
    name = "aaa-c-test";
    allowSubstitutes = false;
    src = writeText "hello.c" ''
        #include <stdio.h>
        int main(void) {
            printf("Hello, world.\n");
            return 0;
        }
    '';
    unpackPhase = ''cp "$src" hello.c; touch Makefile'';
    env.NIX_DEBUG = 7;
    env.LDFLAGS = "-lm";
    buildFlags = "hello";
    checkPhase = ''[[ "$(./hello)" == "Hello, world." ]]'';
    doCheck = true;
    installPhase = "install -Dm755 hello $out/bin/hello";
}) {}
