

#!/bin/bash

# Function to find the index of the least recently used page
find_lru_page() {
    lru_index=0
    lru_time=${time_array[0]}
    for ((i=1; i<$num_frames; i++)); do
        if [ ${time_array[$i]} -lt $lru_time ]; then
            lru_time=${time_array[$i]}
            lru_index=$i
        fi
    done
    return $lru_index
}

# Initialize variables
num_frames=3  # Number of page frames
num_pages=7   # Number of pages in the input sequence
page_sequence=(1 2 3 4 1 2 5)  # Input page sequence
page_faults=0  # Counter for page faults
declare -a page_table  # Page table array
declare -a time_array  # Time array to track the usage of pages

# Initialize page table and time array
for ((i=0; i<$num_frames; i++)); do
    page_table[$i]=-1
    time_array[$i]=0
done

# Iterate over the page sequence
for ((i=0; i<$num_pages; i++)); do
    page=${page_sequence[$i]}

    # Check if the page is already present in the page table
    found=0
    for ((j=0; j<$num_frames; j++)); do
        if [ $page -eq ${page_table[$j]} ]; then
            found=1
            time_array[$j]=$i  # Update the time of usage
            break
        fi
    done

    # Page fault occurred
    if [ $found -eq 0 ]; then
        page_faults=$((page_faults+1))
        find_lru_page  # Find the least recently used page
        lru_index=$?
        page_table[$lru_index]=$page  # Replace the LRU page
        time_array[$lru_index]=$i  # Update the time of usage
    fi

    # Print the page table after each reference
    echo -n "Page table: "
    for ((j=0; j<$num_frames; j++)); do
        echo -n "${page_table[$j]} "
    done
    echo ""
done

echo "Total page faults: $page_faults"

# #!/bin/bash


# echo "Enter a list of numbers Of Array:"
# read -a nums


# sum_odd=0
# sum_even=0


# for num in "${nums[@]}"; do
#   if (( num % 2 == 0 )); then
#     sum_even=$((sum_even + num))
#   else
#     sum_odd=$((sum_odd + num))
#   fi
# done


# echo "Sum of odd numbers: $sum_odd"
# echo "Sum of even numbers: $sum_even"
