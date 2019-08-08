

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;

/**
 * Servlet implementation class addPostAdmin
 */
@WebServlet("/addPostAdmin")
@MultipartConfig
public class addPostAdmin extends HttpServlet {
	private static final long serialVersionUID = 1L;
	public static ObjectMapper mapper = new ObjectMapper();
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public addPostAdmin() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		HttpSession session = request.getSession();
		boolean isUser = true;
		int id = -1;
			if(session.getAttribute("adminid") == null) { //not logged in
				response.sendRedirect("index.html");
			}else { 
				id = (int) session.getAttribute("adminid");
			}
		String img_metadata = null;
		List<Object> bytea = new ArrayList<>();

		Part filePart=request.getPart("file-upload");
		
		System.out.println(filePart);
		String filePath = filePart.getSubmittedFileName();
		if(filePath != null) {
		Path p = Paths.get(filePath);
		String fileName = p.getFileName().toString();
		int  filelen=(int) filePart.getSize();
		InputStream fileContent = filePart.getInputStream();
		
		
		bytea.add(fileContent);
		bytea.add(filelen);
		
		System.out.println("Add Post: Image File Name " + fileName.substring(fileName.length()-3));
		System.out.println("Add Post: Image File Path " + p);
		System.out.println("Add Post: Image File Size " + filelen);
		
		img_metadata = "image/" +fileName.substring(fileName.lastIndexOf(".")+1);
		
		}else {
			bytea = null;
			img_metadata = null;
		}
		String title = request.getParameter("post-title");
		String body = request.getParameter("post-body");
//		String image = request.getParameter("imagefile");
		
		
//		File file = new File(request.getParameter("articlebody"));
//		String requestbody = request.getReader().lines()
//			    .reduce("", (accumulator, actual) -> accumulator + actual);
		
//		System.out.println(requestbody);
		
		mapper.configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false); 
		
//		Map<String, Object> jsonMap = mapper.readValue(request.getInputStream(),
//			    new TypeReference<Map<String,Object>>(){});
////		
//		System.out.println( jsonMap.toString() + " Json");
		
//		List<Posts> myObjects = mapper.readValue(request.getInputStream() , new TypeReference<List<Posts>>(){});
		
//		System.out.println( myObjects.toString() + " Json");
		System.out.println("Add Post Title: Title " + title);
		System.out.println("Add Post Body: body " + body);
		
		
		 // Image body title author_name
		String json = null;
		boolean success = false;
    	try (Connection conn = DriverManager.getConnection(Config.url, Config.user, Config.password))
        {
            conn.setAutoCommit(false);
            try(PreparedStatement stmt = conn.prepareStatement(Query.addPostVol_query);
            		PreparedStatement stmt1 = conn.prepareStatement(Query.addPostTopics_query);	
            		) {
            	if(img_metadata == null) {
    				stmt.setBinaryStream(1,null);
    				stmt.setString(2,null);
    				stmt.setString(3, body);
    				stmt.setString(4, title);
    				stmt.setInt(5, id);

        		}else {
    				stmt.setBinaryStream(1,(InputStream) bytea.get(0),(Integer)bytea.get(1));
    				stmt.setString(2,img_metadata.toLowerCase());
    				stmt.setString(3, body);
    				stmt.setString(4, title);
    				stmt.setInt(5, id);
        		}
            	
                stmt.execute();
                ResultSet rs = stmt.getResultSet();
                if(rs.next()) {
                	int post_id = rs.getInt(1);
                	System.out.println(post_id);
                	String [] tags=request.getParameter("values").split(",");
            		System.out.println(tags.toString());
            		
            		for(int i = 0;i < tags.length;i++) {
            			stmt1.setInt(1,post_id);
            			stmt1.setString(2,tags[i]);
            			stmt1.addBatch();
            		}
            		
            		stmt1.executeBatch();
                	
                    conn.commit();
                    success = true;
                    
                }
               
            }
            catch(Exception ex)
            {
                conn.rollback();
                throw ex;
            }
            finally{
                conn.setAutoCommit(true);
            }
        } catch (Exception e) {
        	response.getWriter().print(DbHelper.errorJson(e.getMessage()).toString());
        	response.setContentType("application/json;charset=UTF-8");
        }
    	
    	if(success) {
    		response.getWriter().print(DbHelper.okJson().toString());
    	}else {
    		response.getWriter().print(DbHelper.errorJson("Error in Adding").toString());
    	}
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
