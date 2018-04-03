FROM 001ben/base-terminal:latest

RUN chsh -s $(which zsh)

# Oh my zsh & completion
RUN export TERM=xterm-256color \
  && sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || true \
  && git clone https://github.com/zsh-users/zsh-completions ~/.oh-my-zsh/custom/plugins/zsh-completions \
  && sed -i'' -e '/^plugins=(/{' -e ':loop;s/)/  zsh-completions\n)/;t;N;b loop' -e '}' ~/.zshrc \
  && echo "autoload -U compinit && compinit" >> ~/.zshrc

# Some great packages
RUN apt-get install -y --no-install-recommends \
  nodejs \
  npm \
  r-base \
  haskell-platform \
  snapd

# .zshrc config
RUN npm install -g pure-prompt \
  && ln -s /usr/local/lib/node_modules/pure-prompt/pure.zsh /usr/local/share/zsh/site-functions/prompt_pure_setup \
  && ln -s /usr/local/lib/node_modules/pure-prompt/async.zsh /usr/local/share/zsh/site-functions/async \
  && echo "autoload -U promptinit; promptinit" >> ~/.zshrc \
  && echo "prompt pure" >> ~/.zshrc \
  && echo "alias n='nvim'" >> ~/.zshrc \
  && echo "alias zconf='nvim ~/.zshrc'" >> ~/.zshrc \
  && echo "alias nconf='nvim ~/.config/nvim/init.vim'" >> ~/.zshrc

# Setup neovim config
RUN curl https://raw.githubusercon  tent.com/Shougo/dein.vim/master/bin/installer.sh > /tmp/installer.sh \
  && sh /tmp/installer.sh ~/.config/nvim/dein/
