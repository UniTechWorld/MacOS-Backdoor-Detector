# MacOS Backdoor Detector / macOS 后门检测工具

## Introduction / 简介

**English:**  
MacOS Backdoor Detector is a bash script designed for digital forensics and incident response on macOS systems. It helps security professionals identify potentially malicious connections and processes, with a focus on detecting communications with servers outside of China.

**中文:**  
macOS 后门检测工具是一个用于 macOS 系统的数字取证和应急响应的 Bash 脚本。它帮助安全专业人员识别潜在的恶意连接和进程，特别关注与CN地区以外服务器的通信。

## Features / 功能特点

**English:**  
- Identifies all established network connections
- Performs IP geolocation lookups to determine the country of origin
- Highlights connections to servers outside of China
- Maps suspicious connections to their corresponding processes
- Provides a clean summary of process name, foreign IP, and process path

**中文:**  
- 识别所有已建立的网络连接
- 执行 IP 地理位置查询以确定源国家
- 高亮显示与中国以外服务器的连接
- 将可疑连接映射到相应的进程
- 提供简洁明了的进程名称、外联 IP 和进程路径摘要

## Requirements / 系统要求

**English:**  
- macOS operating system
- Root/sudo privileges
- Internet connection (for IP geolocation lookup)
- Required tools: bash, netstat, lsof, awk, curl, grep (all included in standard macOS installations)

**中文:**  
- macOS 操作系统
- Root/sudo 权限
- 互联网连接（用于 IP 地理位置查询）
- 所需工具：bash、netstat、lsof、awk、curl、grep（所有工具均包含在标准 macOS 安装中）

## Installation / 安装

**English:**  
1. Clone this repository:
   ```
   git clone https://github.com/UniTechWorld/MacOS-Backdoor-Detector.git
   ```
2. Change to the project directory:
   ```
   cd Macos-Backdoor-Detector
   ```
3. Make the script executable:
   ```
   chmod +x findBackdoor.sh
   ```

**中文:**  
1. 克隆此仓库：
   ```
   git clone https://github.com/UniTechWorld/MacOS-Backdoor-Detector.git
   ```
2. 进入项目目录：
   ```
   cd Macos-Backdoor-Detector
   ```
3. 使脚本可执行：
   ```
   chmod +x findBackdoor.sh
   ```

## Usage / 使用方法

**English:**  
Run the script with sudo privileges:
```
sudo ./findBackdoor.sh
```

**中文:**  
使用 sudo 权限运行脚本：
```
sudo ./findBackdoor.sh
```

## Output / 输出说明

**English:**  
The script will output:
1. All established network connections
2. Foreign IP addresses with their country information
3. Warnings for connections to non-Chinese IP addresses
4. A summary table with the format: `Process Name | Foreign IP | Process Path`

**中文:**  
脚本将输出：
1. 所有已建立的网络连接
2. 外部 IP 地址及其国家信息
3. 对连接到非中国 IP 地址的警告
4. 格式为 `进程名 | 外联IP | 进程文件位置` 的摘要表格

## Notice / 注意事项

**English:**  
- This script uses the free ip-api.com service for IP geolocation, which has usage limitations.
- The script requires sudo privileges to access process information.
- Not all connections to non-Chinese IPs are malicious; this tool is meant to assist in investigations, not to provide definitive verdicts.

**中文:**  
- 此脚本使用免费的 ip-api.com 服务进行 IP 地理位置查询，该服务有使用限制。
- 脚本需要 sudo 权限才能访问进程信息。
- 并非所有连接到非CN地区 IP 的连接都是恶意的；此工具旨在协助调查，而不是提供最终判断。

## License / 许可证

**English:**  
MIT License

**中文:**  
MIT 许可证 
