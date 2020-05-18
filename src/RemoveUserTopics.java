

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Servlet implementation class RemoveUserTopics
 */
@WebServlet("/RemoveUserTopics")
public class RemoveUserTopics extends HttpServlet {
	private static final long serialVersionUID = 1L;
	public static ObjectMapper mapper = new ObjectMapper();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public RemoveUserTopics() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
		if(session.getAttribute("userid") == null) { //not logged in
			response.sendRedirect("LoginServlet");
		}

		int id = (int) session.getAttribute("userid");
		int n =   Integer.parseInt(request.getParameter("number"));
		String t = (String) request.getParameter("topics");
		Object[] topics = mapper.readValue(t, Object[].class);
		
		String query = Query.removeUserTopic_query;
		
		for(int i = 0;i<n;i++) {
			String json =  DbHelper.executeQueryJson(query, 
					new DbHelper.ParamType[] {DbHelper.ParamType.STRING, DbHelper.ParamType.INT}, 
					new Object[] {topics[i],id});
			
		}
		
		// Check and return 
		
		
	}
}
