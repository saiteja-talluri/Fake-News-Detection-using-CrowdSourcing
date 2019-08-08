

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class setUserTopics
 */
@WebServlet("/setUserTopics")
public class setUserTopics extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public setUserTopics() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
		if(session.getAttribute("userid") == null) { //not logged in
			response.setHeader("require_auth", "yes");
//			response.setContentType("application/json;charset=UTF-8");
			return;  
		}   
		int id =  (int) session.getAttribute("userid");
		String [] tags=request.getParameter("values").split(",");
		System.out.println(tags.toString());
		DbHelper.ParamType[] paramType[] = new DbHelper.ParamType[tags.length][2]; 
		Object[] obj[] = new Object[tags.length][2];
		for(int i = 0;i < tags.length;i++) {
			paramType[i][0] = DbHelper.ParamType.INT;
			paramType[i][1] = DbHelper.ParamType.STRING;
			
			obj[i][0] = (Object) id;
			obj[i][1] = (Object) tags[i];
			
		}
		System.out.println(paramType.toString());
		System.out.println(obj.toString());
		
		String json = DbHelper.executeBatchUpdateJson(Query.addUserTopic_query,paramType,obj);
		
		response.getWriter().print(json);
		response.setContentType("application/json;charset=UTF-8");
		
	}

}
