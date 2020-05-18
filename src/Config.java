 
/** 
 * Edit to provide your database credentials
 */
public class Config {
	public static final String url = "jdbc:postgresql://localhost:5432/Infact";
	public static final String user = "postgres";
	public static final String password = "7410";
	public static final int postlimit = 10;
	public static final int applicationlimit = 10;
	public static final int verificationlimit = 10;
	public static final int Responsethreshold = 10;
	public static final int threshold = 0;
}

/*
	response.setHeader("Access-Control-Allow-Origin", "*"); 
	please add this to every servelt
*/