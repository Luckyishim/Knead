using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace KneadLMS
{
    public partial class SavedRecipes : Page
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
                LoadSavedRecipes();
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

        private void LoadSavedRecipes()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                string sql = @"SELECT fr.FavoriteID, fr.AddedDate, r.RecipeID, r.RecipeTitle, r.Duration, r.Thumbnail,
                                      c.CuisineName, ct.CourseTypeName 
                               FROM FavoriteRecipe fr
                               INNER JOIN Recipe r ON fr.RecipeID = r.RecipeID
                               INNER JOIN CourseType ct ON r.CourseTypeID = ct.CourseTypeID
                               INNER JOIN Cuisine c ON ct.CuisineID = c.CuisineID
                               WHERE fr.UserID = @UserID
                               ORDER BY fr.AddedDate DESC";

                SqlParameter[] p = { new SqlParameter("@UserID", userId) };
                DataTable dt = DbHelper.ExecuteQuery(sql, p);

                if (dt.Rows.Count > 0)
                {
                    rptSaved.DataSource = dt;
                    rptSaved.DataBind();
                    pnlNoSaved.Visible = false;
                }
                else
                {
                    pnlNoSaved.Visible = true;
                }
            }
            catch
            {
                pnlNoSaved.Visible = true;
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
