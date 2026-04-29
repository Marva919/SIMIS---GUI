<?php
$conn = new mysqli("rs03-db-inf-min.ad.fh-bielefeld.de", "MbelhausSIMIS@ORCL", "simis_Sql67", "simis");

if ($conn->connect_error) {
    die("Fehler: " . $conn->connect_error);
}
?>