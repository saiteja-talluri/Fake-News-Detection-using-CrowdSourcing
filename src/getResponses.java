

import java.io.IOException;
import java.sql.Timestamp;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class getResponses
 */
@WebServlet("/getResponses")
public class getResponses extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public getResponses() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
//		response.getWriter().append("Served at: ").append(request.getContextPath());
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
		int post_id =(int) Integer.parseInt(request.getParameter("post_id"));
		int limit = (int) Integer.parseInt(request.getParameter("limit"));
		limit  = (Config.Responsethreshold>limit)? limit:Config.Responsethreshold;
		
		String json = DbHelper.executeQueryJson(Query.getResponsesofPost_query,
				new DbHelper.ParamType[] {DbHelper.ParamType.INT,DbHelper.ParamType.INT},
				new Object[] {post_id,limit});
		
		System.out.println(json);
		response.getWriter().print(json);
		response.setContentType("application/json;charset=UTF-8");
		
	}

}
