export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
export PATH="$PATH:/usr/local/bin" # Added by Toolbox App
eval "$(pyenv init --path)"
source ~/emsdk/emsdk_env.sh

echo "from zprofile"

test -r ~/.zshrc
