using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KneadLMS
{
    public partial class ItemList : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCuisineDropdown();

                if (Request.QueryString["cuisineId"] != null)
                {
                    string cuisineId = Request.QueryString["cuisineId"];
                    if (ddlCuisineFilter.Items.FindByValue(cuisineId) != null)
                    {
                        ddlCuisineFilter.SelectedValue = cuisineId;
                    }
                }

                LoadRecipes();
            }
        }

        private void LoadCuisineDropdown()
        {
            try
            {
                DataTable dt = DbHelper.ExecuteQuery("SELECT CuisineID, CuisineName FROM Cuisine ORDER BY CuisineName");
                ddlCuisineFilter.DataSource = dt;
                ddlCuisineFilter.DataTextField = "CuisineName";
                ddlCuisineFilter.DataValueField = "CuisineID";
                ddlCuisineFilter.DataBind();
                ddlCuisineFilter.Items.Insert(0, new ListItem("All Cuisines", "0"));
            }
            catch
            {
                ddlCuisineFilter.Items.Insert(0, new ListItem("All Cuisines", "0"));
            }
        }

        private void LoadRecipes()
        {
            try
            {
                string search = txtSearch.Text.Trim();
                int selectedCuisineId = Convert.ToInt32(ddlCuisineFilter.SelectedValue);

                string sql = @"SELECT r.RecipeID, r.RecipeTitle, r.Description, r.Duration, r.Difficulty, r.Thumbnail, 
                                      c.CuisineName, ct.CourseTypeName 
                               FROM Recipe r
                               INNER JOIN CourseType ct ON r.CourseTypeID = ct.CourseTypeID
                               INNER JOIN Cuisine c ON ct.CuisineID = c.CuisineID
                               WHERE 1=1";

                System.Collections.Generic.List<SqlParameter> paramList = new System.Collections.Generic.List<SqlParameter>();

                if (selectedCuisineId > 0)
                {
                    sql += " AND c.CuisineID = @CuisineID";
                    paramList.Add(new SqlParameter("@CuisineID", selectedCuisineId));
                }

                string diff = ddlDifficultyFilter.SelectedValue;
                if (!string.IsNullOrEmpty(diff))
                {
                    sql += " AND r.Difficulty = @Difficulty";
                    paramList.Add(new SqlParameter("@Difficulty", diff));
                }

                if (!string.IsNullOrEmpty(search))
                {
                    sql += " AND (r.RecipeTitle LIKE @Search OR r.Description LIKE @Search OR r.Ingredients LIKE @Search OR c.CuisineName LIKE @Search)";
                    paramList.Add(new SqlParameter("@Search", "%" + search + "%"));
                }

                sql += " ORDER BY r.CreatedAt DESC";

                DataTable dt = DbHelper.ExecuteQuery(sql, paramList.ToArray());

                if (dt.Rows.Count > 0)
                {
                    rptRecipes.DataSource = dt;
                    rptRecipes.DataBind();
                    rptRecipes.Visible = true;
                    pnlNoResults.Visible = false;
                    litSectionTitle.Text = dt.Rows.Count + " Recipe(s) Found";
                }
                else
                {
                    rptRecipes.Visible = false;
                    pnlNoResults.Visible = true;
                    litSectionTitle.Text = "No Recipes Found";
                }
            }
            catch (Exception ex)
            {
                litSectionTitle.Text = "Error loading recipes: " + ex.Message;
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadRecipes();
        }

        protected void ddlCuisineFilter_SelectedIndexChanged(object sender, EventArgs e)
        {
            LoadRecipes();
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
