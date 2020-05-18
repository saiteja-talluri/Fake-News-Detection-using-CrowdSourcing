

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/AdminLogin")
public class AdminLogin extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminLogin() {
        super();
        // TODO Auto-generated constructor stub
    }
	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */ 
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		if(session.getAttribute("adminid") != null) { // logged in
			response.getWriter().print(DbHelper.okJson().toString());
		}
		else {
			response.getWriter().print(DbHelper.errorJson("Not logged in"));
		}
		return;
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		HttpSession session = request.getSession();
		String emailid = request.getParameter("emailid");
		String password = request.getParameter("password");
		
		String query = Query.AdminLogin_query;
		List<List<Object>> res = DbHelper.executeQueryList(query, 
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING}, 
				new Object[] {emailid});
		
		String dbPass = res.isEmpty()? null : (String)res.get(0).get(0);
		System.out.println(dbPass);
		if(dbPass != null && dbPass.equals(password)) {
			session.setAttribute("adminid", res.get(0).get(1));  
			response.getWriter().print(DbHelper.okJson().toString());
		}
		else {
			response.getWriter().print(DbHelper.errorJson("Username/password incorrect").toString());
		}
		
		response.setContentType("application/json;charset=UTF-8");
	}

}
