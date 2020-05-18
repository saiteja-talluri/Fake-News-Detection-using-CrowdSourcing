

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class AddPostResponse
 * Adds response to a post by the volunteer
 */
@WebServlet("/AddPostResponse")
public class AddPostResponse extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public AddPostResponse() {
        super();
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		HttpSession session = request.getSession();
		if(session == null || session.getAttribute("userid") == null) {
			// Redirect
		}
		int userid=(int) session.getAttribute("userid");
		int postid= Integer.parseInt(request.getParameter("post_id"));
		String comment= request.getParameter("comment");
		String [] liked_comments=request.getParameter("liked_comments").split(",");
		String [] unliked_comments=request.getParameter("unliked_comments").split(",");
		
		Boolean volresponse = Integer.parseInt(request.getParameter("response"))==1?true: false;
    	int success=-1;
    	try (Connection conn = DriverManager.getConnection(Config.url, Config.user, Config.password))
        {
            conn.setAutoCommit(false);
            try(
            		PreparedStatement stmt1 = conn.prepareStatement(Query.addresponse);
            		PreparedStatement stmt2 = conn.prepareStatement(Query.increasescore);
            		PreparedStatement stmt3 = conn.prepareStatement(Query.updaterating);
            		) {
                stmt1.setInt(1, postid);
                stmt1.setInt(2,userid);
                stmt1.setString(3, comment);
                stmt1.setBoolean(4, volresponse);
                success=stmt1.executeUpdate();
                System.out.println(success);
                stmt2.setInt(1, postid);
                success=stmt2.executeUpdate();
                for(int i=0;i<liked_comments.length;i++) {
                	if(liked_comments[i].isEmpty())continue; ////////// 
                	stmt3.setInt(1, 2);///// Configure 
                	stmt3.setLong(2, Integer.parseInt(liked_comments[i]));
                	stmt3.addBatch();
                }
                for(int i=0;i<unliked_comments.length;i++) {
                	if(unliked_comments[i].isEmpty())continue;
                	stmt3.setInt(1, -2);///// Configure
                    stmt3.setLong(2, Integer.parseInt(unliked_comments[i]));
                    stmt3.addBatch();
                }
                stmt3.executeBatch();
                System.out.println(success);
                conn.commit();
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
            e.printStackTrace();
        }
    	if(success!=-1) {
    		response.getWriter().println(DbHelper.okJson());
    	}else {
    		response.getWriter().println(DbHelper.errorJson(null));
    	}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
