# Automated Project Bootstrapping & Process Management

## Overview
This repository contains a shell script (`setup_project.sh`) designed to automate the deployment of a **Student Attendance Tracker** environment. It serves as a "Project Factory" that:
1.  Creates a standardized directory structure.
2.  Generates necessary source code files (Python, JSON, CSV, Logs).
3.  Dynamically configures application settings using stream editing (`sed`).
4.  Handles process interruptions gracefully using **Signal Traps**.

## Prerequisites
*   A Linux/Unix environment (Bash shell).
*   **Python 3** (required to run the generated application).

## Installation & Usage

1.  **Clone the Repository**
    ```bash
    git clone https://github.com/s-chukwu/deploy_agent_s-chukwu.git
    cd deploy_agent_s-chukwu
    ```

2.  **Make the Script Executable**
    Before running the script, ensure it has execution permissions:
    ```bash
    chmod +x setup_project.sh
    ```

3.  **Run the Script**
    Execute the script to start the bootstrap process:
    ```bash
    ./setup_project.sh
    ```

4.  **Follow the Prompts**
    *   Enter a **Tracker Identifier** (e.g., `S2025`).
    *   Choose whether to update the **Attendance Thresholds** (Warning/Failure percentages).

## Features

### 1. Dynamic Configuration
The script asks if you want to modify the default attendance thresholds (75% / 50%). If you choose "Yes," it uses `sed` to edit the `config.json` file in place with your custom values.

### 2. The "Safety Net" (Archive Feature)
The script includes a **Signal Trap** for `SIGINT` (Ctrl+C).
*   **How to Trigger:** Run the script and press `Ctrl+C` at any prompt.
*   **What Happens:**
    1.  The script catches the signal.
    2.  It bundles the current directory into a compressed archive (e.g., `attendance_tracker_v1_archive.tar.gz`).
    3.  It deletes the incomplete folder to keep the workspace clean.
    4.  It exits gracefully.

## Generated Directory Structure
After a successful run, the following structure is created:

```text
attendance_tracker_{input}/
├── attendance_checker.py   # Main Application Logic
├── Helpers/
│   ├── assets.csv          # Student Data
│   └── config.json         # Configuration Settings
└── reports/
    └── reports.log         # Activity Logs
```

Video link: https://www.loom.com/share/f0386f258d61427eb6271860d70b97cd

---

