# SPDX-FileCopyrightText: 2022 The Standard Authors
# SPDX-FileCopyrightText: 2022 Kevin Amado <kamadorueda@gmail.com>
#
# SPDX-License-Identifier: Unlicense
{
  description = "The Nix Flakes framework for perfectionists with deadlines";
  # override downstream with inputs.std.inputs.nixpkgs.follows = ...
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  inputs.yants.url = "github:divnix/yants";
  inputs.yants.inputs.nixpkgs.follows = "nixpkgs";
  inputs.dmerge.url = "github:divnix/data-merge";
  inputs.dmerge.inputs.nixlib.follows = "nixpkgs";
  inputs.dmerge.inputs.yants.follows = "yants";
  /*
  Auxiliar inputs used in builtin libraries or for the dev environment.
  */
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    devshell.url = "github:numtide/devshell";
    devshell.inputs.nixpkgs.follows = "nixpkgs";
    devshell.inputs.flake-utils.follows = "flake-utils";
    nixago.url = "github:nix-community/nixago";
    nixago.inputs.nixpkgs.follows = "nixpkgs";
    nixago.inputs.nixago-exts.url = "github:divnix/blank";
    nixago.inputs.flake-utils.follows = "flake-utils";
    mdbook-kroki-preprocessor = {
      url = "github:JoelCourtney/mdbook-kroki-preprocessor";
      flake = false;
    };
  };
  outputs = inputs: let
    clades = import ./src/clades.nix {inherit (inputs) nixpkgs;};
    incl = import ./src/incl.nix {inherit (inputs) nixpkgs;};
    deSystemize = import ./src/de-systemize.nix;
    grow = import ./src/grow.nix {inherit (inputs) nixpkgs yants;};
    growOn = import ./src/grow-on.nix {inherit (inputs) nixpkgs yants;};
    harvest = import ./src/harvest.nix {inherit (inputs) nixpkgs;};
    l = inputs.nixpkgs.lib // builtins;
  in
    {
      inherit (inputs) yants dmerge; # convenience re-exports
      inherit clades;
      inherit (clades) runnables installables functions data devshells containers files microvms nixago;
      inherit grow growOn deSystemize incl harvest;
      systems = l.systems.doubles;
    }
    # on our own account ...
    // (import ./dogfood.nix {inherit inputs growOn clades harvest;});
}
