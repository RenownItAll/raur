function get_random_id
    # We use 'shuf' to shuffle the character set and 'head' to grab 6
    set -l chars abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789
    echo $chars | string split "" | shuf -n 6 | string join ""
end
