<?php
/**
 * The base configuration for WordPress
 *
 * The wp-config.php creation script uses this file during the installation.
 * You don't have to use the web site, you can copy this file to "wp-config.php"
 * and fill in the values.
 *
 * This file contains the following configurations:
 *
 * * Database settings
 * * Secret keys
 * * Database table prefix
 * * ABSPATH
 *
 * @link https://wordpress.org/support/article/editing-wp-config-php/
 *
 * @package WordPress
 */

// ** Database settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define( 'DB_NAME', 'wordpress' );

/** Database username */
define( 'DB_USER', 'wordpress' );

/** Database password */
define( 'DB_PASSWORD', 'password' );

/** Database hostname */
define( 'DB_HOST', '35.196.232.103' );

/** Database charset to use in creating database tables. */
define( 'DB_CHARSET', 'utf8' );

/** The database collate type. Don't change this if in doubt. */
define( 'DB_COLLATE', '' );

/**#@+
 * Authentication unique keys and salts.
 *
 * Change these to different unique phrases! You can generate these using
 * the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}.
 *
 * You can change these at any point in time to invalidate all existing cookies.
 * This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'C<HBbew#~%/;h-cLSZXf-p-kqNhunF/w|:!/bRf?P9+@v`PLB (#T@`I+Yl!+f~h');
define('SECURE_AUTH_KEY',  'Li)_AvhTHsl?$TVdsZo0kuny|MS%_`$J}bNXKN,+794|K`{iWcDSF3r+pTn5khx!');
define('LOGGED_IN_KEY',    ':ybMf7N]npL%PZX@I<!e+.d4xsi7M(OS% )U<{K+U<2S|fn[N7dku@hBO;SNwKW$');
define('NONCE_KEY',        'OkGy.LknMz2X-m|7N}l3|Jnc+ynWcziI}lGe6_ooD^;;dTh_}2<^##Rypwi}_|1n');
define('AUTH_SALT',        'X{R|qlLnARJ}+yGEnEVc@,e;xs>o(8Q<f(v025iv[{E+juT0+WR)~>LgBcgn:~f5');
define('SECURE_AUTH_SALT', '_8$hPC+1vd@-Zz[L<5y]xKOOi&5?6q!:WxTmX,Nq{;kOQw[?a~}X)*J{JS5~6=;>');
define('LOGGED_IN_SALT',   ';2ctF-B`xZTDE|*Xuv:S-#-mJjM :k53KaC1F)%SxZ~$Tfl%pr|W3D4?IPsFJ2/W');
define('NONCE_SALT',       'di+_`ly7+&^[!;-W<?YgOI$KA0FBJ{]b(W6vW|XMK`v=0;j[ZQN(_z%$7_8]yiB|');
/*
define( 'AUTH_KEY',         'put your unique phrase here' );
define( 'SECURE_AUTH_KEY',  'put your unique phrase here' );
define( 'LOGGED_IN_KEY',    'put your unique phrase here' );
define( 'NONCE_KEY',        'put your unique phrase here' );
define( 'AUTH_SALT',        'put your unique phrase here' );
define( 'SECURE_AUTH_SALT', 'put your unique phrase here' );
define( 'LOGGED_IN_SALT',   'put your unique phrase here' );
define( 'NONCE_SALT',       'put your unique phrase here' );*/

/**#@-*/

/**
 * WordPress database table prefix.
 *
 * You can have multiple installations in one database if you give each
 * a unique prefix. Only numbers, letters, and underscores please!
 */
$table_prefix = 'wp_';

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 *
 * For information on other constants that can be used for debugging,
 * visit the documentation.
 *
 * @link https://wordpress.org/support/article/debugging-in-wordpress/
 */
define( 'WP_DEBUG', false );

/* Add any custom values between this line and the "stop editing" line. */



/* That's all, stop editing! Happy publishing. */

/** Absolute path to the WordPress directory. */
if ( ! defined( 'ABSPATH' ) ) {
	define( 'ABSPATH', __DIR__ . '/' );
}

/** Sets up WordPress vars and included files. */
require_once ABSPATH . 'wp-settings.php';
