{ input, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    # plugins = [ ];
    extraConfig = ''
    '';
    extraLuaConfig = ''
      vim.opt.runtimpath = vim.opt.runtimepath + "${pkgs.vimPlugins.nvim-treesitter.withAllGrammars}"
    '';
    extraPackages = with pkgs; [
      shfmt
      eslint_d
      stylua
      lua-language-server
      pkgs.vimPlugins.telescope-fzf-native-nvim
      pkgs.vimPlugins.nvim-treesitter.withAllGrammars
    ];
  };
}
