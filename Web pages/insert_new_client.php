<html>
    <body>

        <form action="client_created.php" method="post">
        <h3>New Client</h3>
        <p>VAT: <input type="text" name="VAT" required/></p>
        <p>Name: <input type="text" name="name_" required/></p>
        <p>Birth Date: <input type="date" name="birth_date" min="1900-01-01" max="<?php echo date('Y-m-d');?>" required/></p>
        <p>Street: <input type="text" name="street" required/></p>
        <p>City: <input type="text" name="city" required/></p>
        <p>Zip: <input type="text" name="zip" required/></p>
        <p>Gender: <select  name="gender" required>
                        <option value="male">Male</option>
                        <option value="female">Female</option>
                    </select></p>

        <p>Age: <input type="number" name="age" max="119" required/></p>
        <p>Phone Number: <input type="number" name="phone_number" required/></p>
        
<?php
    include 'connect_db.php';
?>
        <p><input type="submit" value="Submit"/></p>
        </form>
    </body>
</html>