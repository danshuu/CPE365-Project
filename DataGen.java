
public class DataGen {

	private static final int NUM_PERSON = 120000;
	private static final int NUM_CITY = 300;

	public static void genCity(Connection cnc) {
       ResultSet rst = null;
       PreparedStatement pStm = null;

       try {
          pStm = cnc.prepareStatement("insert into" +
           "City(name, state)" +
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

	public static void genHometownAddress() {

	}

	public static void genPerson(Connection cnc) {
	   ResultSet rst = null;
       PreparedStatement pStm = null;

       try {
          pStm = cnc.prepareStatement("insert into" +
           "Person(firstName, lastName, age, gender, hometownAddressId)" +
           "values (?, ?, ?, ?, ?)");

          for (int i = 1; i < NUM_PERSON; i++) {
             pStm.setString(1, String.format("First%d", i));
             pStm.setString(2, String.format("Last%d", i));
          }
       }
       finally {
          closeEm(rst, pStm);
       }

	}

	public static void genProfession() {

	}

	public static void genCompany() {

	}

	public static void genDepartment() {

	}

	public static void genEmployee() {

	}

	public static void genCompanyXProfession() {

	}

	public static void genRating() {
		
	}
	
	public static void main(String[] args) {
	   Connection cnc = null;

	   try {
          cnc = DriverManager.getConnection(args[0], args[1], args[2]);

          cnc
	   }
	   catch (SQLException err) {
          System.out.println(err.getMessage());
	   }
	   finally {
	   	  closeEm(cnc);
	   }

	}
}