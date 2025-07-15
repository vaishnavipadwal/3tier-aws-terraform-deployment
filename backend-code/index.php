<?php
$host = "your-rds-endpoint";
$db = "mydb";
$user = "admin";
$pass = "Admin12345";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

echo "<h2>Connected to MySQL Database Successfully!</h2>";
?>
