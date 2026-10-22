#!/usr/bin/env python3
"""Encrypt/decrypt a Python script with AES-256-GCM."""
import getpass
import sys
from pathlib import Path
from Crypto.Cipher import AES
from Crypto.Protocol.KDF import scrypt
from Crypto.Random import get_random_bytes

MAGIC = b"SHIMUL_AES_V1"
SALT_SIZE = 16
NONCE_SIZE = 12
TAG_SIZE = 16
KEY_SIZE = 32

def derive_key(password, salt):
    return scrypt(password.encode("utf-8"), salt, KEY_SIZE, N=2**14, r=8, p=1)

def encrypt_file(source, destination, password):
    plaintext = Path(source).read_bytes()
    salt = get_random_bytes(SALT_SIZE)
    nonce = get_random_bytes(NONCE_SIZE)
    cipher = AES.new(derive_key(password, salt), AES.MODE_GCM, nonce=nonce)
    cipher.update(MAGIC)
    ciphertext, tag = cipher.encrypt_and_digest(plaintext)
    Path(destination).write_bytes(MAGIC + salt + nonce + tag + ciphertext)
    print(f"[+] Encrypted: {destination}")

def decrypt_bytes(blob, password):
    min_size = len(MAGIC) + SALT_SIZE + NONCE_SIZE + TAG_SIZE
    if len(blob) < min_size or not blob.startswith(MAGIC):
        raise ValueError("Invalid encrypted file")
    pos = len(MAGIC)
    salt = blob[pos:pos+SALT_SIZE]; pos += SALT_SIZE
    nonce = blob[pos:pos+NONCE_SIZE]; pos += NONCE_SIZE
    tag = blob[pos:pos+TAG_SIZE]; pos += TAG_SIZE
    cipher = AES.new(derive_key(password, salt), AES.MODE_GCM, nonce=nonce)
    cipher.update(MAGIC)
    return cipher.decrypt_and_verify(blob[pos:], tag)

def main():
    if len(sys.argv) != 4 or sys.argv[1] not in ("encrypt", "decrypt"):
        print("Usage: python protect.py encrypt input.py output.enc")
        print("   or: python protect.py decrypt input.enc output.py")
        return 2
    password = getpass.getpass("AES password: ")
    if not password:
        print("[-] Password cannot be empty")
        return 2
    try:
        if sys.argv[1] == "encrypt":
            encrypt_file(sys.argv[2], sys.argv[3], password)
        else:
            Path(sys.argv[3]).write_bytes(decrypt_bytes(Path(sys.argv[2]).read_bytes(), password))
            print(f"[+] Decrypted: {sys.argv[3]}")
    except Exception as exc:
        print(f"[-] Error: {exc}")
        return 1
    return 0

if __name__ == "__main__":
    raise SystemExit(main())
