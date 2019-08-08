

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
 * Servlet implementation class getApplication
 */
@WebServlet("/getApplication")
public class getApplication extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public getApplication() {
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
		if(session == null || session.getAttribute("adminid") == null) {
			// Redirect
		}
		
		int adminid=(int) session.getAttribute("adminid");
		
		int limit = (int) Integer.parseInt(request.getParameter("limit"));
		
		limit  = (Config.applicationlimit>limit)? limit:Config.applicationlimit;
		
		String json = DbHelper.executeQueryJson(Query.getApplication_query, 
				new DbHelper.ParamType[] {DbHelper.ParamType.INT},
				new Object[] {limit});
		
		response.getWriter().println(json.toString());
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
