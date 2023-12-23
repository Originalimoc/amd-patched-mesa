#!/bin/bash
declare -A file_map

# Step 1: Find all files and map them by hash
while IFS= read -r -d '' file; do
    # Calculate the file hash and size
    hash=$(sha256sum "$file" | awk '{print $1}')
    size=$(wc -c < "$file")

    # Append the file to the array of files with the same hash
    file_map[$hash,size]+=" $file"
done < <(find . -type f \( -name 'lib*.so*' -o -name 'lib*-*.so*' \) -print0)

# Step 2: Process files with the same hash
for key in "${!file_map[@]}"; do
    files=(${file_map[$key]})

    # Skip if there is only one file with this hash
    if [ "${#files[@]}" -lt 2 ]; then
        continue
    fi

    # Step 3: Find the file with the longest name (most detailed version)
    longest_file=""
    for file in "${files[@]}"; do
        if [[ -z "$longest_file" || "${#file}" -gt "${#longest_file}" ]]; then
            longest_file="$file"
        fi
    done

    # Delete other files and replace with symlinks to the longest file name
    for file in "${files[@]}"; do
        if [[ "$file" != "$longest_file" ]]; then
            echo "rm" "$file"
            rm "$file"
            echo "ln -s" "$longest_file" "$file"
            ln -s "$longest_file" "$file"
            echo
        fi
    done
done
