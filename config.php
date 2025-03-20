<?php
// Database configuration with ENV variables. Set default values as well 
$db_host = getenv('DB_HOST') ?: 'localhost';
$db_name = getenv('DB_NAME') ?: 'image_catalog';
$db_user = getenv('DB_USER') ?: 'appmod-phpapp-user';
$db_pass = getenv('DB_PASS') ?: 'wrong_password';
// Note getenv() is PHP 5.3 compatible
try {
    $pdo = new PDO("mysql:host=$db_host;dbname=$db_name", $db_user, $db_pass);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
} catch (PDOException $e) {
    die("Errore di connessione: " . $e->getMessage());
}

session_start();
?>