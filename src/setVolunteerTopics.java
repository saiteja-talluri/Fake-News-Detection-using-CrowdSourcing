

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;

/**
 * Servlet implementation class setVolunteerTopics
 */
@WebServlet("/setVolunteerTopics")
public class setVolunteerTopics extends HttpServlet {
	private static final long serialVersionUID = 1L;
	public static ObjectMapper mapper = new ObjectMapper();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public setVolunteerTopics() {
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
			response.sendRedirect("LoginServlet");
		}	
		
		String id = (String) session.getAttribute("userid");
		int n =   Integer.parseInt(request.getParameter("number"));
		String t = (String) request.getParameter("topics");
		List<String> topics = mapper.readValue(t, List.class);
		
		String query = Query.addVolunteerTopic_query;
		Object[] obj = new Object[2*n];
		DbHelper.ParamType[] paramType = new DbHelper.ParamType[2*n];
		
		for(int i = 0;i<n;i++) {
			if(i == n-1) query += "(?,?)";
			else query += "(?,?),";
			obj[2*i] = topics.get(i);
			obj[2*i+1] = id;
			paramType[2*i] = DbHelper.ParamType.STRING;
			paramType[2*i + 1] = DbHelper.ParamType.STRING;
		}
		
		String json =  DbHelper.executeQueryJson(query, 
					paramType, 
					obj);
		response.getWriter().print(json);
	}

}
