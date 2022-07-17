
package iv1351;

import java.util.*;
import java.sql.*;
import java.time.LocalDateTime; // Import the LocalDateTime class
import java.time.format.DateTimeFormatter; // Import the DateTimeFormatter class


public class IV1351 {

    static final String DB_URL = "jdbc:mysql://localhost:3306/iv1351?characterEncoding=latin1";
    static final String USER = "root";
    static final String PASS = "root";
    static String QUERY = "SELECT * FROM iv1351.sql_4_c_2;";

    public static void main(String[] args) throws SQLException {
            
        //welcome messages and startup
        Scanner input = new Scanner(System.in);
        String choice = "na";
        PrintWelcomeString();
        PrintCommandList();
            
        Connection conn = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
            conn.setAutoCommit(false);
            Statement stmt = conn.createStatement();
            do {
                System.out.print("\nCommand: ");
                choice = new Scanner(System.in).nextLine();
                //System.out.print("Q [" + choice + "] Q");

                switch(choice.split(" ")[0]){
                    case "show":
                        // function that lets the user list all instruments that are available or not
                        show_instruments_available(stmt);
                        break;

                    case "rent":
                        // function that lets the user rent from available instruments
                        rent_instrument(stmt, conn);
                        break;

                    case "return":
                        // function that lets the user return instruments from their inventory
                        return_instrument(stmt, conn);
                        break;

                    case "inventory":
                        // function that shows all the instruments in the inventory
                        show_inventory(stmt);
                        break;

                    case "help":
                        // function that prints out the commands available
                        PrintCommandList();
                        break;

                    case "q":
                        System.out.print("Goodbye!\n");
                        break; 

                    case "add":
                        admin_add_instrument();
                        break;

                    default:
                        System.out.print("Command [" + choice + "] is unvalid.");
                }
            }while (!choice.equals("q"));
        
        input.close();
        conn.commit();
        conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            conn.rollback();
        }   
    }
    
    
    /**
     * //This function will handle the renting of instruments. 
     */
    public static void rent_instrument(Statement stmt, Connection conn) throws SQLException {

        Scanner in = new Scanner(System.in);

        try{
            //check if user may rent another instrument (max 2)
            System.out.println("Insert your Student ID to rent the instrument: ");
            int studentID = Integer.parseInt(in.nextLine());
            
            QUERY = "select count(*) as tidigare_hyrt "
                    + "from instruments_for_rent "
                    + "where student_id = " + studentID
                    + " ;";

            ResultSet rs = stmt.executeQuery(QUERY);
            rs.next();
            int total_instruments_rented = rs.getInt("tidigare_hyrt");
            
            //start the renting process if student is allowed to rent more instruments
            if (total_instruments_rented < 2) {
            
                //ask for further input if student may rent more instruments
                System.out.println("Insert the instrument ID number for the instrument you wish to rent: ");
                int instrumentID = Integer.parseInt(in.nextLine());
                
                System.out.println("Number of months to rent [1-12]: ");
                int rent_due = Integer.parseInt(in.nextLine());
                
                while(rent_due > 12 || rent_due < 1) {
                        System.out.println("Number of months to rent [1-12]: ");
                        rent_due = Integer.parseInt(in.nextLine()); 
                }
                
                //find the rental cost
                QUERY = "select count(*) as tidigare_hyrt,  (select rental_fee from instruments_for_rent where instrument_id = "
		        + instrumentID
		        + ") as cost "
			+ "from instruments_for_rent "
			+ "where student_id = " + studentID
			+ " ;";
                rs = stmt.executeQuery(QUERY);
                rs.next();
                int cost = rs.getInt("cost");
                
                //push update onto database "instruments_for_rent"
                QUERY = "update instruments_for_rent "
                          + "set in_stock = 0, student_id = " + studentID
                          + " where instrument_id = " + instrumentID
                          + " ;";
                stmt.executeUpdate(QUERY);

                
                //push update onto database "rentals"
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

                stmt.executeUpdate(QUERY);
                
                System.out.print("Student " + studentID + " have rented instrument " + instrumentID + " for a rental cost of " + cost*rent_due + " dollar.\n");
            } else {
                System.out.print("This student has already rentet the maximum amount of instruments. ");
            }
        } catch (Exception e) {
           e.printStackTrace();
        } 
    }

    /**
     * function will find all of the instruments which are rented and show which students are renting them
     */
    public static void return_instrument(Statement stmt, Connection conn) throws SQLException {

        Scanner in = new Scanner(System.in);

        try{

            // ask user for input
            System.out.println("Please insert which instrument you wish to return: ");
            int instrumentID = Integer.parseInt(in.nextLine());
            
            //create query
            QUERY = "update instruments_for_rent "
                              + "set in_stock = 1, student_id = NULL"
                              + " where instrument_id = " + instrumentID
                              + " ;";

            stmt.executeUpdate(QUERY);	

            QUERY = "update rentals "
                    + "set termination_date = \""
                    + LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"))
                    + "\" where instrument_id = " + instrumentID
                    + " AND termination_date IS NULL"
                    + " ;";
            
            System.out.println ("Instrument " + instrumentID + " Was returned.\n");
            stmt.executeUpdate(QUERY);	

            } catch (Exception e) {
            e.printStackTrace();
            } 
    }
    
    /**
     * Try to print out all instruments that are possible to rent in the system as a table from database
     */
    public static void show_instruments_available(Statement stmt) {

        Scanner in = new Scanner(System.in);

        try{


            // ask user for input
            System.out.println("Choose instrument type [type \"all\" to see all]: ");
            String input = in.nextLine();        
            
            if(input.equals("all")) {
                QUERY = "select instrument_id, instrument_type, brand, rental_fee "
                          + "from instruments_for_rent "
                          + "where in_stock = 1 ;";
            } else {
                QUERY = "select instrument_id, instrument_type, brand, rental_fee "
                      + "from instruments_for_rent "
                      + "where in_stock = 1 and instrument_type = \""
                      + input
                      + "\";";
            }
            
            ResultSet rs = stmt.executeQuery(QUERY);	
            
            // print out the entire table
            while (rs.next()) {
                System.out.print("Instrument ID: " + rs.getInt("instrument_id"));
                System.out.print(", Type: " + rs.getString("instrument_type"));
                System.out.print(", Brand: " + rs.getString("brand"));
                System.out.println(", Rental fee: " + rs.getDouble("rental_fee"));
           }

        } catch (Exception e) {
            e.printStackTrace();
        } 
    }
    
    /**
     * This function will find all of the instruments which are rented and which students are renting what instrument. 
     */
    public static void show_inventory(Statement stmt) {

        try{
            QUERY = "select instrument_id, brand, instrument_type, rental_fee, student_id "
                    + "from instruments_for_rent "
                    + "where in_stock = 0 ;";

            ResultSet rs = stmt.executeQuery(QUERY);	
            
            while (rs.next()) {
                // Retrieve by column name
                System.out.print("Instrument ID: " + rs.getInt("instrument_id"));
                System.out.print(", Type: " + rs.getString("instrument_type"));
                System.out.print(", Brand: " + rs.getString("brand"));
                System.out.print(", Rental fee: " + rs.getDouble("rental_fee"));
                System.out.println(", Student ID: " + rs.getInt("student_id"));
            }


        } catch (Exception e) {
            e.printStackTrace();    //om nåt går fel så kommer error text!
        } 
    }
    
    /**
     * will try to connect to the DB using the logg-in data and make a connection
     * @return Connection conn - a connection object that contains links to local host and DB
     */
    public static Connection try_connect() {
        Connection conn = null;
        try {
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(DB_URL, USER, PASS);
            conn.setAutoCommit(false);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return conn;
    }
    
    /**
     * 
     * @return a string that contains all possible commands the user can use
     */
    public static void PrintCommandList() {
        String commandList = 
                      "show - show available instruments from the school.\n"
                    + "inventory - show what instruments are rented right now and by whom.\n"
                    + "rent - rent an available instrument.\n"
                    + "return - return an instrument from inventory.\n"
                    + "help - list possible commands\n"
                    + "q - quit this program.\n\n";
        System.out.print(commandList);
    }
    
    /**
     * 
     */
    public static void PrintWelcomeString() {
        String helloString = "Hello!\nThis program lets users interact with the Sound Good School´s Database.\n"
                    + "These are the commands available:\n\n";
        System.out.print(helloString);
    }
        
    /**
     * a function not meant for the user to have. It was used to add more instruments to the database.
    */
    public static void admin_add_instrument() {
        
        Scanner in = new Scanner(System.in);
        
        try {
            // try to pen a connection
            Connection conn = try_connect();
            Statement stmt = conn.createStatement();
            
            System.out.println("Add instrument ID: ");
            int new_instrumentID = Integer.parseInt(in.nextLine());
            
            System.out.println("Add brand: ");
            String new_brand = in.nextLine();
            
            System.out.println("Add rental fee: ");
            int new_rental_fee = Integer.parseInt(in.nextLine());
            
            System.out.println("Add instrument type: ");
            String new_instrument_type = in.nextLine();

            
            
            //push update onto database "rentals"
                QUERY = "insert into instruments_for_rent (instrument_id, brand, rental_fee, in_stock, instrument_type, student_id)"
                        + "values("
                        + new_instrumentID
                        + ", \""
                        + new_brand
                        + "\", "
                        + new_rental_fee
                        + ", "
                        + 1
                        + " , \""
                        + new_instrument_type
                        + "\" , "
                        + "NULL"
                        + ")"
                        + ";";

            stmt.executeUpdate(QUERY);
                
            
        conn.commit();
        conn.close();
        } catch (Exception e) {
           e.printStackTrace();
        } 
    
    }
    
}
