

import java.io.Console;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * Servlet implementation class volunteer_add_application
 */
@WebServlet("/volunteer_add_application")
public class volunteer_add_application extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public volunteer_add_application() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
//		response.getWriter().append("Served at: ").append(request.getContextPath());
		HttpSession session = request.getSession();
		if(session.getAttribute("userid") == null) { //not logged in
			response.setHeader("require_auth", "yes");
//			response.setContentType("application/json;charset=UTF-8");
			return;  
		}   
		int id =  (int) session.getAttribute("userid");
		String [] tags=request.getParameter("values").split(","); 
		String sop=request.getParameter("sop");
		System.out.println(sop);
		System.out.println(new Timestamp(System.currentTimeMillis()));
//		executeUpdateJson(Query.addVolunteer, new DbHelper.ParamType[] {DbHelper.ParamType.INT,DbHelper.ParamType.}, new Object[] {});
		boolean success = false;
		try (Connection conn = DriverManager.getConnection(Config.url, Config.user, Config.password)){
            conn.setAutoCommit(false);
            try(
            		PreparedStatement stmt = conn.prepareStatement(Query.addVolunteer);
            		PreparedStatement stmt1 = conn.prepareStatement(Query.addVolunteer_topics)
            				) {
            	stmt.setInt(1, id);
            	stmt.setString(2,sop);
//            	stmt.setTimestamp(3,new Timestamp(System.currentTimeMillis()));
                stmt.executeUpdate();
        		for(int i=0;i<tags.length;i++) {
        			stmt1.setInt(1, id);
        			System.out.println(tags[i]);
        			stmt1.setString(2, tags[i]);    
        			stmt1.addBatch();
        		} 
        		stmt1.executeBatch();
                conn.commit();
                success=true;
            }
            catch(Exception ex){
                conn.rollback();
                throw ex;
            }
            finally{
                conn.setAutoCommit(true);
            } 
        } catch (Exception e) {
            e.printStackTrace();
        }
		if(success)response.getWriter().println(DbHelper.okJson().toString());
    	else response.getWriter().print(DbHelper.errorJson(null).toString());
		response.setContentType("application/json;charset=UTF-8");
	}
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */  
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
