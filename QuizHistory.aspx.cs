using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace KneadLMS
{
    public partial class QuizHistory : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserInfo();
                LoadQuizHistory();
            }
        }

        private void LoadUserInfo()
        {
            string fullName = Session["FullName"] != null ? Session["FullName"].ToString() : "Member";
            string role = Session["Role"] != null ? Session["Role"].ToString() : "Member";

            litSidebarName.Text = Server.HtmlEncode(fullName);
            litSidebarRole.Text = Server.HtmlEncode(role == "Admin" ? "Administrator" : "Culinary Student");

            string[] parts = fullName.Trim().Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            string initials = parts.Length > 0 && !string.IsNullOrEmpty(parts[0]) ? parts[0].Substring(0, 1).ToUpper() : "U";
            if (parts.Length > 1 && !string.IsNullOrEmpty(parts[parts.Length - 1]))
            {
                initials += parts[parts.Length - 1].Substring(0, 1).ToUpper();
            }
            litSidebarInitials.Text = initials;
        }

        private void LoadQuizHistory()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                string sql = @"SELECT qa.AttemptID, qa.Score, qa.Passed, qa.AttemptDate, q.QuizID, q.QuizTitle, r.RecipeTitle
                               FROM QuizAttempt qa
                               INNER JOIN Quiz q ON qa.QuizID = q.QuizID
                               INNER JOIN Recipe r ON q.RecipeID = r.RecipeID
                               WHERE qa.UserID = @UserID
                               ORDER BY qa.AttemptDate DESC";

                SqlParameter[] p = { new SqlParameter("@UserID", userId) };
                DataTable dt = DbHelper.ExecuteQuery(sql, p);

                if (dt.Rows.Count > 0)
                {
                    gvQuizHistory.DataSource = dt;
                    gvQuizHistory.DataBind();
                    pnlNoAttempts.Visible = false;
                }
                else
                {
                    pnlNoAttempts.Visible = true;
                }
            }
            catch
            {
                pnlNoAttempts.Visible = true;
            }
        }
    }
}
