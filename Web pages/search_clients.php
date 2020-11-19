<html>
    <body>

        <form action="display_clients.php" method="post">
        <h3>Search client</h3>
        <p>VAT: <input type="number" name="VAT" pattern="\d"/></p>
        <p>Name: <input type="text" name="name_"/></p>
        <p>Street: <input type="text" name="street"/></p>
        <p>City: <input type="text" name="city"/></p>
        <p>Zip: <input type="text" name="zip"/></p>
        
<?php
    include 'connect_db.php';
?>
        <p><input type="submit" value="Submit"/></p>
        </form>
    </body>
</html>


