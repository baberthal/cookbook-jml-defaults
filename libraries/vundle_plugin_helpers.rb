require 'json'

module VundlePluginHelpers
  def vundle_plugin(plugin_name)
    return plugin_name if full_path?(plugin_name)
    plugin_lookup(plugin_name)
  end

  private

  def full_path?(plugin_name)
    plugin_name =~ %r{.+\w/\w.+}
  end

  def plugin_lookup(plugin_name)
    PLUGIN_LIST.fetch(plugin_name) { plugin_name.to_s }
  end

  PLUGIN_LIST = {
    'vundle' => 'gmarik/Vundle.vim',
    'solarized' => 'altercation/vim-colors-solarized',
    'syntastic' => 'scrooloose/syntastic',
    'chefspec' => 'baberthal/chefspec.vim',
    'vim-tmux' => 'tmux-plugins/vim-tmux',
    'tmux-nav' => 'christoomey/vim-tmux-navigator',
    'tabular' => 'godlygeek/tabular',
    'L9' => 'L9',
    'easy-align' => 'junegunn/vim-easy-align',
    'endwise' => 'tpope/vim-endwise',
    'delimit_mate' => 'Raimondi/delimitMate',
    'matchit' => 'edsono/vim-matchit',
    'surround' => 'tpope/vim-surround',
    'sleuth' => 'tpope/vim-sleuth',
    'repeat' => 'tpope/vim-repeat',
    'fugitive' => 'tpope/vim-fugitive',
    'windowswap' => 'wesQ3/vim-windowswap',
    'ctrlp' => 'kien/ctrlp.vim',
    'nerdtree' => 'scrooloose/nerdtree',
    'bufexplorer' => 'jlanzarotta/bufexplorer',
    'multiple_cursors' => 'terryma/vim-multiple-cursors',
    'commentary' => 'tpope/vim-commentary',
    'ultisnips' => 'SirVer/ultisnips',
    'snippets' => 'honza/vim-snippets',
    'ycm' => 'Valloric/YouCompleteMe',
    'supertab' => 'ervandew/supertab',
    'airline' => 'bling/vim-airline'
  }
end
