using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace KneadLMS
{
    public partial class ForumDetail : Page
    {
        private int topicId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["topicId"] != null && int.TryParse(Request.QueryString["topicId"], out topicId))
            {
                ViewState["TopicID"] = topicId;
            }
            else if (ViewState["TopicID"] != null)
            {
                topicId = Convert.ToInt32(ViewState["TopicID"]);
            }
            else
            {
                Response.Redirect("Forums.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadTopicInfo();
                LoadComments();
            }
        }

        private void LoadTopicInfo()
        {
            try
            {
                string sql = @"SELECT ft.TopicTitle, ft.CreatedDate, u.FullName AS AuthorName, r.RecipeTitle 
                               FROM ForumTopic ft
                               INNER JOIN Users u ON ft.UserID = u.UserID
                               LEFT JOIN Recipe r ON ft.RecipeID = r.RecipeID
                               WHERE ft.TopicID = @TopicID";

                SqlParameter[] p = { new SqlParameter("@TopicID", topicId) };
                DataTable dt = DbHelper.ExecuteQuery(sql, p);

                if (dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    litTopicTitle.Text = Server.HtmlEncode(r["TopicTitle"].ToString());
                    litAuthorName.Text = Server.HtmlEncode(r["AuthorName"].ToString());
                    litTopicDate.Text = Convert.ToDateTime(r["CreatedDate"]).ToString("MMM dd, yyyy HH:mm");
                    litRecipeBadge.Text = string.IsNullOrEmpty(r["RecipeTitle"].ToString()) ? "General" : Server.HtmlEncode(r["RecipeTitle"].ToString());
                }
            }
            catch
            {
            }
        }

        private void LoadComments()
        {
            try
            {
                string sql = @"SELECT fc.CommentID, fc.CommentText, fc.CreatedDate, u.FullName AS AuthorName
                               FROM ForumComment fc
                               INNER JOIN Users u ON fc.UserID = u.UserID
                               WHERE fc.TopicID = @TopicID
                               ORDER BY fc.CreatedDate ASC";

                SqlParameter[] p = { new SqlParameter("@TopicID", topicId) };
                DataTable dt = DbHelper.ExecuteQuery(sql, p);

                litCommentCount.Text = dt.Rows.Count.ToString();

                if (dt.Rows.Count > 0)
                {
                    rptComments.DataSource = dt;
                    rptComments.DataBind();
                    pnlNoComments.Visible = false;
                }
                else
                {
                    pnlNoComments.Visible = true;
                }
            }
            catch
            {
                pnlNoComments.Visible = true;
            }
        }

        protected void btnAddComment_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            string commentText = txtNewComment.Text.Trim();
            int userId = Convert.ToInt32(Session["UserID"]);

            if (string.IsNullOrEmpty(commentText))
            {
                pnlCommentError.Visible = true;
                litCommentError.Text = "Please enter a comment before submitting.";
                return;
            }

            try
            {
                string insSql = "INSERT INTO ForumComment (TopicID, UserID, CommentText, CreatedDate) VALUES (@TopicID, @UserID, @CommentText, GETDATE())";
                SqlParameter[] p = {
                    new SqlParameter("@TopicID", topicId),
                    new SqlParameter("@UserID", userId),
                    new SqlParameter("@CommentText", commentText)
                };

                DbHelper.ExecuteNonQuery(insSql, p);

                txtNewComment.Text = "";
                pnlCommentError.Visible = false;
                LoadComments();
            }
            catch (Exception ex)
            {
                pnlCommentError.Visible = true;
                litCommentError.Text = "Error adding comment: " + ex.Message;
            }
        }
    }
}
