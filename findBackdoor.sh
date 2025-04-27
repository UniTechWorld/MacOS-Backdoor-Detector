#!/bin/bash

echo "--- Checking Established Network Connections ---"
net_output=$(netstat -an | awk '$NF == "ESTABLISHED"')
if [ -n "$net_output" ]; then
  echo "Found Established Connections:"
  echo "$net_output"
  
  echo -e "\n--- Checking Foreign IP Addresses ---"
  # 提取Foreign Address，并去除端口号部分
  foreign_ips=$(echo "$net_output" | awk '{print $5}' | cut -d. -f1-4 | sort | uniq)
  
  if [ -n "$foreign_ips" ]; then
    echo "Found Foreign IP Addresses:"
    
    # 存储非中国IP地址
    suspicious_ips=()
    
    # 检查每个IP的地理位置
    for ip in $foreign_ips; do
      echo -n "Checking IP: $ip - "
      # 使用ip-api.com检查IP地理位置
      ip_info=$(curl -s "http://ip-api.com/json/$ip?fields=status,country,countryCode")
      
      # 提取国家信息
      status=$(echo "$ip_info" | grep -o '"status":"[^"]*"' | cut -d'"' -f4)
      
      if [ "$status" = "success" ]; then
        country=$(echo "$ip_info" | grep -o '"country":"[^"]*"' | cut -d'"' -f4)
        country_code=$(echo "$ip_info" | grep -o '"countryCode":"[^"]*"' | cut -d'"' -f4)
        
        echo "Location: $country ($country_code)"
        
        # 检查是否为中国以外的IP
        if [ "$country_code" != "CN" ]; then
          echo "⚠️  WARNING: Non-Chinese IP detected: $ip - $country ($country_code)"
          suspicious_ips+=("$ip")
        fi
      else
        echo "Failed to get location info"
      fi
    done
    
    # 如果发现非中国IP地址，定位对应的进程
    if [ ${#suspicious_ips[@]} -gt 0 ]; then
      echo -e "\n--- Suspicious Processes Summary ---"
      echo "Process Name | Foreign IP | Process Path"
      echo "-------------|------------|-------------"
      
      for suspicious_ip in "${suspicious_ips[@]}"; do
        # 获取与此IP相关的所有连接（包含端口信息）
        connections=$(echo "$net_output" | grep "$suspicious_ip")
        
        if [ -n "$connections" ]; then
          # 对每个连接获取进程信息
          while read -r connection; do
            foreign_addr=$(echo "$connection" | awk '{print $5}')
            local_addr=$(echo "$connection" | awk '{print $4}')
            
            # 提取本地端口
            local_port=$(echo "$local_addr" | cut -d. -f5)
            if [ -n "$local_port" ]; then
              # 获取进程信息 (需要sudo权限)
              process_info=$(sudo lsof -i :$local_port | grep -v "COMMAND" | head -1)
              
              if [ -n "$process_info" ]; then
                # 提取PID和命令
                pid=$(echo "$process_info" | awk '{print $2}')
                cmd=$(echo "$process_info" | awk '{print $1}')
                
                # 获取进程可执行文件路径
                proc_path=$(ps -p $pid -o command= | awk '{print $1}')
                
                # 如果路径是相对路径，尝试使用which命令找到完整路径
                if [[ "$proc_path" != /* ]]; then
                  which_path=$(which $proc_path 2>/dev/null)
                  if [ -n "$which_path" ]; then
                    proc_path=$which_path
                  fi
                fi
                
                # 如果仍然找不到路径，尝试使用lsof查找可执行文件
                if [[ "$proc_path" != /* ]]; then
                  exe_path=$(sudo lsof -p $pid | grep "txt" | head -1 | awk '{print $9}')
                  if [ -n "$exe_path" ]; then
                    proc_path=$exe_path
                  fi
                fi
                
                echo "$cmd | $foreign_addr | $proc_path"
              fi
            fi
          done <<< "$connections"
        fi
      done
    fi
  else
    echo "No Foreign IP Addresses Found."
  fi
else
  echo "No Established Connections Found."
fi
echo "----------------------------------------------"

