#!/usr/bin/env bash

# Create the README.md file from the docs/src/README_template.md file

[[ -d "./docs" ]] || (echo "Folder ./docs not found" && exit 1)

README_FILE="./README.md"

header=$(cat "./docs/src/header.md")
table_of_content=$(~/go/bin/md-table-of-contents ./docs/src/README_template.md)
readme_content=$(cat "./docs/src/README_template.md")

header=${header//\{date\}/$(date '+%D')}
header=${header//\{primarycolor\}/89b4fa}
header=${header//\{backgroundcolor\}/181825}
readme_content=${readme_content//\{md_table_of_content\}/$table_of_content}

echo "$header" >"$README_FILE"
echo "$readme_content" >>"$README_FILE"
sed 's/\r//' "$README_FILE" >"/tmp/readme.md"
mv "/tmp/readme.md" "$README_FILE"
