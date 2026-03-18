{
  description = "My config";
  
  inputs = {
    nixpkgs.url = "git+ssh://github.com/NixOS/nixpkgs?ref=nixos-unstable";
  };
  
  outputs = { self, nixpkgs }: {
    nixosConfigurations."my-laptop" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./configuration.nix ];
    };
  };
}
