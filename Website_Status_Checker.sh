#!/bin/bash

    echo "Welcome"
    echo "To check website status:"
    echo ""
# Prompt the user to enter the website URLs to check
read -p "Enter the website URLs separated by spaces: " websites

# Convert the user input into an array
websites=($websites)

# Loop through each website and check its status
for website in "${websites[@]}"
do
    # Check the website status
    response=$(curl -Is $website)

    # Print the response headers for debugging
    echo "$response"

    # Extract the HTTP status code from the response
    status_code=$(echo "$response" | head -n 1 | awk '{print $2}')
    echo ""
    # Print the website status
    if [[ $status_code -eq 200 ]]; then
        echo "$website is up"
    else
        echo "$website is down"
    fi
    echo ""
done
