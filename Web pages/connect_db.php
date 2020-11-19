<?php
    $host = "db.tecnico.ulisboa.pt";
    $user = "ist187024";
    $pass = "luet0220";
    $dsn = "mysql:host=$host;dbname=$user";
    try
    {
        $connection = new PDO($dsn, $user, $pass);
    }
    catch(PDOException $exception)
    {
        echo("<p>Error: ");
        echo($exception->getMessage());
        echo("</p>");
    exit();
    }
?>