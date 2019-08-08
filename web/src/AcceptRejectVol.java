

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class AcceptRejectVol
 */
@WebServlet("/AcceptRejectVol")
public class AcceptRejectVol extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AcceptRejectVol() {
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
		
		
		if(session.getAttribute("adminid") == null) {
//			response.sendRedirect("index.html");
		}
		int	adminid = (int)session.getAttribute("adminid");
		int userid = Integer.parseInt(request.getParameter("user_id"));
		int accept = Integer.parseInt(request.getParameter("accept"));
		Boolean success=false;
		try (Connection conn = DriverManager.getConnection(Config.url, Config.user, Config.password))
        {
            conn.setAutoCommit(false);
            try(
            		PreparedStatement stmt1 = conn.prepareStatement(Query.deleteApplication);
            		PreparedStatement stmt2 = conn.prepareStatement(Query.addVolunteer_app);
            		PreparedStatement stmt3 = conn.prepareStatement(Query.transferTopics);
            		) {
          
				if(accept==1) {
					stmt2.setInt(1, userid);
	                stmt2.setInt(2, adminid);
	                stmt2.executeUpdate();
	                stmt3.setInt(1, userid);
	                stmt3.executeUpdate();
	                
				}
				stmt1.setInt(1, userid);
                stmt1.executeUpdate();
                conn.commit();
                success=true;
            }
            catch(Exception ex)
            {
                conn.rollback();
                throw ex;
            }
            finally{
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
		if(success) {
			response.getWriter().print(DbHelper.okJson());
		}else {
			response.getWriter().print(DbHelper.errorJson(null));
		}
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
