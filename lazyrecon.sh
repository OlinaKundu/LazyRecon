#!/bin/bash

# Target Input
TARGET=$1

# Create a timestamped directory
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
OUT_DIR="recon_$TARGET_$TIMESTAMP"

if [ -z "$TARGET" ]; then
    echo "Usage: ./lazyrecon.sh <target_url_or_ip>"
    exit 1
fi

mkdir -p "$OUT_DIR"
echo "Folder $OUT_DIR created for results."

# Dependency Check & Install
echo "[*] Checking for required tools..."
TOOLS=("curl" "nuclei" "whatweb" "gobuster")

for tool in "${TOOLS[@]}"; do
    if ! command -v "$tool" &> /dev/null; then
        echo "[!] $tool not found. Installing..."
        sudo apt-get update && sudo apt-get install -y "$tool"
    else
        echo "[✓] $tool is already installed."
    fi
done

# Banner Grabbing
echo "[+] Capturing HTTP headers..."
curl -s -I "$TARGET" > "$OUT_DIR/headers.txt"

# Web Vulnerability Scan (Nuclei)
echo "[+] Starting Nuclei scan (Fast & Template-based)..."

# This runs nuclei on the target and saves only the interesting "medium" and "high" findings
nuclei -u "$TARGET" -update-templates -as -silent -o "$OUT_DIR/nuclei.txt"

echo "[!] Nuclei scan complete. Results saved to $OUT_DIR/nuclei.txt"

# CMS Detection
echo "[+] Identifying CMS and technologies..."
whatweb "$TARGET" > "$OUT_DIR/whatweb.txt"


# Directory Brute-forcing
echo "[+] Starting directory brute-force with Gobuster..."

# Defining the wordlist path (Standard Kali path)
WORDLIST="/usr/share/wordlists/dirb/common.txt"

if [ -f "$WORDLIST" ]; then
    gobuster dir -u "$TARGET" -w "$WORDLIST" -q --no-progress -o "$OUT_DIR/gobuster.txt"
    echo "[!] Directory discovery complete. Results in $OUT_DIR/gobuster.txt"
else
    echo "[X] Error: Wordlist not found at $WORDLIST. Skipping Gobuster."
fi


# Final Report Generation
echo "--------------------------------------------------" > "$OUT_DIR/summary.txt"
echo "LAZYRECON SUMMARY REPORT" >> "$OUT_DIR/summary.txt"
echo "Target: $TARGET" >> "$OUT_DIR/summary.txt"
echo "Scan Date: $(date)" >> "$OUT_DIR/summary.txt"
echo "--------------------------------------------------" >> "$OUT_DIR/summary.txt"

# 1. Pulling the Server Header (Added a fallback if empty)
SERVER_HEADER=$(grep -i "Server" "$OUT_DIR/headers.txt" | head -1)
echo "[*] Web Server: ${SERVER_HEADER:-Not Detected}" >> "$OUT_DIR/summary.txt"

# 2. Pulling the CMS Info (Added a check to see if the file exists)
if [ -f "$OUT_DIR/whatweb.txt" ]; then
    echo "[*] Tech Stack: $(head -n 1 "$OUT_DIR/whatweb.txt")" >> "$OUT_DIR/summary.txt"
else
    echo "[*] Tech Stack: Not Detected" >> "$OUT_DIR/summary.txt"
fi

# 3. Counting findings (Improved logic to prevent "No such file" errors)
# This checks if the file exists; if not, it reports 0.
NUC_COUNT=$([ -f "$OUT_DIR/nuclei.txt" ] && wc -l < "$OUT_DIR/nuclei.txt" || echo "0")
GOB_COUNT=$([ -f "$OUT_DIR/gobuster.txt" ] && wc -l < "$OUT_DIR/gobuster.txt" || echo "0")

echo "[*] Potential Vulnerabilities (Nuclei): $NUC_COUNT" >> "$OUT_DIR/summary.txt"
echo "[*] Directories Found: $GOB_COUNT" >> "$OUT_DIR/summary.txt"

echo -e "\n[!] All done! Check $OUT_DIR/summary.txt for the highlights."
