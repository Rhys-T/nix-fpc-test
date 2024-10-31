# `fpc` seems to bypass the linker wrapper on certain macOS machines, even with the same `.drv`

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

I have no idea whether the problem is in Nix, Nixpkgs, `fpc`, GitHub, cachix/install-nix-action, or something else I haven't even considered, so I apologize if this is the wrong place to open this issue. About the only thing I've managed to eliminate is the actual program I was originally trying to package.

### Steps To Reproduce
Steps to reproduce the behavior:
1. ...
2. ...
3. ...

### Expected behavior
A clear and concise description of what you expected to happen.

### Screenshots
If applicable, add screenshots to help explain your problem.

### Additional context
Add any other context about the problem here.

### Notify maintainers

<!--
Please @ people who are in the `meta.maintainers` list of the offending package or module.
If in doubt, check `git blame` for whoever last touched something.
-->

### Metadata

<!-- Please insert the output of running `nix-shell -p nix-info --run "nix-info -m"` below this line -->

---

Add a :+1: [reaction] to [issues you find important].

[reaction]: https://github.blog/2016-03-10-add-reactions-to-pull-requests-issues-and-comments/
[issues you find important]: https://github.com/NixOS/nixpkgs/issues?q=is%3Aissue+is%3Aopen+sort%3Areactions-%2B1-desc
