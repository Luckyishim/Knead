using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace KneadLMS
{
    public partial class MyProgress : Page
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
                LoadUserProgress();
            }
        }

        private void LoadUserInfo()
        {
            // Info check (no sidebar controls needed)
        }

        private void LoadUserProgress()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                string sql = @"SELECT up.ProgressID, up.IsCompleted, up.CompletedDate, r.RecipeID, r.RecipeTitle, r.Thumbnail, c.CuisineName, ct.CourseTypeName
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
                    rptProgress.DataSource = dt;
                    rptProgress.DataBind();
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
