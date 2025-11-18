{pkgs, ...}: {
  programs.mnw = {
    enable = true;
    plugins = {
      start = with pkgs.vimPlugins; [
        catppuccin-nvim
        mini-basics
        mini-completion
        nvim-lspconfig
        nvim-treesitter.withAllGrammars
        vim-sleuth
        render-markdown-nvim
      ];
    };

    extraBinPath = with pkgs; [
      lua-language-server
      nixd
      nil
      rust-analyzer
      clang-tools
      bash-language-server
    ];

    initLua = builtins.readFile ./init.lua;
  };
}
