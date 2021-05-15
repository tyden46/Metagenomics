#!/bin/bash

NAMES="names.dmp"
NODES="nodes.dmp"
GI_TO_TAXID="fullGb2Tax.txt"
TAXONOMY=""
GI="${1}"

# Obtain the name corresponding to a taxid or the taxid of the parent taxa
get_name_or_taxid()
{
    grep --max-count=1 "${1}" "${2}" | cut --fields="${3}"
}
get_name_or_taxid2()
{
    grep --max-count=1 "^${1}" "${2}" | cut --fields="${3}"
}

# Get the taxid corresponding to the GI number
TAXID=$(get_name_or_taxid "${GI}" "${GI_TO_TAXID}" "3")
echo $TAXID
# Loop until you reach the root of the taxonomy (i.e. taxid = 1)
while [[ "${TAXID}" -gt 1 ]] ; do
    # Obtain the scientific name corresponding to a taxid
    echo $TAXID
    NAME=$(get_name_or_taxid "${TAXID}" "${NAMES}" "3")
    echo get_name_or_taxid "${TAXID}" "${NAMES}" "3"
    #echo $NAME
    # Obtain the parent taxa taxid
    PARENT=$(get_name_or_taxid2 "${TAXID}" "${NODES}" "3")
    echo $PARENT 
    #echo $PARENT 
    # Build the taxonomy path
    TAXONOMY="${NAME};${TAXONOMY}"
    TAXID="${PARENT}"
done

echo -e "${GI}\t${TAXONOMY}"

exit 0
