import java.sql.*;
import java.util.concurrent.ThreadLocalRandom;

public class DataGen {

	private static final int NUM_PERSON = 120000;
	private static final int NUM_CITY = 300;
	private static final int NUM_ADDRESS = 100000;
    private static final int NUM_PROFESSION = 1000;
    private static final int NUM_EMPLOYEE = 110000;
    //NUM_EMPLOYEE must not exceed NUM_PERSON
    private static final int NUM_RATING = 80000;
    private static final int NUM_COMPANY = 4000;
    private static final int NUM_DEPARTMENT = 4000;
    private static final int MIN_AGE = 18;
    private static final int MAX_AGE = 60;
    private static final double MIN_PAY = 13.00;
    private static final double MAX_PAY = 45.00;

	public static void genCity(Connection cnc) {
       ResultSet rst = null;
       PreparedStatement pStm = null;

       try {
          pStm = cnc.prepareStatement("insert into " +
           "City(name, state) " +
           "values (?, ?)");

          for (int i = 1; i < NUM_CITY; i++) {
             pStm.setString(1, String.format("City%d", i));
             pStm.setString(2, String.format("%02d", (i % 50) + 1));
             pStm.executeUpdate();
          }
       }
       finally {
          closeEm(rst, pStm);
       }
	}

	public static void genHometownAddress(Connection cnc) {
       ResultSet rst = null;
       PreparedStatement pStm = null;
       int random;

       try {
          pStm = cnc.prepareStatement("insert into " +
           "HometownAddress(addressNumber, street, zipcode, cityId) " +
           "values (?, ?, ?, ?)");

          for (int i = 1; i < NUM_ADDRESS; i++) {
          	 random = ThreadLocalRandom.current().nextInt(1, 100000);
             pStm.setString(1, random);

             pStm.setString(2, String.format("Street%d", i ));

             random = ThreadLocalRandom.current().nextInt(1, 100000);
             pStm.setString(3, String.format("%d", random);

             random = ThreadLocalRandom.current().nextInt(1, NUM_CITY + 1);
             pStm.setInt(4, random);

             pStm.executeUpdate();
          }
       }
       finally {
          closeEm(rst, pStm);
       }
	}

	public static void genPerson(Connection cnc) {
	   ResultSet rst = null;
       PreparedStatement pStm = null;
       int random;

       try {
          pStm = cnc.prepareStatement("insert into " +
           "Person(firstName, lastName, age, gender, hometownAddressId) " +
           "values (?, ?, ?, ?, ?)");

          for (int i = 1; i < NUM_PERSON; i++) {
             pStm.setString(1, String.format("First%d", i));
             pStm.setString(2, String.format("Last%d", i));

             random = ThreadLocalRandom.current().nextInt(MIN_AGE, MAX_AGE + 1);
             pStm.setInt(3, random);

             pStm.setString(4, );

             random = ThreadLocalRandom.current().nextInt(1, NUM_ADDRESS);
             pStm.setInt(5, random);

             pStm.executeUpdate();
          }
       }
       finally {
          closeEm(rst, pStm);
       }

	}

	public static void genProfession(Connection cnc) {
       ResultSet rst = null;
       PreparedStatement pStm = null;
       int random;

       try {
          pStm = cnc.prepareStatement("insert into " +
           "Profession(name, division) " +
           "values (?, ?)");

          for (int i = 1; i < NUM_PROFESSION; i++) {
          	 random = ThreadLocalRandom.current().nextInt(1, 2 + 1);
             pStm.setString(1, String.format("Profession%d", i));
             pStm.setString(2, random);
             pStm.executeUpdate();
          }
       }
       finally {
          closeEm(rst, pStm);
       }
	}

	public static void genCompany(Connection cnc) {
       ResultSet rst = null;
       PreparedStatement pStm = null;

       try {
          pStm = cnc.prepareStatement("insert into " +
           "Company(name, cityId) " +
           "values (?, ?)");

          for (int i = 1; i < NUM_COMPANY; i++) {
             pStm.setString(1, String.format("Company%d", i));
             pStm.setInt(2, (i % NUM_CITY) + 1);
             pStm.executeUpdate();
          }
       }
       finally {
          closeEm(rst, pStm);
       }
	}

	public static void genDepartment(Connection cnc) {
       ResultSet rst = null;
       PreparedStatement pStm = null;

       try {
          pStm = cnc.prepareStatement("insert into " +
           "Department(name, companyId) " +
           "values (?, ?)");

          for (int i = 1; i < NUM_DEPARTMENT; i++) {
             pStm.setString(1, String.format("Department%d", i));
             pStm.setInt(2, );
             pStm.executeUpdate();
          }
       }
       finally {
          closeEm(rst, pStm);
       }
	}

	public static void genEmployee(Connection cnc) {
       ResultSet rst = null;
       PreparedStatement pStm = null;
       int random;

       try {
          pStm = cnc.prepareStatement("insert into " +
           "Employee(personId, professionId, hiredDate, salary, " +
           "deptId, companyId) values (?, ?, ?, ?, ?, ?)");

          for (int i = 1; i < NUM_EMPLOYEE; i++) {
             pStm.setInt(1, i);

             random = ThreadLocalRandom.current().nextInt(1, NUM_PROFESSION);
             pStm.setInt(2, random);

             pStm.setDate(3, );

             random = ThreadLocalRandom.current().nextDouble(MIN_PAY, MAX_PAY + 1);
             pStm.setFloat(4, random);

             pStm.setInt(5, );
             pStm.setInt(6, );
             pStm.executeUpdate();
          }
       }
       finally {
          closeEm(rst, pStm);
       }
	}

	public static void genCompanyXProfession() {

	}

	public static void genRating(Connection cnc) {
	   ResultSet rst = null;
       PreparedStatement pStm = null;

       try {
          pStm = cnc.prepareStatement("insert into " +
           "Rating(ratedId, score, raterId) " +
           "values (?, ?, ?)");

          for (int i = 1; i < NUM_RATING; i++) {
             pStm.setInt(1, );
             pStm.setInt(2, );
             pStm.setInt(3, );
             pStm.executeUpdate();
          }
       }
       finally {
          closeEm(rst, pStm);
       }
	}
	
	public static void main(String[] args) {
	   Connection cnc = null;

	   try {
          cnc = DriverManager.getConnection(args[0], args[1], args[2]);

          genCity(cnc);
          genHometownAddress(cnc);
          genPerson(cnc);
          genProfession(cnc);
          genCompany(cnc);
          genDepartment(cnc);
          genEmployee(cnc);
          genCompanyXProfession(cnc);
          genRating(cnc);
	   }
	   catch (SQLException err) {
          System.out.println(err.getMessage());
	   }
	   finally {
	   	  closeEm(cnc);
	   }

	}
}