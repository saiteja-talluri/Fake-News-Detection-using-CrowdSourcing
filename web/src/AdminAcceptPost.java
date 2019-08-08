

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class AdminAcceptPost
 */
@WebServlet("/AdminAcceptPost")
public class AdminAcceptPost extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public AdminAcceptPost() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
//		response.getWriter().append("Served at: ").append(request.getContextPath());
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
		int id = -1;
		
		if(session.getAttribute("adminid") == null) { //not logged in
			response.sendRedirect("index.html");// redirect
		}else { 
			id = (int) session.getAttribute("adminid");
		}
	
		int post_id = (int) Integer.parseInt(request.getParameter("post_id"));
		String json = DbHelper.executeUpdateJson(Query.addApprovedposts_query, 
				new DbHelper.ParamType[] {DbHelper.ParamType.INT}, 
				new Integer[] {post_id});
		response.getWriter().print(json);
		response.setContentType("application/json;charset=UTF-8");
		
		
	}

}
