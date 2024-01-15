!/bin/bash
# Author Name: Sreelakshmi OdattVenu
# Brief algorithm:
# Step 1: create the  createReport function to generate teh values and display the relevant system  information such as operating system , kernel version, etc.
#Step 2: create the fucntion to check if there is aarcive file exist or not , if exist then display "Archive created " and if not , then create and store the report display inside the file .
#Step 3: Then ask teh user for the user to input their requiered option 1, 2 or 3.
#Step 4 if option 1: then display teh create report function
# Step 5 if option 2 then create the archive file or if exist then display the relevant infoormation 
#Step 6 if option 6 selected , then exit .
# Step 7 if option input is invalid , dispaly an error message to the user to input the relevant options only

# this function is used to create the report and display the relevant information such as the kernel; verison , os name etc.
# Date: 1 December, 2023
# Name:Sreelakshmi Odatt Venu
createReport() {

hostname=$(hostname)
os=$(uname -s)
kernelversion=$(uname -r)
total=$(free -m | awk '/Mem/ {print $2}')
freememory=$(free -m | awk '/Mem/ {print $4}')
    echo "Generating system report..." | tee -a "system_report.log"

    echo "System Information:" | tee -a "system_report.log"

    echo "Hostname: $hostname" | tee -a "system_report.log"
    echo "Operating System: $os" | tee -a "system_report.log"

    echo "Kernel Version: $kernelversion" | tee -a "system_report.log"

    echo "CPU Information:"
    echo "$(lscpu | grep 'Model name')" | tee -a "system_report.log"
    echo "Total Memory: $total MB" | tee -a "system_report.log"
    echo "Free Memory: $freememory MB" | tee -a "system_report.log"
    echo "Disk Usage Information:" | tee -a "system_report.log"
    diskusage=$(df -h / | awk 'NR==2 {print "Total: " $2 ", Used: " $3 ", Free: " $4}')
    echo "$diskusage" | tee -a "system_report.log"

    cpuload=$(top -n 1 -b | grep "Cpu(s)" | awk '{print $2}')
    if (( $(echo "$cpuLoad > 80" | bc) )); then
       echo "WARNING: CPU load out of limits ($cpuload%)n" | tee -a "system_report.log"
    else
        echo "SUCCESS: CPU load is within acceptable limits ($cpuload%)" | tee -a "system_report.log"
    fi


    used=$(free -m | awk 'NR==2 {print $3}')
    memoryusage=$(printf "%.0f" "$(echo "scale=2; $used / $total * 100" | bc)")

    if (( $(echo "$memoryusage > 50" | bc) )); then
       echo "WARNING: Memory usage out of limits ($memoryusage%)" | tee -a "system_report.log"
    else
      echo "SUCCESS: Memory usage is within acceptable limits  ($memoryusage%)" | tee -a "system_report.log"
    fi


    diskusagevalue=$(df -h / | awk 'NR==2 {print $5}' | tr -d '%')
    if (( $(echo "$diskusagevalue > 70" | bc) )); then
       echo "WARNING: Disk usage out of limits ($diskusagevalue%)" | tee -a "system_report.log"
    else
       echo "SUCCESS: Disk usage is within acceptable limits ($diskusagevalue%)" | tee -a "system_report.log"
    fi


}
# This function is used to create the archive file
# Date: 1 December, 2023
# Name:Sreelakshmi Odatt Venu
createArchive() {
    if test -e "system_report.log"; then
        tar -czf "systemreport_archive.tar.gz" "system_report.log"
        echo "Archive created successfully."

    else
         echo "Error: Log file does not exist or is empty. Generating a new report before creating the archive"
         createReport
         tar -czf "systemreport_archive.tar.gz" "system_report.log"
         echo "Archive created successfully."
    fi
}

while true
do
    echo "System Monitoring and Reporting"
    echo "++++++++++++++++++++++++++++++++++++"
    echo "1. Generate System Report"
    echo "2. Create Archive"
    echo "3. Exit"
    echo "++++++++++++++++++++++++++++++++++++"
    echo -n "Enter your choice: "
    read value

    case "$value" in
        "1")
            createReport
            ;;
        "2")
            createArchive
            ;;
        "3")
            break
            ;;
        *)
            echo "Invalid option! Please choose a valid menu item."
            ;; esac
done
                