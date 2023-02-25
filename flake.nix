{
  inputs = {
    # nixpkgs.url = github:nixos/nixpkgs;
    nixpkgs.url = "/home/mt/NIXPKGS";

    ts-context.url = github:nvim-treesitter/nvim-treesitter-context;
    ts-context.flake = false;

    ts-playground.url = github:nvim-treesitter/playground;
    ts-playground.flake = false;

    zen.url = github:folke/zen-mode.nvim;
    zen.flake = false;

    virt-column.url = github:lukas-reineke/virt-column.nvim;
    virt-column.flake = false;

    melange.url = github:savq/melange-nvim;
    melange.flake = false;

    telescope-tabs.url = github:LukasPietzschmann/telescope-tabs;
    telescope-tabs.flake = false;

    colorizer.url = github:norcalli/nvim-colorizer.lua;
    colorizer.flake = false;

    neodev.url = github:folke/neodev.nvim;
    neodev.flake = false;

    lspconfig.url = github:neovim/nvim-lspconfig;
    lspconfig.flake = false;

    null-ls.url = github:jose-elias-alvarez/null-ls.nvim;
    null-ls.flake = false;

  };

  outputs = { self, nixpkgs, ... }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      system = system;
      config = { allowUnfree = true; };
    };
    # Just mapping almost all inputs into buildVimPluginFrom2Nix.
    neovimPlugins = builtins.map 
      (name: pkgs.vimUtils.buildVimPluginFrom2Nix {
        name = name;
        src = self.inputs.${name};
      })
      (builtins.attrNames(builtins.removeAttrs self.inputs ["nixpkgs"]));

    dependencies = import ./dependencies.nix pkgs;
    nvim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
      extraMakeWrapperArgs = ''--prefix PATH : "${pkgs.lib.makeBinPath dependencies}"'';
      configure = {
        # extraLuaPackages = [ "${self}/config/lua/?.lua" ];
        customRC = ''
set runtimepath+=${self}/config
lua << EOF
package.path = "${self}/config/lua/?.lua;" .. package.path

require "user.options"
require "user.colorscheme"
require "user.keymaps"
require "user.cmp"
require "user.neo-tree"
require "user.gitsigns"
require "user.virt-column"
require "user.telescope"
require "user.lualine"
require "user.treesitter"
require "user.autocommands"
require "user.lsp"
require "user.popup"

EOF
        '';
        packages.asd.start = neovimPlugins ++ (import ./plugins.nix pkgs.vimPlugins);
      };
    };
  in
  {
    packages.${system}.default = nvim;
    apps.${system}.default = { type = "app"; program = "${nvim}/bin/nvim"; };
    nixosModules.default = {};
  };
}
