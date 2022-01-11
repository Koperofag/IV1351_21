import java.util.*;
import java.sql.*;
import java.time.LocalDateTime; // Import the LocalDateTime class
import java.time.format.DateTimeFormatter; // Import the DateTimeFormatter class

/**
 * 
 */

/**
 * @author Kohai
 *
 */
public class IV1351 {

	
	
	
	static final String DB_URL = "jdbc:mysql://localhost:3306/iv1351";
	static final String USER = "root";
	static final String PASS = "qwerty123456";
	static String QUERY = "SELECT * FROM iv1351.sql_4_c_2;";
		
	
	public static void rent_instrument() {
		
		//This function will handle the renting of instruments. 
		Scanner in = new Scanner(System.in);
		
		 // Open a connection
		
	      try{
	    	  Class.forName("com.mysql.jdbc.Driver");
	    	  Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
		    	 Statement stmt = conn.createStatement();	 
		         System.out.println("Please insert the instrument id for the instrument you wish to rent. Write it in the format of only the number.");
		         int instrumentID = Integer.parseInt(in.nextLine());
		         
		         System.out.println("Please insert the ID of the student to rent the instrument.");
		         int studentID = Integer.parseInt(in.nextLine());
		         
		         System.out.println("How long should the rent last? Answer in months. Maximum 12 and min is 1. ");
		         int rent_due = Integer.parseInt(in.nextLine());
		         while(rent_due > 12 || rent_due < 1) {
		        	 System.out.println("How long should the rent last? Answer in months. Maximum 12 and min is 1. ");
			         rent_due = Integer.parseInt(in.nextLine()); 
		         }
		         
		         QUERY = "select count(*) as tidigare_hyrt,  (select rental_fee from instruments_for_rent where instrument_id = "
		        		 	+ instrumentID
		        		 	+ ") as cost "
			 	      		+ "from instruments_for_rent "
			 	      		+ "where student_id = " + studentID
			 	      		+ " ;";
		         
		         System.out.println (QUERY);
		         ResultSet rs = stmt.executeQuery(QUERY);
		         int total_rented = 0;
		         int cost = 0;
		         
		         while (rs.next()) {
		        	 total_rented = rs.getInt("tidigare_hyrt");
		        		cost = rs.getInt("cost");
		         }
		         
		         if (total_rented < 2) {
		        	 
		         
		        
		         
		         
		      QUERY = "update instruments_for_rent "
		      		+ "set in_stock = 0, student_id = " + studentID
		      		+ " where instrument_id = " + instrumentID
		      		+ " ;";
		  	System.out.println (QUERY);
		      	stmt.executeUpdate(QUERY);
		      	// System.out.println ("Extract data from result set");
		      	
		      	QUERY = "insert into rentals (instrument_id, student_id, start_date, return_date, cost)"
		      			+ "values("
		      			+ instrumentID
		      			+ ", "
		      			+ studentID
		      			+ ", \""
		      			+ LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))
		      			+ "\", \""
		      			+ LocalDateTime.now().plusMonths(rent_due).format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))
		      			+ "\" , "
		      			+ cost
		      			+ ")"
		      			
		      			+ ";";
		      	
		      	System.out.println (QUERY);
		      	stmt.executeUpdate(QUERY);	
		      	
		      	
		        }
		      	else
		      		System.out.print("This student has already rentet the maximum amount of instruments. ");
	            
	            // 
	        
	         
		      conn.close();

		         
	         
	      } catch (Exception e) {
	         e.printStackTrace();
	      } 
	      
		
	}


	public static void return_instrument() {
	
	//This function will find all of the instruments which are rented and show which students are renting them. 
		Scanner in = new Scanner(System.in);
	// Open a connection
	
      try{
    	  Class.forName("com.mysql.jdbc.Driver");
    	  Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
	    	 Statement stmt = conn.createStatement();	 
	     
	    	 System.out.println("Please insert which instrument you wish to return: ");
		      int instrumentID = Integer.parseInt(in.nextLine());
	    	 
	    	 
		      QUERY = "update instruments_for_rent "
			      		+ "set in_stock = 1, student_id = NULL"
			      		+ " where instrument_id = " + instrumentID
			      		+ " ;";
		      
         System.out.println (QUERY);
         stmt.executeUpdate(QUERY);	
         
         QUERY = "update rentals "
		      		+ "set termination_date = \""
		      		+ LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))
		      		+ "\" where instrument_id = " + instrumentID
		      		+ " AND termination_date IS NULL"
		      		+ " ;";
         
          System.out.println (QUERY);
          stmt.executeUpdate(QUERY);	
	      
       
         
	      conn.close();
         
    	 
         
      } catch (Exception e) {
         e.printStackTrace();
      } 

	
	}
	
	public static void instruments_available() {
		
			Scanner in = new Scanner(System.in);
		 // Open a connection
		
	      try{
	    	  Class.forName("com.mysql.jdbc.Driver");
	    	  Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
		    	 Statement stmt = conn.createStatement();
		         	 

	    	  System.out.println("Please insert what type of instrument you are looking for: ");
		      String input = in.nextLine();
		      QUERY = "select instrument_id, brand, rental_fee "
		      		+ "from instruments_for_rent "
		      		+ "where in_stock = 1 and instrument_type = \""
		      		+ input
		      		+ "\";";
	         System.out.println ("Extract data from result set");
	         System.out.println (QUERY);
	         ResultSet rs = stmt.executeQuery(QUERY);	
		      
	         while (rs.next()) {
	            // Retrieve by column name
	        	 System.out.println("x");
	            System.out.print("Instrument ID: " + rs.getInt("instrument_id"));
	            System.out.print("\t|\t Brand: " + rs.getString("brand"));
	            System.out.println("\t|\t Rental fee: " + rs.getDouble("rental_fee"));
	            
	            
	            // 
	         }
	         
		      conn.close();
	          
	    	 
	         
	      } catch (Exception e) {
	         e.printStackTrace();
	      } 
	      
	
		
	}
	
	public static void instruments_rented() {
		
		//This function will find all of the instruments which are rented and show which students are renting them. 
		
		 // Open a connection
		
	      try{
	    	  Class.forName("com.mysql.jdbc.Driver");
	    	  Connection conn = DriverManager.getConnection(DB_URL, USER, PASS);
		    	 Statement stmt = conn.createStatement();

		     
		      QUERY = "select instrument_id, brand, rental_fee, student_id "
		      		+ "from instruments_for_rent "
		      		+ "where in_stock = 0 ;";
	         System.out.println ("Extract data from result set");
	         System.out.println (QUERY);
	         ResultSet rs = stmt.executeQuery(QUERY);	 
		      
	         while (rs.next()) {
	            // Retrieve by column name
	            System.out.print("Instrument ID: " + rs.getInt("instrument_id"));
	            System.out.print("\t|\t Brand: " + rs.getString("brand"));
	            System.out.print("\t|\t Rental fee: " + rs.getDouble("rental_fee"));
	            System.out.println("\t|\t Student ID: " + rs.getInt("student_id"));
	            
	            
	            // 
	         }
	         
		      conn.close();
	         
	    	 
	         
	      } catch (Exception e) {
	         e.printStackTrace();
	      } 
		
	}
	
	/**
	 * @param args
	 */
	public static void main(String[] args) {
		// TODO Auto-generated method stub
		System.out.println("Do you want to rent an instrument?\ty/n");
		Scanner in = new Scanner(System.in);
		if (in.nextLine().equals("y")) {
			instruments_available();
			rent_instrument();
			instruments_rented();
		}
		
		System.out.println("Do you want to return an instrument?\ty/n");
		if (in.nextLine().equals("y")) {
			instruments_rented();
			return_instrument();
			instruments_available();
		}
		
		in.close();

	}
	
	
	

}
