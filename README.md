# 🔐 Shimul Decode

<p align="center">
  <b>Password-Protected Python Runner for Termux</b>
</p>

A simple GitHub-based Python runner for Android Termux. Download an encrypted Python script, enter your password, and run it using a simple terminal command.

## ✨ Features

- 🔐 AES-256-GCM authenticated encryption
- 🔑 Password-based key derivation using scrypt
- 📱 Android Termux support
- 🌐 Downloads encrypted scripts from GitHub
- ⚡ Simple `SHIMUL` terminal command
- 🧹 Removes the temporary decrypted script after execution

## 📋 Requirements

- Android device
- Termux
- Internet connection
- Correct AES password

## 🚀 Quick Start

Open Termux and run:

```bash
pkg install python curl -y && python -m pip install pycryptodome && mkdir -p ~/bin && curl -fLsS https://raw.githubusercontent.com/Hackershimul07/decode/main/run.sh -o ~/run.sh && printf '#!/data/data/com.termux/files/usr/bin/bash\nexec bash "$HOME/run.sh" "$@"\n' > ~/bin/SHIMUL && chmod +x ~/bin/SHIMUL && (grep -qxF 'export PATH="$HOME/bin:$PATH"' ~/.bashrc 2>/dev/null || echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc) && export PATH="$HOME/bin:$PATH" && bash ~/run.sh
```

## ⚡ Run Again

After setup, open Termux and type:

```bash
SHIMUL
```

Enter your AES password when prompted.

## 🛡️ Security Notes

- Never share your AES password publicly.
- Keep your original Python source and encryption password safe.
- The script is decrypted temporarily while running, so encryption does not guarantee complete source-code secrecy.
- Use only scripts and APIs you are authorized to access.

## 👨‍💻 Developer

**Hackershimul07**

GitHub Repository: https://github.com/Hackershimul07/decode

---

*Made for Android Termux.*
