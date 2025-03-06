# My dotfiles

This directory contains the dotfiles for my system

## Requirements

Ensure you have the following installed on you system

### Stow Git

```
pacman -Sy stow git
```

## Installation

First, check out the dotfiles repo in you $HOME directory using git

```
$ git clone https://github.com/KalEl117/dotfiles.git
$ cd dotfiles
```

then use GNU stow to create symlinks

```

$ stow .
```





