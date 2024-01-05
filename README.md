Neovim config based on [LazyVim](https://github.com/LazyVim/LazyVim)

## Features


- differences to LazyVim:
    - some extra plugins under `./lua/plugins/`
    - minor changes in keymappings and such

## Requirements

- Neovim >= **0.9.0** (needs to be built with **LuaJIT**)
- Git >= **2.19.0** (for partial clones support)
- [lazygit](https://github.com/jesseduffield/lazygit#installation)
- npm
- [ripgrep](https://github.com/BurntSushi/ripgrep)
- [Nerd Font](https://www.nerdfonts.com/)

## Getting Started

<details><summary>Try it with Docker</summary>

```sh
docker run -w /root -it --rm alpine:edge sh -uelic '
  apk add git lazygit neovim ripgrep alpine-sdk --update
  git clone https://github.com/linusboehm/starter ~/.config/nvim
  cd ~/.config/nvim
  nvim
```

</details>

<details><summary>Install the <a href="https://github.com/LazyVim/starter">LazyVim Starter</a></summary>

- Make a backup of your current Neovim files:

  ```sh
  mv ~/.config/nvim ~/.config/nvim.bak
  mv ~/.local/share/nvim ~/.local/share/nvim.bak
  ```

- Clone the starter

  ```sh
    mkdir ~/.config
    cd ~/.config
    git clone git@github.com:linusboehm/neovim.git nvim
  ```

- Remove the `.git` folder, so you can add it to your own repo later

  ```sh
  rm -rf ~/.config/nvim/.git
  ```

- Start Neovim!

  ```sh
  nvim
  ```

</details>
