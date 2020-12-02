# find out if pyenv is the file
# or already a function
if ! test -f $(whence pyenv); then
  return
fi

_init_pyenv() {
  unset -f pyenv _pyenv_chpwd_hook _init_pyenv
  chpwd_functions[$chpwd_functions[(i)_pyenv_chpwd_hook]]=()
  if [ -f $HOME/.pyenv-init.zsh  ]; then
    source $HOME/.pyenv-init.zsh
  else
    # regenerate pyenv init source files
    # should better be done in some other init file but not in .zshrc
    # initialization
    pyenv init - > $HOME/.pyenv_init.zsh
    pyenv virtualenv-init - >> $HOME/.pyenv_init.zsh
  fi
}

pyenv() {
  _init_pyenv
  pyenv "$@"
}

_pyenv_chpwd_hook() {
  local DIR=$PWD
  while [ "$DIR" != "/" ]; do
    if [ -f "$DIR/.python-version" ]; then
      _init_pyenv
      break
    fi
    DIR=$DIR:h
  done
}

export chpwd_functions=($chpwd_functions _pyenv_chpwd_hook)
