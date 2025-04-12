# Social Credit Test - Documentation

## 📌 Overview

The **Social Credit Test** is a humorous, interactive bash script designed to simulate a dystopian "social credit" system. It runs in a Linux environment and features:

- System sound effects and music
- Dramatic scoring system
- "Punishments" for wrong answers

**Warning:** This script is for entertainment purposes only. Use in a virtual machine as it makes system modifications.

## 🛠 Installation

### Prerequisites
- Linux system (tested on Manjaro/Arch/Ubuntu)
- Basic dependencies (pulseaudio and etc., terminal emulator , sudo)


### Clone the Repository
```bash
git clone https://github.com/FenchsApps/social-credit-test.git
cd social-credit-test/ChinaLore
chmod +x SocialTest.sh
./SocialTest.sh # DO NOT RUN THIS CRIPT IN SUDO MODE
```
## 🎛 Features

### System Takeover Mode
- Disables keyboard shortcuts
- Blocks SIGINT signals (Ctrl+C)


### Audio Effects
| Sound File | Trigger |
|------------|---------|
| `redsky.mp3` | Startup sequence |
| `correct.mp3` | Right answer |
| `wrong.mp3` | Wrong answer |

## ⚙ Configuration

### Adding Custom Sounds
Place audio files in MP3 format in the `music/` directory:
```
music/
├── redsky.mp3    # Startup music
├── correct.mp3   # Correct answer
├── wrong.mp3     # Wrong answer
```
## 📜 License

MIT License - See [LICENSE](LICENSE) for details.

## 🐛 Known Issues

- Audio may not work in some headless environments
---

**Disclaimer:** This project is satire. The creators do not endorse actual social credit systems. Use responsibly in controlled environments only.
