<?php
$conn = new mysqli("localhost", "root", "", "simis");

if ($conn->connect_error) {
    die("Fehler: " . $conn->connect_error);
}
?>