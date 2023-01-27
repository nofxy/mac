#!/usr/bin/env bash

# This scripts reports basic battery stats

# DOC: https://support.apple.com/en-us/HT201585

is_int() {
# Test if variable is an integer
  if [[ $1 =~ ^-?[0-9]+$ ]]; then
    return 0 # variable is an integer
  else
    return 1 # variable is not an integer
  fi
}

# All data
ioreg_return=$(ioreg -l)
# Capacity data
design_capacity=$(echo "$ioreg_return" | grep '"DesignCapacity" = ' | awk -F'= ' '{print $2}')
current_capacity=$(echo "$ioreg_return" | grep AppleRawMaxCapacity | awk -F'= ' '{print $2}')
# Cycle count data
design_cycle_count=$(echo "$ioreg_return" | grep '"DesignCycleCount9C" = ' | awk -F'= ' '{print $2}')
current_cycle_count=$(echo "$ioreg_return" | grep '"CycleCount" = ' | awk -F'= ' '{print $2}')


echo -e "\033[32m### Battery Stats ###\033[0m\n"
if is_int "$design_capacity" && is_int "$current_capacity"; then
    echo "Design capacity: $design_capacity"
    echo "Current capacity: $current_capacity"
    capacity_percent=$(echo "scale=4; $current_capacity / $design_capacity * 100" | bc | awk -F'.' '{print $1}')
    echo "Capacity left: $capacity_percent%"
    if [[ "$capacity_percent" -ge 80 ]]; then
      echo -e "\033[32mPASS\033[0m\n"
    else
      echo -e "\033[31mFAIL\033[0m\n"
    fi
else
    echo "ERROR: Either design_capacity or current_capacity varible is not an integer."
fi

echo

if is_int "$design_cycle_count" && is_int "$current_cycle_count"; then
    echo "Design cycle count: $design_cycle_count"
    echo "Current cycle count: $current_cycle_count"
    cycle_percent=$(echo "scale=4; $current_cycle_count / $design_cycle_count * 100" | bc | awk -F'.' '{print $1}')
    echo "Design cycle used: $cycle_percent%"
    if [[ "$cycle_percent" -lt 100 ]]; then
      echo -e "\033[32mPASS\033[0m\n"
    else
      echo -e "\033[31mFAIL\033[0m\n"
    fi
else
    echo "ERROR: Either design_cycle_count or current_cycle_count variable is not an integer."
fi
