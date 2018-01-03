TITLE_WRAPPER="="
TITLE_LENGTH=40

print_span() {
 v=$(printf "%-$1s" "")
 echo "${v// /$TITLE_WRAPPER}"
}

function center {
    local span_length=$(($TITLE_LENGTH - ${#1}))
    local span=$(print_span $(($span_length/2)))
    result="$span$1$span"
    if [ ${#result} -eq $(($TITLE_LENGTH-1)) ]; then result="$result$TITLE_WRAPPER"; fi
    echo "$result"
}

function echo_title {
    echo "
        $(print_span $TITLE_LENGTH)
        $(center " $1 ")
        $(print_span $TITLE_LENGTH)
    "
}


