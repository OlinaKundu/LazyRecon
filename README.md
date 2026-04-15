# 🕵️‍♂️ LazyRecon: Automated Web Reconnaissance Suite

LazyRecon is a powerful, lightweight Bash script designed to automate the initial information-gathering phase of a web penetration test. By integrating industry-standard tools into a single workflow, it allows security researchers to focus on exploitation rather than manual data collection.

## 🚀 Features
- **Auto-Dependency Management**: Automatically checks for and installs required tools (`nuclei`, `gobuster`, `whatweb`, `curl`) if they are missing.
- **Target Tech Fingerprinting**: Identifies CMS, languages, and server headers using WhatWeb.
- **Fast Vulnerability Scanning**: Leverages Nuclei's template-based engine for high-signal security audits.
- **Hidden Directory Discovery**: Uses Gobuster to brute-force directories and find unlinked sensitive paths.
- **Consolidated Reporting**: Generates a structured, timestamped summary report for rapid analysis.

## 🛠️ Tools Integrated
- **Nuclei**: Template-based vulnerability scanner.
- **Gobuster**: High-speed URI and DNS brute-forcer.
- **WhatWeb**: Next-generation web characterizer.
- **Curl**: Command-line tool for capturing HTTP headers.

## 📥 Installation & Usage

### Prerequisites
You must be running **Kali Linux** (or a Debian-based distro) with `sudo` privileges.

### Quick Start
1. **Clone the repository:**
   ```bash
   git clone [https://github.com/YOUR_USERNAME/LazyRecon.git](https://github.com/YOUR_USERNAME/LazyRecon.git)
   cd LazyRecon

 2. Make the script executable:

Bash
chmod +x lazyrecon.sh

3.Run a scan:

Bash
./lazyrecon.sh [http://example.com](http://example.com)


📊 Sample Output
The script generates a summary.txt in a timestamped folder:

Plaintext
--------------------------------------------------
LAZYRECON SUMMARY REPORT
Target: [http://zero.webappsecurity.com](http://zero.webappsecurity.com)
--------------------------------------------------
[*] Web Server: Server: Apache-Coyote/1.1
[*] Tech Stack: [200 OK] JQuery[1.8.2], HTML5, Bootstrap, Java
[*] Potential Vulnerabilities (Nuclei): 0
[*] Directories Found: 11
🗺️ Future Roadmap
[ ] Implement Subdomain Enumeration (Subfinder/Assetfinder integration).

[ ] Add Active Directory (AD) internal recon module.

[ ] Integrate Discord/Slack Webhooks for scan notifications.

⚠️ Disclaimer
This tool is intended for educational purposes and authorized security testing only. Accessing or scanning targets without prior written consent is illegal. The author is not responsible for any misuse of this tool.
