import java.sql.*;
import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.List;
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
   private static final int MAX_DEPT_PER_COMPANY = 10;
   private static final int MIN_AGE = 18;
   private static final int MAX_AGE = 60;
   private static final double MIN_PAY = 13.00;
   private static final double MAX_PAY = 45.00;
   private static final int NUM_STATES = 50;
   private static final int MAX_STREET_NUM = 99999;
   private static final int MAX_ZIPCODE = 99999;
   private static final int NUM_GENDER = 3;
   private static final long EPOCH_YEAR = 1970;
   private static final int MIN_YEAR = 1985;
   private static final int MAX_YEAR = 2016;
   private static final long NUM_DAYS = 28;
   private static final long NUM_MONTH = 12;
   private static final long MILLISEC_IN_DAY = 86400000;
   private static final int MIN_SCORE = 0;
   private static final int MAX_SCORE = 10;

   public static void closeEm(Object... toClose) {
      for (Object obj : toClose) {
         if (obj != null) {
            try {
               obj.getClass().getMethod("close").invoke(obj);
            } catch (Throwable t) {
               System.out.println("Log bad close");
            }
         }
      }
   }

   public static void genCity(Connection cnc) throws SQLException {
      PreparedStatement pStm = null;
      int random;

      try {
         pStm = cnc.prepareStatement("insert into " +
                 "City(name, state) " +
                 "values (?, ?)");

         for (int i = 1; i <= NUM_CITY; i++) {
            random = ThreadLocalRandom.current().nextInt(1, NUM_STATES + 1);
            pStm.setString(1, String.format("City%d", i));
            pStm.setString(2, String.format("%02d", random));
            pStm.executeUpdate();
         }
      }
      finally {
         closeEm(pStm);
      }
   }

   public static void genHometownAddress(Connection cnc) throws SQLException {
      PreparedStatement pStm = null;
      int random;

      try {
         pStm = cnc.prepareStatement("insert into " +
                 "HometownAddress(addressNumber, street, zipcode, cityId) " +
                 "values (?, ?, ?, ?)");

         for (int i = 1; i <= NUM_ADDRESS; i++) {
            random = ThreadLocalRandom.current().nextInt(1, MAX_STREET_NUM + 1);
            pStm.setString(1, String.format("%d", random));

            pStm.setString(2, String.format("Street%d", i));

            random = ThreadLocalRandom.current().nextInt(1, MAX_ZIPCODE + 1);
            pStm.setString(3, String.format("%d", random));

            random = ThreadLocalRandom.current().nextInt(1, NUM_CITY + 1);
            pStm.setInt(4, random);

            pStm.executeUpdate();
         }
      }
      finally {
         closeEm(pStm);
      }
   }

   public static void genPerson(Connection cnc) throws SQLException {
      ResultSet rst = null;
      PreparedStatement pStm = null;
      int random;

      try {
         pStm = cnc.prepareStatement("insert into " +
                 "Person(firstName, lastName, age, gender, hometownAddressId) " +
                 "values (?, ?, ?, ?, ?)");

         for (int i = 1; i <= NUM_PERSON; i++) {
            pStm.setString(1, String.format("First%d", i));
            pStm.setString(2, String.format("Last%d", i));

            random = ThreadLocalRandom.current().nextInt(MIN_AGE, MAX_AGE + 1);
            pStm.setInt(3, random);

            random = ThreadLocalRandom.current().nextInt(1, NUM_GENDER + 1);
            pStm.setInt(4, random);

            random = ThreadLocalRandom.current().nextInt(1, NUM_ADDRESS + 1);
            pStm.setInt(5, random);

            pStm.executeUpdate();
         }
      }
      finally {
         closeEm(rst, pStm);
      }

   }

   public static void genProfession(Connection cnc) throws SQLException {
      PreparedStatement pStm = null;
      int random;

      try {
         pStm = cnc.prepareStatement("insert into " +
                 "Profession(name, division) " +
                 "values (?, ?)");

         for (int i = 1; i <= NUM_PROFESSION; i++) {
            random = ThreadLocalRandom.current().nextInt(1, 2 + 1);
            pStm.setString(1, String.format("Profession%d", i));
            pStm.setInt(2, random);
            pStm.executeUpdate();
         }
      }
      finally {
         closeEm(pStm);
      }
   }

   public static void genCompany(Connection cnc) throws SQLException {
      PreparedStatement pStm = null;
      int random;

      try {
         pStm = cnc.prepareStatement("insert into " +
                 "Company(name, cityId) " +
                 "values (?, ?)");

         for (int i = 1; i <= NUM_COMPANY; i++) {
            random = ThreadLocalRandom.current().nextInt(1, NUM_CITY + 1);
            pStm.setString(1, String.format("Company%d", i));
            pStm.setInt(2, random);
            pStm.executeUpdate();
         }
      }
      finally {
         closeEm(pStm);
      }
   }

   public static void genDepartment(Connection cnc) throws SQLException {
      PreparedStatement pStm = null;
      int numDept;

      try {
         pStm = cnc.prepareStatement("insert into " +
                 "Department(name, companyId) " +
                 "values (?, ?)");

         for (int i = 1; i <= NUM_COMPANY; i++) {
            pStm.setInt(2, i);
            numDept = ThreadLocalRandom.current().nextInt(1, MAX_DEPT_PER_COMPANY);
            for (int j = 1; j <= numDept; j++) {
               pStm.setString(1, String.format("Department%d", j));
               pStm.executeUpdate();
            }
         }
      }
      finally {
         closeEm(pStm);
      }
   }

   public static void genEmployee(Connection cnc) throws SQLException {
      ResultSet rst = null;
      PreparedStatement pStm = null, pDept = null;
      int randInt, year, month, day, deptCount;
      double randDou;
      GregorianCalendar hiredDate;

      try {
         pStm = cnc.prepareStatement("insert into " +
                 "Employee(personId, professionId, hiredDate, salary, " +
                 "deptId, companyId) values (?, ?, ?, ?, ?, ?)");
         pDept = cnc.prepareStatement("select id from Department " +
                 "where companyId = ?", Statement.RETURN_GENERATED_KEYS);

         for (int i = 1; i <= NUM_EMPLOYEE; i++) {
            pStm.setInt(1, i);

            randInt = ThreadLocalRandom.current().nextInt(1, NUM_PROFESSION + 1);
            pStm.setInt(2, randInt);

            year = ThreadLocalRandom.current().nextInt(MIN_YEAR, MAX_YEAR + 1);
            month = ThreadLocalRandom.current().nextInt(1, (int)NUM_MONTH + 1);
            day = ThreadLocalRandom.current().nextInt(1, (int)NUM_DAYS + 1);
            hiredDate = new GregorianCalendar(year, month, day);
            pStm.setDate(3, new java.sql.Date((hiredDate.getTime().getTime())));

            randDou = ThreadLocalRandom.current().nextDouble(MIN_PAY, MAX_PAY + 1);
            pStm.setFloat(4, (float)randDou);

            randInt = ThreadLocalRandom.current().nextInt(1, NUM_COMPANY + 1);
            pStm.setInt(6, randInt);

            pDept.setInt(1, randInt);
            rst = pDept.executeQuery();

            deptCount = 0;
            while(rst.next()) {deptCount++;}

            randInt = ThreadLocalRandom.current().nextInt(1, deptCount + 1);
            pStm.setInt(5, randInt);
            pStm.executeUpdate();
         }
      }
      finally {
         closeEm(rst, pDept, pStm);
      }
   }

   public static void genCompanyXProfession(Connection cnc) throws SQLException {
      PreparedStatement pStm = null;
      int numPro;

      try {
         pStm = cnc.prepareStatement("insert into " +
                 "CompanyXProfession(companyId, professionId) " +
                 "values (?, ?)");

         for (int i = 1; i <= NUM_COMPANY; i++) {
            numPro = ThreadLocalRandom.current().nextInt(1, NUM_PROFESSION / 3 + 1);
            for (int j = 1; j <= numPro; j++) {
               pStm.setInt(1, i);
               pStm.setInt(2, j);
               pStm.executeUpdate();
            }
         }
      }
      finally {
         closeEm(pStm);
      }
   }

   public static void genRating(Connection cnc) throws SQLException {
      ResultSet rst = null;
      PreparedStatement pStm = null, pUpper = null, pLower = null,
       pDept = null;
      int i = 0, compCount = 1, deptCount, random;
      List<Integer> upperEmp = new ArrayList<Integer>();
      List<Integer> lowerEmp = new ArrayList<Integer>();

      try {
         pStm = cnc.prepareStatement("insert into " +
                 "Rating(ratedId, score, raterId) " +
                 "values (?, ?, ?)");
         pUpper = cnc.prepareStatement("select personId from Employee " +
                         "join Profession P on professionId = P.id where deptId = ? " +
                         "and companyId = ? and division = 'Upper'",
                 Statement.RETURN_GENERATED_KEYS);
         pLower = cnc.prepareStatement("select personId from Employee " +
                         "join Profession P on professionId = P.id where deptId = ? " +
                         "and companyId = ? and division = 'Lower'",
                 Statement.RETURN_GENERATED_KEYS);
         pDept = cnc.prepareStatement("select id from Department " +
                 "where companyId = ?", Statement.RETURN_GENERATED_KEYS);

         while (i <= NUM_RATING) {
            pDept.setInt(1, compCount);
            rst = pDept.executeQuery();
            deptCount = 0;
            while(rst.next()) {deptCount++;}

            for (int j = 1; j <= deptCount; j++) {
               pUpper.setInt(1, j);
               pUpper.setInt(2, compCount);
               rst = pUpper.executeQuery();
               while(rst.next()) {upperEmp.add(rst.getInt(1));}
               pLower.setInt(1, j);
               pLower.setInt(2, compCount);
               rst = pLower.executeQuery();
               while(rst.next()) {lowerEmp.add(rst.getInt(1));}

               for (int k = 0; k < upperEmp.size(); k++) {
                  random = ThreadLocalRandom.current().nextInt(0, lowerEmp.size());
                  for (int l = 0; l < lowerEmp.size(); l++) {
                     pStm.setInt(1, lowerEmp.get(l));
                     pStm.setInt(3, upperEmp.get(k));

                     random = ThreadLocalRandom.current().nextInt(MIN_SCORE, MAX_SCORE + 1);
                     pStm.setInt(2, random);
                     pStm.executeUpdate();
                     i++;
                  }
               }
            }

            compCount++;
         }
      }
      finally {
         closeEm(rst, pLower, pUpper, pDept, pStm);
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