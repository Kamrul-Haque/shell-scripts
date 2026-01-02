set -e

echo "🔧 Installing required packages..."
sudo apt update
sudo apt install -y zsh git curl wget unzip fonts-powerline

echo "📦 Installing Oh My Zsh..."
export RUNZSH=no
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo "🎨 Installing Powerlevel10k theme..."
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"

echo "🔌 Installing Zsh plugins..."
git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-completions "$ZSH_CUSTOM/plugins/zsh-completions"

echo "🔤 Installing Meslo Nerd Font (required by Powerlevel10k)..."
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/Meslo.zip
unzip -o Meslo.zip -d meslo
fc-cache -fv
cd ~
rm -f ~/.local/share/fonts/Meslo.zip

echo "🛠 Updating ~/.zshrc..."

# Set theme
sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc

# Set plugins
if grep -q "^plugins=" ~/.zshrc; then
  sed -i 's/^plugins=.*/plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)/' ~/.zshrc
else
  echo 'plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)' >> ~/.zshrc
fi

echo "✅ Installation complete!"
echo "🔁 Restart your terminal or run: zsh"
echo "🖋 Set your terminal font to: MesloLGS NF"
