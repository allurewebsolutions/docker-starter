if [ "$WP_ENV" ]; then
    awk '/^\/\*.*stop editing.*\*\/$/ && c == 0 { c = 1; system("cat") } { print }' wp-config.php > wp-config.tmp <<'EOPHP'
// Set the environment.
define( 'WP_ENV', getenv('WP_ENV') );
EOPHP
    mv wp-config.tmp wp-config.php
fi