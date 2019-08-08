

import java.io.IOException;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;


/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/UserLogin")
public class UserLogin extends HttpServlet {
	private static final long serialVersionUID = 1L;
	public static ObjectMapper mapper = new ObjectMapper();
	
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UserLogin() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		if(session.getAttribute("userid") != null) { // logged in
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
        response.setHeader("Access-Control-Allow-Origin", "*");
		HttpSession session = request.getSession();

//		Map<String, Object> jsonMap = mapper.readValue(request.getInputStream(),
//			    new TypeReference<Map<String,Object>>(){});
//		
		String emailid = request.getParameter("email_id");
		String password = request.getParameter("password");
//		String emailid = jsonMap.get("email_id").toString();
//		String password = jsonMap.get("password").toString();  
//		
//		System.out.println( jsonMap.toString() + " Json");
		System.out.println( emailid + " Email");
		System.out.println( password + " PassMy");
		
		
		
		List<List<Object>> res = DbHelper.executeQueryList(Query.UserLogin_query, 
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING}, 
				new Object[] {emailid});
		
		System.out.println( res.toString() + " Response ");
		String dbPass = res.isEmpty()? null : (String)res.get(0).get(0);
		
		System.out.println( dbPass + " gotPassword ");
		
		if(dbPass != null && dbPass.equals(password)) {
			// Login Successfull
			int userid = (int) res.get(0).get(1);
			
			session.setAttribute("userid", userid);
			
			
			ObjectNode ret = DbHelper.okJson();
//			data.add(isVolunteer);
//			data.add(isApplication);
//			ret.putArray(DbHelper.DATA_LABEL).addAll(data); 
			System.out.println(ret.toString());
			response.getWriter().print(ret.toString());
	
		}
		else {
			response.getWriter().print(DbHelper.errorJson("Username/password incorrect").toString());
		}
		
		response.setContentType("application/json;charset=UTF-8");
	}
}
