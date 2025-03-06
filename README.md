# Download latest nvim

1. Download neovim

```bash
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
```

2. Unpack nvim to /opt folder

```bash
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
```

3. Add to path in .bashrc

```bash
export PATH="/opt/nvim-linux-x86_64/bin:$PATH"
```

4. Reload bash config

```bash
source ~/.bashrc
```

5. Create folders `~/.config/nvim`

```bash
mkdir -p ~/.config/nvim
```

6. Clone repo into `~/.config/nvim`

```bash
git clone https://github.com/hallstrom91/ssh_server_neovim.git ~/.config/nvim
```

7. Open neovim with command `nvim` - all plugins etc will be installed
