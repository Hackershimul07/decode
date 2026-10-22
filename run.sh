#!/data/data/com.termux/files/usr/bin/bash
set -eu

# Replace these values with your GitHub username and repository.
GITHUB_USER="Hackershimul07"
GITHUB_REPO="https://github.com/Hackershimul07/decode"
BRANCH="main"
ENC_FILE="shimul.enc"

command -v python >/dev/null 2>&1 || { pkg install python -y; }
python -m pip install --quiet pycryptodome

TMP_DIR="${TMPDIR:-$HOME/.cache}/shimul_runner"
mkdir -p "$TMP_DIR"
chmod 700 "$TMP_DIR"

BASE_URL="https://raw.githubusercontent.com/${GITHUB_USER}/${GITHUB_REPO}/${BRANCH}"
ENC_PATH="$TMP_DIR/shimul.enc"
SCRIPT_PATH="$TMP_DIR/shimul.py"

echo "[+] Downloading encrypted script from GitHub..."
curl -fLsS "$BASE_URL/$ENC_FILE" -o "$ENC_PATH"

echo "[!] The script will be decrypted temporarily to run."
python - "$ENC_PATH" "$SCRIPT_PATH" <<'PY'
import getpass, sys
from pathlib import Path
from Crypto.Cipher import AES
from Crypto.Protocol.KDF import scrypt

MAGIC = b"SHIMUL_AES_V1"
SALT_SIZE, NONCE_SIZE, TAG_SIZE, KEY_SIZE = 16, 12, 16, 32

blob = Path(sys.argv[1]).read_bytes()
minimum = len(MAGIC) + SALT_SIZE + NONCE_SIZE + TAG_SIZE
if len(blob) < minimum or not blob.startswith(MAGIC):
    raise SystemExit("[-] Invalid encrypted file or wrong GitHub file.")

password = getpass.getpass("Enter AES password: ")
if not password:
    raise SystemExit("[-] Password cannot be empty.")

pos = len(MAGIC)
salt = blob[pos:pos+SALT_SIZE]; pos += SALT_SIZE
nonce = blob[pos:pos+NONCE_SIZE]; pos += NONCE_SIZE
tag = blob[pos:pos+TAG_SIZE]; pos += TAG_SIZE
key = scrypt(password.encode("utf-8"), salt, KEY_SIZE, N=2**14, r=8, p=1)
cipher = AES.new(key, AES.MODE_GCM, nonce=nonce)
cipher.update(MAGIC)
try:
    plaintext = cipher.decrypt_and_verify(blob[pos:], tag)
except ValueError:
    raise SystemExit("[-] Wrong password or corrupted encrypted file.")
Path(sys.argv[2]).write_bytes(plaintext)
PY

echo "[+] Running decrypted script..."
set +e
python "$SCRIPT_PATH"
STATUS=$?
set -e
rm -f "$SCRIPT_PATH"
echo "[+] Temporary plaintext script removed."
exit "$STATUS"
