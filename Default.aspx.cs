using System;
using System.Data;
using System.Web.UI;

namespace KneadLMS
{
    public partial class DefaultPage : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadStats();
                LoadCuisines();
            }
        }

        private void LoadStats()
        {
            try
            {
                object cCount = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM Cuisine");
                object ctCount = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM CourseType");
                object rCount = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM Recipe");
                object uCount = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM Users");

                litCuisineCount.Text    = cCount != null ? cCount.ToString()  : "0";
                litCourseTypeCount.Text = ctCount != null ? ctCount.ToString() : "0";
                litRecipeCount.Text     = rCount != null ? rCount.ToString()   : "0";
                litUserCount.Text       = uCount != null ? uCount.ToString()   : "0";
            }
            catch (Exception ex)
            {
                // Surface DB errors — do not hide with fake data
                litCuisineCount.Text    = "—";
                litCourseTypeCount.Text = "—";
                litRecipeCount.Text     = "—";
                litUserCount.Text       = "DB Error: " + ex.Message;
            }
        }

        private void LoadCuisines()
        {
            try
            {
                DataTable dt = DbHelper.ExecuteQuery("SELECT CuisineID, CuisineName, ImageURL FROM Cuisine");
                rptCuisines.DataSource = dt;
                rptCuisines.DataBind();
            }
            catch
            {
                // Silence if database not ready
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
