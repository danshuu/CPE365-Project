import java.sql.*;
import java.util.ArrayList;
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
   private static final int MIN_ZIPCODE = 10000;
   private static final int MAX_ZIPCODE = 99999;
   private static final int NUM_GENDER = 3;
   private static final int MIN_YEAR = 1985;
   private static final int MAX_YEAR = 2016;
   private static final long NUM_DAYS = 28;
   private static final long NUM_MONTH = 12;
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
      StringBuilder statement;
      int randCity;

      try {
         statement = new StringBuilder("insert into City(name, state) values ");

         for (int i = 1; i <= NUM_CITY; i++) {
            randCity = ThreadLocalRandom.current().nextInt(1, NUM_STATES + 1);
            statement.append(String.format("('City%d', '%02d')", i, randCity));

            if(i != NUM_CITY) {statement.append(", ");}
            else {statement.append(";");}
         }

         pStm = cnc.prepareStatement(statement.toString());
         pStm.executeUpdate();
      }
      finally {
         closeEm(pStm);
      }
   }

   public static void genHometownAddress(Connection cnc) throws SQLException {
      PreparedStatement pStm = null;
      StringBuilder statement;
      int randStreet, randZip, randCity;

      try {
         statement = new StringBuilder("insert into HometownAddress(addressNumber, street, " +
                 "zipcode, cityId) values ");

         for (int i = 1; i <= NUM_ADDRESS; i++) {
            randStreet = ThreadLocalRandom.current().nextInt(1,
                    MAX_STREET_NUM + 1);
            randZip = ThreadLocalRandom.current().nextInt(MIN_ZIPCODE,
                    MAX_ZIPCODE + 1);
            randCity = ThreadLocalRandom.current().nextInt(1,
                    NUM_CITY + 1);
            statement = statement.append(String.format("('%d', 'Street%d', '%d', %d)",
                    randStreet, i, randZip, randCity));

            if(i != NUM_ADDRESS) {statement = statement.append(", ");}
            else {statement = statement.append(";");}
         }

         pStm = cnc.prepareStatement(statement.toString());
         pStm.executeUpdate();
      }
      finally {
         closeEm(pStm);
      }
   }

   public static void genPerson(Connection cnc) throws SQLException {
      PreparedStatement pStm = null;
      StringBuilder statement;
      int randAge, randGen, randArs;

      try {
         statement = new StringBuilder("insert into Person(firstName, lastName, " +
                 "age, gender, hometownAddressId) values ");

         for (int i = 1; i <= NUM_PERSON; i++) {
            randAge = ThreadLocalRandom.current().nextInt(MIN_AGE, MAX_AGE + 1);
            randGen = ThreadLocalRandom.current().nextInt(1, NUM_GENDER + 1);
            randArs = ThreadLocalRandom.current().nextInt(1, NUM_ADDRESS + 1);

            statement = statement.append(String.format("('First%d', 'Last%d', %d, %d, %d)",
                    i, i, randAge, randGen, randArs));

            if(i != NUM_PERSON) {statement = statement.append(", ");}
            else {statement = statement.append(";");}
         }

         pStm = cnc.prepareStatement(statement.toString());
         pStm.executeUpdate();
      }
      finally {
         closeEm(pStm);
      }

   }

   public static void genProfession(Connection cnc) throws SQLException {
      PreparedStatement pStm = null;
      StringBuilder statement;
      int randDiv;

      try {
         statement = new StringBuilder("insert into Profession(name, division) values ");

         for (int i = 1; i <= NUM_PROFESSION; i++) {
            randDiv = ThreadLocalRandom.current().nextInt(1, 2 + 1);
            statement = statement.append(String.format("('Profession%d', %d)", i, randDiv));

            if(i != NUM_PROFESSION) {statement = statement.append(", ");}
            else {statement = statement.append(";");}
         }

         pStm = cnc.prepareStatement(statement.toString());
         pStm.executeUpdate();
      }
      finally {
         closeEm(pStm);
      }
   }

   public static void genCompany(Connection cnc) throws SQLException {
      PreparedStatement pStm = null;
      StringBuilder statement;
      int randCity;

      try {
         statement = new StringBuilder("insert into Company(name, cityId) values ");

         for (int i = 1; i <= NUM_COMPANY; i++) {
            randCity = ThreadLocalRandom.current().nextInt(1, NUM_CITY + 1);
            statement = statement.append(String.format("('Company%d', %d)", i, randCity));

            if(i != NUM_COMPANY) {statement = statement.append(", ");}
            else {statement = statement.append(";");}
         }

         pStm = cnc.prepareStatement(statement.toString());
         pStm.executeUpdate();
      }
      finally {
         closeEm(pStm);
      }
   }

   public static void genDepartment(Connection cnc) throws SQLException {
      PreparedStatement pStm = null;
      StringBuilder statement;
      int numDept;

      try {
         statement = new StringBuilder("insert into Department(name, companyId) values ");

         for (int i = 1; i <= NUM_COMPANY; i++) {
            numDept = ThreadLocalRandom.current().nextInt(1,
                    MAX_DEPT_PER_COMPANY);

            for (int j = 1; j <= numDept; j++) {
               statement = statement.append(String.format("('Department%d', %d)", j, i));
               if(i != NUM_COMPANY || j != numDept) {statement = statement.append(", ");}
               else {statement = statement.append(";");}
            }
         }

         pStm = cnc.prepareStatement(statement.toString());
         pStm.executeUpdate();
      }
      finally {
         closeEm(pStm);
      }
   }

   public static void genEmployee(Connection cnc) throws SQLException {
      ResultSet rst = null;
      PreparedStatement pStm = null, pDept = null;
      StringBuilder statement;
      int randPro, randCom, randDept, year, month, day, deptCount;
      double randPay;

      try {
         statement = new StringBuilder("insert into Employee(personId, professionId, " +
                 "hiredDate, salary, deptId, companyId) values ");
         pDept = cnc.prepareStatement("select id from Department " +
                 "where companyId = ?", Statement.RETURN_GENERATED_KEYS);

         for (int i = 1; i <= NUM_EMPLOYEE; i++) {
            randPro = ThreadLocalRandom.current().nextInt(1,
                    NUM_PROFESSION + 1);

            year = ThreadLocalRandom.current().nextInt(MIN_YEAR, MAX_YEAR + 1);
            month = ThreadLocalRandom.current().nextInt(1, (int)
                    NUM_MONTH + 1);
            day = ThreadLocalRandom.current().nextInt(1, (int)NUM_DAYS + 1);

            randPay = ThreadLocalRandom.current().nextDouble(MIN_PAY, MAX_PAY + 1);

            randCom = ThreadLocalRandom.current().nextInt(1, NUM_COMPANY + 1);

            pDept.setInt(1, randCom);
            rst = pDept.executeQuery();

            deptCount = 0;
            while(rst.next()) {deptCount++;}

            randDept = ThreadLocalRandom.current().nextInt(1, deptCount + 1);

            statement = statement.append(String.format("(%d, %d, '%d-%02d-%02d', %f, %d, %d)",
                    i, randPro, year, month, day, (float)randPay, randDept, randCom));

            if(i != NUM_EMPLOYEE) {statement = statement.append(", ");}
            else {statement = statement.append(";");}
         }

         pStm = cnc.prepareStatement(statement.toString());
         pStm.executeUpdate();
      }
      finally {
         closeEm(rst, pDept, pStm);
      }
   }

   public static void genCompanyXProfession(Connection cnc)
           throws SQLException {
      PreparedStatement pStm = null;
      StringBuilder statement;
      int numPro;

      try {
         statement = new StringBuilder("insert into CompanyXProfession(companyId, " +
                 "professionId) values ");

         for (int i = 1; i <= NUM_COMPANY; i++) {
            numPro = ThreadLocalRandom.current().nextInt(1,
                    NUM_PROFESSION / 3 + 1);

            for (int j = 1; j <= numPro; j++) {
               statement = statement.append(String.format("(%d, %d)", i, j));

               if(i != NUM_COMPANY || j != numPro) {statement = statement.append(", ");}
               else {statement = statement.append(";");}
            }
         }

         pStm = cnc.prepareStatement(statement.toString());
         pStm.executeUpdate();
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

      System.out.println("Done!");
   }
}