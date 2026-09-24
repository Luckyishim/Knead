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

        public string GetImageUrl(object imagePath)
        {
            if (imagePath == null || imagePath == DBNull.Value)
                return ResolveUrl("~/images/momo_dish.jpg");

            string path = imagePath.ToString().Trim();
            if (string.IsNullOrEmpty(path))
                return ResolveUrl("~/images/momo_dish.jpg");

            if (path.StartsWith("http://", StringComparison.OrdinalIgnoreCase) ||
                path.StartsWith("https://", StringComparison.OrdinalIgnoreCase))
            {
                return path;
            }

            return ResolveUrl("~/" + path.TrimStart('~', '/'));
        }
    }
}
