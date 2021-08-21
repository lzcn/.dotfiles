# Personal dotfiles.

No warranties, don't blame me.

Any good ideas in here I probably copied from someone else -- even this readme :relaxed:

## Installation

1. clone

```bash
git clone https://www.github.com/lzcn/dotfiles.git .dotfiles
cd .dotfiles
git submodule update --init --recursive
```

2. install dependencies

```bash
./install.sh -h
```

3. setup dotfiles

3.1 manully add env to `~/.zshenv` or run `./setup.sh env`

```
export HOMEBREW_PREFIX=
export CONDA_PREFIX=
```

3.2 setup dotfiles

```bash
./setup.sh -h
```
