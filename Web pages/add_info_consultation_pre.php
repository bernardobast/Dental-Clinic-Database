<html>
  <head>
    <title>Add Appointment Info</title>
  </head>
  <h3>Creating a new consultation with Doctor <?=$_REQUEST['VAT_doctor']?> on Date <?=$_REQUEST['date_timestamp']?></h3>
  <h4>Please Add Soap Notes in order to create a Consultation </h4>
   <body>
      <h4> Add SOAP Notes: </h4>
      <form action="update_info_consultation_SOAP.php" method="post"
         VAT_doctor = VAT_doctor Date=Date VAT_client = VAT_client
         SOAP_S=SOAP_S SOAP_O=SOAP_O SOAP_A=SOAP_A SOAP_P=SOAP_P>
         <input type="hidden" name="VAT_client" value="<?=$_REQUEST['VAT_client']?>">
         <input type="hidden" name="VAT_doctor" value="<?=$_REQUEST['VAT_doctor']?>">
         <input type="hidden" name="Date" value="<?=$_REQUEST['date_timestamp']?>">
         <p>SOAP S: <input type="text" name="SOAP_S" required/></p>
         <p>SOAP O: <input type="text" name="SOAP_O" required/></p>
         <p>SOAP A: <input type="text" name="SOAP_A" required/></p>
         <p>SOAP P: <input type="text" name="SOAP_P" required/></p>
         <p><input type="submit" value="Add SOAP Note"/></p>
      </form>
      </form>
   </body>
</html>
