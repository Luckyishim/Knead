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
            // Info check (no sidebar controls needed)
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
    }
}
