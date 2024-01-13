#!/bin/bash


    echo "Welcome"
    echo "To Management your file:"
    echo ""
# Define the maximum cache size
read -p "Enter the mamory size: " MAX_CACHE_SIZE

# Define an empty cache array
declare -A cache

# Define a function to get data from cache or file
function get_data {
    local filename=$1
    local data=

    # Check if the data is in the cache
    if [[ ${cache[$filename]+_} ]]; then
        # Move the filename to the end of the LRU list
        LRU_LIST=(${LRU_LIST[@]/$filename})
        LRU_LIST+=($filename)

        # Get the data from the cache
        data=${cache[$filename]}
    else
        # Read the data from the file
        data=$(cat $filename)

        # Add the data to the cache
        if [[ ${#cache[@]} -ge $MAX_CACHE_SIZE ]]; then
            local evict=${LRU_LIST[0]}
            LRU_LIST=(${LRU_LIST[@]:1})
            unset cache[$evict]
        fi
        cache[$filename]=$data
        LRU_LIST+=($filename)
    fi

    echo $data
}

# Test the cache management system
echo "Getting data from file1.txt"
get_data "file1.txt"
echo

echo "Getting data from file2.txt"
get_data "file2.txt"
echo

echo "Getting data from file1.txt again"
get_data "file1.txt"
echo

echo "Getting data from file3.txt"
get_data "file3.txt"
echo

echo "Getting data from file2.txt again"
get_data "file2.txt"
echo

echo "Getting data from file4.txt"
get_data "file4.txt"
echo
