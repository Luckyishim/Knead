using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KneadLMS
{
    public partial class Forums : Page
    {
        protected string GetForumBackUrl()
        {
            if (Request.QueryString["recipeId"] != null)
            {
                int rId;
                if (int.TryParse(Request.QueryString["recipeId"], out rId) && rId > 0)
                {
                    return "RecipeDetail.aspx?recipeId=" + rId;
                }
            }
            return "Default.aspx";
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadRecipesDropdown();

                if (Request.QueryString["recipeId"] != null)
                {
                    int rId;
                    if (int.TryParse(Request.QueryString["recipeId"], out rId))
                    {
                        if (ddlRecipeSelect.Items.FindByValue(rId.ToString()) != null)
                        {
                            ddlRecipeSelect.SelectedValue = rId.ToString();
                        }
                    }
                }

                LoadTopics();
            }
        }

        private void LoadRecipesDropdown()
        {
            try
            {
                DataTable dt = DbHelper.ExecuteQuery("SELECT RecipeID, RecipeTitle FROM Recipe ORDER BY RecipeTitle");
                ddlRecipeSelect.DataSource = dt;
                ddlRecipeSelect.DataTextField = "RecipeTitle";
                ddlRecipeSelect.DataValueField = "RecipeID";
                ddlRecipeSelect.DataBind();
                ddlRecipeSelect.Items.Insert(0, new ListItem("-- All Discussion Topics --", "0"));
            }
            catch
            {
                ddlRecipeSelect.Items.Insert(0, new ListItem("-- All Discussion Topics --", "0"));
            }
        }

        private void LoadTopics()
        {
            try
            {
                string search = txtSearchTopic.Text.Trim();
                string sql = @"SELECT ft.TopicID, ft.TopicTitle, ft.CreatedDate, u.FullName AS AuthorName, r.RecipeTitle,
                                      (SELECT COUNT(*) FROM ForumComment fc WHERE fc.TopicID = ft.TopicID) AS CommentCount
                               FROM ForumTopic ft
                               INNER JOIN Users u ON ft.UserID = u.UserID
                               LEFT JOIN Recipe r ON ft.RecipeID = r.RecipeID
                               WHERE 1=1";

                System.Collections.Generic.List<SqlParameter> pList = new System.Collections.Generic.List<SqlParameter>();

                int filterRecipeId = 0;
                if (int.TryParse(ddlRecipeSelect.SelectedValue, out filterRecipeId) && filterRecipeId > 0)
                {
                    sql += " AND ft.RecipeID = @RecipeID";
                    pList.Add(new SqlParameter("@RecipeID", filterRecipeId));
                }

                if (!string.IsNullOrEmpty(search))
                {
                    sql += " AND (ft.TopicTitle LIKE @Search OR u.FullName LIKE @Search OR r.RecipeTitle LIKE @Search)";
                    pList.Add(new SqlParameter("@Search", "%" + search + "%"));
                }

                sql += " ORDER BY ft.CreatedDate DESC";

                DataTable dt = DbHelper.ExecuteQuery(sql, pList.ToArray());

                if (dt.Rows.Count > 0)
                {
                    rptTopics.DataSource = dt;
                    rptTopics.DataBind();
                    pnlNoTopics.Visible = false;
                }
                else
                {
                    pnlNoTopics.Visible = true;
                }
            }
            catch (Exception ex)
            {
                pnlNoTopics.Visible = true;
                pnlNoTopics.Controls.Clear();
                pnlNoTopics.Controls.Add(new LiteralControl("<p style='color:red'>" + Server.HtmlEncode(ex.Message) + "</p>"));
            }
        }

        protected void ddlRecipeSelect_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadTopics();
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadTopics();
        }

        protected void btnOpenNewTopic_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }
            pnlNewTopicForm.Visible = true;
        }

        protected void btnCancelTopic_Click(object sender, EventArgs e)
        {
            pnlNewTopicForm.Visible = false;
        }

        protected void btnPostTopic_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            string title = txtTopicTitle.Text.Trim();
            string initialComment = txtInitialComment.Text.Trim();
            int selectedRecipeId = Convert.ToInt32(ddlRecipeSelect.SelectedValue);
            int userId = Convert.ToInt32(Session["UserID"]);

            if (string.IsNullOrEmpty(title))
            {
                pnlTopicError.Visible = true;
                litTopicError.Text = "Please enter a topic title.";
                return;
            }

            try
            {
                object recipeParamValue = selectedRecipeId > 0 ? (object)selectedRecipeId : DBNull.Value;

                string insTopicSql = @"INSERT INTO ForumTopic (RecipeID, UserID, TopicTitle, CreatedDate) 
                                       OUTPUT INSERTED.TopicID
                                       VALUES (@RecipeID, @UserID, @TopicTitle, GETDATE())";

                SqlParameter[] pTopic = {
                    new SqlParameter("@RecipeID", recipeParamValue),
                    new SqlParameter("@UserID", userId),
                    new SqlParameter("@TopicTitle", title)
                };

                int newTopicId = Convert.ToInt32(DbHelper.ExecuteScalar(insTopicSql, pTopic));

                if (!string.IsNullOrEmpty(initialComment))
                {
                    string insCommentSql = "INSERT INTO ForumComment (TopicID, UserID, CommentText, CreatedDate) VALUES (@TopicID, @UserID, @CommentText, GETDATE())";
                    SqlParameter[] pComment = {
                        new SqlParameter("@TopicID", newTopicId),
                        new SqlParameter("@UserID", userId),
                        new SqlParameter("@CommentText", initialComment)
                    };
                    DbHelper.ExecuteNonQuery(insCommentSql, pComment);
                }

                txtTopicTitle.Text = "";
                txtInitialComment.Text = "";
                pnlNewTopicForm.Visible = false;
                LoadTopics();
            }
            catch (Exception ex)
            {
                pnlTopicError.Visible = true;
                litTopicError.Text = "Error posting topic: " + ex.Message;
            }
        }
    }
}
