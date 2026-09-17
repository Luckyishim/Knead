using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace KneadLMS
{
    public partial class UserDashboard : Page
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
                LoadUserMetrics();
                LoadUserProgress();
            }
        }

        private void LoadUserInfo()
        {
            string fullName = Session["FullName"] != null ? Session["FullName"].ToString() : "Member";
            string role = Session["Role"] != null ? Session["Role"].ToString() : "Member";

            litSidebarName.Text = Server.HtmlEncode(fullName);
            litSidebarRole.Text = Server.HtmlEncode(role);

            string[] parts = fullName.Split(' ');
            litHeaderFirstName.Text = Server.HtmlEncode(parts[0]);

            string initials = parts[0].Substring(0, 1).ToUpper();
            if (parts.Length > 1 && !string.IsNullOrEmpty(parts[parts.Length - 1]))
            {
                initials += parts[parts.Length - 1].Substring(0, 1).ToUpper();
            }
            litSidebarInitials.Text = initials;
        }

        private void LoadUserMetrics()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                // Completed count
                object cObj = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM UserProgress WHERE UserID = @UserID AND IsCompleted = 1", new[] { new SqlParameter("@UserID", userId) });
                litCompletedCount.Text = cObj != null ? cObj.ToString() : "0";

                // Cuisines in progress
                object cipObj = DbHelper.ExecuteScalar("SELECT COUNT(DISTINCT ct.CuisineID) FROM UserProgress up INNER JOIN Recipe r ON up.RecipeID = r.RecipeID INNER JOIN CourseType ct ON r.CourseTypeID = ct.CourseTypeID WHERE up.UserID = @UserID", new[] { new SqlParameter("@UserID", userId) });
                litCuisinesInProgress.Text = (cipObj != null) ? Convert.ToInt32(cipObj).ToString() : "0";

                // Avg quiz score
                object qObj = DbHelper.ExecuteScalar("SELECT AVG(Score) FROM QuizAttempt WHERE UserID = @UserID", new[] { new SqlParameter("@UserID", userId) });
                litAvgQuizScore.Text = (qObj != null && qObj != DBNull.Value) ? Convert.ToInt32(qObj) + "%" : "N/A";

                // Forum topics count
                object fObj = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM ForumTopic WHERE UserID = @UserID", new[] { new SqlParameter("@UserID", userId) });
                litForumTopicCount.Text = fObj != null ? fObj.ToString() : "0";
            }
            catch
            {
            }
        }

        private void LoadUserProgress()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                string sql = @"SELECT up.ProgressID, up.IsCompleted, up.CompletedDate, r.RecipeID, r.RecipeTitle, r.Thumbnail, c.CuisineName
                               FROM UserProgress up
                               INNER JOIN Recipe r ON up.RecipeID = r.RecipeID
                               INNER JOIN CourseType ct ON r.CourseTypeID = ct.CourseTypeID
                               INNER JOIN Cuisine c ON ct.CuisineID = c.CuisineID
                               WHERE up.UserID = @UserID
                               ORDER BY up.CompletedDate DESC";

                SqlParameter[] p = { new SqlParameter("@UserID", userId) };
                DataTable dt = DbHelper.ExecuteQuery(sql, p);

                if (dt.Rows.Count > 0)
                {
                    rptUserProgress.DataSource = dt;
                    rptUserProgress.DataBind();
                    pnlNoProgress.Visible = false;
                }
                else
                {
                    pnlNoProgress.Visible = true;
                }
            }
            catch
            {
                pnlNoProgress.Visible = true;
            }
        }
    }
}
