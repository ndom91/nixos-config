{
  description = "ndom91 config flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&tag=v0.41.1";
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=ea2501d4556f84d3de86a4ae2f4b22a474555b9f";
    # "git+https://github.com/hyprwm/Hyprland?submodules=1&rev=cba1ade848feac44b2eda677503900639581c3f4";
    hy3 = {
      url = "github:outfoxxed/hy3";
      # url = "github:outfoxxed/hy3?ref=hl0.41.0";
      # url = "github:outfoxxed/hy3?ref=hl{version}"; # where {version} is the hyprland release version
      inputs.hyprland.follows = "hyprland";
    };
    # hyprfocus = {
    #   url = "github:pyt0xic/hyprfocus";
    #   inputs.hyprland.follows = "hyprland";
    # };
    rose-pine-hyprcursor.url = "github:ndom91/rose-pine-hyprcursor";
    # apple-fonts.url = "github:Lyndeno/apple-fonts.nix";

    # hyprland-plugins = {
    #   url = "github:hyprwm/hyprland-plugins";
    #   inputs.hyprland.follows = "hyprland";
    # };
    # nix-gaming.url = "github:fufexan/nix-gaming";

    nix-colors.url = "github:misterio77/nix-colors";
    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.darwin.follows = "";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
    superfile.url = "github:MHNightCat/superfile";
    playwright.url = "github:kalekseev/nixpkgs/playwright-core";
  };

  outputs = { self, unstable, agenix, nix-colors, nixpkgs, ... } @inputs:
    let
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};

      playwrightOverlay = final: prev: {
        inherit (inputs.playwright.packages.${prev.system})
          playwright-driver playwright-test;
      };

      pkgs = import nixpkgs {
        system = system;
        overlays = [ playwrightOverlay ];
      };
      unstablePkgs = unstable.legacyPackages.${system};
    in
    {
      formatter.${system} = pkgs.nixpkgs-fmt;
      nixosConfigurations = {
        ndo4 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit nix-colors;
            unstablePkgs = import unstable {
              config = {
                allowUnfree = true;
              };
              localSystem = { inherit system; };
            };
          };
          modules = [
            ./hosts/ndo4/configuration.nix
            ./packages/protonvpn-wg-quick/default.nix
            agenix.nixosModules.default
          ];
        };
        ndo-gb = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit nix-colors;
            unstablePkgs = import unstable {
              config = {
                allowUnfree = true;
              };
              localSystem = { inherit system; };
            };
          };
          modules = [
            ./hosts/ndo-gb/configuration.nix
            ./packages/protonvpn-wg-quick/default.nix
            agenix.nixosModules.default
          ];
        };
        ndo2 = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit nix-colors;
            unstablePkgs = import unstable {
              config = {
                allowUnfree = true;
              };
              localSystem = { inherit system; };
            };
          };
          modules = [
            ./hosts/ndo2/configuration.nix
            agenix.nixosModules.default
          ];
        };
      };
    };
}
