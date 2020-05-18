

import java.io.IOException;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class getVerificationPosts
 */
@WebServlet("/getVerificationPosts")
public class getVerificationPosts extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public getVerificationPosts() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doPost(request,response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
		int id = -1;
		if(session.getAttribute("adminid") == null) {
			response.sendRedirect("index.html");
		}else {
			id = (int) session.getAttribute("adminid");
		}
		
		int limit = (int) Integer.parseInt(request.getParameter("limit"));
		limit  = (Config.verificationlimit>limit)? limit:Config.verificationlimit;
		
		String json = DbHelper.executeQueryJson(Query.getAdminPosts_query,
				new DbHelper.ParamType[] {DbHelper.ParamType.INT,DbHelper.ParamType.INT},
				new Object[] { Config.threshold,limit});
		
		System.out.println(json);
		response.getWriter().print(json);
		response.setContentType("application/json;charset=UTF-8");
		
		
	}

}
