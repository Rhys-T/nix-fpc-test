# NixOS/nixpkgs#352655: `fpc` seems to bypass the linker wrapper on certain macOS machines, even with the same `.drv`

### Describe the bug
Derivations I've written that use the Free Pascal compiler `fpc` build successfully on my local machine (`x86_64-darwin`, macOS 10.15.7), but when I try to build them on GitHub Actions using the `macos-13` runner, the linker outputs various warnings and errors that don't happen locally, and the build fails.

```
ld: warning: -multiply_defined is obsolete
-macosx_version_min has been renamed to -macos_version_min
ld: warning: ignoring duplicate libraries: '-lc'
ld: library 'm' not found
An error occurred while linking 
```

The really weird part is that the derivation is evaluating to an identical (both name and content) `.drv` file on both my Mac and the GitHub runner, so it _should_ be an identical build environment.

Examining the log closer, I see no evidence that the linker wrapper is being called in the GitHub case. There are no references to `ld-params.XXXXXX` tempfiles in its build log, only `cc-params.XXXXXX` ones. The local log has both. And the arguments that `ld` is complaining about aren't mentioned anywhere in GitHub's version of the log, but they're present locally.

### Steps To Reproduce
Steps to reproduce the behavior:
1. Clone [Rhys-T/nix-fpc-test](https://github.com/Rhys-T/nix-fpc-test) on an Intel Mac. It contains two Nix files: 
   - `fpc-test.nix` builds a simple Hello World program using Free Pascal, which links in `libm` (and doesn't really do anything with it.)
   - `c-test.nix` is basically the same thing, but in C. It also links `libm`.
2. Build each program with <code>NIX_PATH='nixpkgs=https://github.com/NixOS/nixpkgs/archive/refs/heads/nixpkgs-unstable.tar.gz' nix-build <var>lang</var>-test.nix</code> and test it.
3. Fork the repo on GitHub, and enable actions.
4. Trigger the "Test `fpc` inside Nix" workflow manually. A job will appear for each of the test files.
5. The C test will build successfully, but the Free Pascal one will fail with the errors I mentioned above.
6. The `.drv`s and build logs for both test programs will be uploaded as artifacts for the workflow.
7. Compare the `.drv`s with the ones from your local system. The names and contents should be identical.

### Expected behavior
Free Pascal programs should build identically on both my local system and GitHub - or at least fail identically.

### Screenshots
N/A
<!-- If applicable, add screenshots to help explain your problem. -->

### Additional context
While my example derivations here have `NIX_DEBUG=7` set, the problem happens without that variable too.

I have no idea whether the problem is in Nix, Nixpkgs, `fpc`, GitHub, [cachix/install-nix-action](https://github.com/cachix/install-nix-action), or something else I haven't even considered, so I apologize if this is the wrong place to open this issue. About the only thing I've managed to eliminate is [the actual program I was originally trying to package](https://drl.chaosforge.org).
<!-- Add any other context about the problem here. -->

<!-- ### Notify maintainers -->

<!--
Please @ people who are in the `meta.maintainers` list of the offending package or module.
If in doubt, check `git blame` for whoever last touched something.
-->

### Metadata

<!-- Please insert the output of running `nix-shell -p nix-info --run "nix-info -m"` below this line -->

```
these 3 paths will be fetched (1.07 MiB download, 6.70 MiB unpacked):
  /nix/store/zymw9938w9c3wf0n5890mhlklb3cvqx6-DarwinTools-1
  /nix/store/ci1awvn1fa7wi13pf6rc0603hcg64sg3-bash-interactive-5.2p32
  /nix/store/rhkzkb6srxrs2ikvr96g3pz02nl1hjfd-nix-info
copying path '/nix/store/ci1awvn1fa7wi13pf6rc0603hcg64sg3-bash-interactive-5.2p32' from 'https://cache.nixos.org'...
copying path '/nix/store/zymw9938w9c3wf0n5890mhlklb3cvqx6-DarwinTools-1' from 'https://cache.nixos.org'...
copying path '/nix/store/rhkzkb6srxrs2ikvr96g3pz02nl1hjfd-nix-info' from 'https://cache.nixos.org'...
 - system: `"x86_64-darwin"`
 - host os: `Darwin 19.6.0, macOS 10.15.7`
 - multi-user?: `yes`
 - sandbox: `no`
 - version: `nix-env (Nix) 2.24.9`
 - channels(root): `"nixpkgs"`
 - nixpkgs: `/nix/var/nix/profiles/per-user/root/channels/nixpkgs`
```

---

Add a :+1: [reaction] to [issues you find important].

[reaction]: https://github.blog/2016-03-10-add-reactions-to-pull-requests-issues-and-comments/
[issues you find important]: https://github.com/NixOS/nixpkgs/issues?q=is%3Aissue+is%3Aopen+sort%3Areactions-%2B1-desc
