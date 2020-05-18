

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class RegisterServlet
 */
@WebServlet("/Register")
public class Register extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Register() {
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
		
		String name = request.getParameter("name");
		String password = request.getParameter("password");
		String phonenumber = request.getParameter("phonenumber");
		String email = request.getParameter("email");
		
		System.out.println("Register: Name " + name);
		System.out.println("Register: Password " + password);
		System.out.println("Register: Phonenumber " + phonenumber);
		System.out.println("Register: Email " + email);
		
		String json =  DbHelper.executeUpdateJson(Query.Register_query, 
				new DbHelper.ParamType[] {DbHelper.ParamType.STRING, DbHelper.ParamType.STRING,DbHelper.ParamType.STRING,DbHelper.ParamType.STRING}, 
				new Object[] {email,name,password,phonenumber});
		
		response.getWriter().print(json);
		response.setContentType("application/json;charset=UTF-8");
	}

}
