# 🔐 Shimul Decode — AES Protected Python Runner

A password-protected Python script runner for Android Termux. It downloads an encrypted script from GitHub, decrypts it with AES-256-GCM, and runs it.

## ✨ Features

- 🔐 AES-256-GCM authenticated encryption
- 🔑 Password-based key derivation using scrypt
- 📱 Designed for Android Termux
- 🌐 Downloads encrypted scripts from GitHub
- ▶️ Simple one-command launch
- 🧹 Removes the temporary decrypted Python file after execution

## 📦 Requirements

- Android with Termux
- Python 3
- Internet connection
- AES password used during encryption

## 🚀 Installation

Install the required packages:

```bash
pkg update
pkg install python curl -y
python -m pip install pycryptodome
```

## ⚡ One-Command Launch

Run this command in Termux:

```bash
pkg install python curl -y && python -m pip install pycryptodome && curl -fLsS https://raw.githubusercontent.com/Hackershimul07/decode/main/run.sh -o run.sh && bash run.sh
```

The runner will download the encrypted file, ask for your AES password, decrypt it temporarily, and run the Python script.

## 🛡️ Security Notes

- Never publish your AES password.
- AES encryption protects the stored file, but the script is decrypted while running.
- A determined user may recover the decrypted code from the device.
- Do not hard-code passwords or secret keys into public scripts.
- Use this tool only with scripts and APIs you are authorized to access.

## 👨‍💻 Repository

GitHub: https://github.com/Hackershimul07/decode

---

**Made for Termux by Hackershimul07**
