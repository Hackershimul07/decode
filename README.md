# Shimul AES GitHub Runner (Termux)

## 1) Install dependency
```bash
pkg install python curl -y
python -m pip install pycryptodome
```

## 2) Encrypt your original script
Keep `protect.py` next to your original `shimul.py`:
```bash
python protect.py encrypt shimul.py shimul.enc
```
Use a strong password and keep it safe. Do not commit `shimul.py` to a public repository.

## 3) Upload to GitHub
Upload only:
- `shimul.enc`
- `run.sh`

`protect.py` is only needed to create/update the encrypted file; do not put your plaintext script in a public repo.

## 4) Configure run.sh
Edit `run.sh` and replace:
- `YOUR_GITHUB_USERNAME`
- `YOUR_REPOSITORY`

Ensure the branch name matches (`main` by default).

## 5) One-command runner
After uploading `run.sh`, run this in Termux (replace placeholders):
```bash
curl -fLsS https://raw.githubusercontent.com/YOUR_GITHUB_USERNAME/YOUR_REPOSITORY/main/run.sh -o run.sh && bash run.sh
```

It downloads `shimul.enc`, asks for the AES password, decrypts it to a temporary path, runs it, and deletes the temporary `.py` afterward.

## Security notes
- The decrypted Python code exists on the device while running and can be recovered by a determined user.
- Keep the password separate from the repository. Do not hard-code it into `run.sh`.
- Anyone who has the encrypted file and password can decrypt it.
- Use only with scripts and APIs you are authorized to use.
