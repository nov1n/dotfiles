import sys
import json
import re

# Read input from stdin
input_data = sys.stdin.read()

# Split the input into lines
lines = input_data.split('\n')

# Find the content between the first two empty lines
start_index = -1
end_index = -1
for i, line in enumerate(lines):
    if line.strip() == '':
        if start_index == -1:
            start_index = i
        elif end_index == -1:
            end_index = i
            break

if start_index == -1 or end_index == -1:
    print("Couldn't find two empty lines.")
    sys.exit(1)

# Extract the relevant content
relevant_content = '\n'.join(lines[start_index+1:end_index])

# Process the relevant content
keys = set()

# Regular expression to match key entries
key_pattern = re.compile(r"{\s*key\s*=\s*'([^']+)'")

for match in key_pattern.finditer(relevant_content):
    # Convert to lowercase and add to set (which automatically removes duplicates)
    keys.add(match.group(1).lower())

# Convert to a sorted list
sorted_keys = sorted(list(keys))

# Print the result as JSON
print(json.dumps(sorted_keys, indent=2))
