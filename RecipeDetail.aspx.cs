using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace KneadLMS
{
    public partial class RecipeDetail : Page
    {
        private int recipeId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["recipeId"] != null && int.TryParse(Request.QueryString["recipeId"], out recipeId))
            {
                ViewState["RecipeID"] = recipeId;
            }
            else
            {
                recipeId = ViewState["RecipeID"] != null ? Convert.ToInt32(ViewState["RecipeID"]) : 1;
            }

            if (!IsPostBack)
            {
                LoadRecipeDetails();
                LoadRecipeSteps();
                CheckUserProgressAndFavorites();
                CheckQuizAvailability();
            }
        }

        private void LoadRecipeDetails()
        {
            try
            {
                string sql = @"SELECT r.*, ct.CourseTypeName, c.CuisineID, c.CuisineName 
                               FROM Recipe r 
                               INNER JOIN CourseType ct ON r.CourseTypeID = ct.CourseTypeID
                               INNER JOIN Cuisine c ON ct.CuisineID = c.CuisineID
                               WHERE r.RecipeID = @RecipeID";

                SqlParameter[] parameters = { new SqlParameter("@RecipeID", recipeId) };
                DataTable dt = DbHelper.ExecuteQuery(sql, parameters);

                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    litRecipeTitle.Text = Server.HtmlEncode(row["RecipeTitle"].ToString());
                    litDescription.Text = Server.HtmlEncode(row["Description"].ToString());
                    litDuration.Text = row["Duration"].ToString();
                    litCuisineBadge.Text = Server.HtmlEncode(row["CuisineName"].ToString());
                    litCourseBadge.Text = Server.HtmlEncode(row["CourseTypeName"].ToString());
                    litDifficultyBadge.Text = Server.HtmlEncode(row["Difficulty"].ToString());

                    lnkBreadcrumbCuisine.Text = Server.HtmlEncode(row["CuisineName"].ToString());
                    lnkBreadcrumbCuisine.NavigateUrl = "ItemList.aspx?cuisineId=" + row["CuisineID"].ToString();
                    litBreadcrumbCourse.Text = Server.HtmlEncode(row["CourseTypeName"].ToString());
                    ViewState["CuisineID"] = row["CuisineID"];

                    string thumb = row["Thumbnail"].ToString();
                    imgThumbnail.ImageUrl = string.IsNullOrEmpty(thumb) ? "images/momo_dish.jpg" : thumb;

                    string videoUrl = row["VideoURL"] != null ? row["VideoURL"].ToString() : "";
                    ViewState["VideoURL"] = string.IsNullOrEmpty(videoUrl) ? "" : videoUrl;
                    // Store video URL on the client side as a data attribute so the iframe
                    // is only created after the user clicks Play (lazy-load).
                    try
                    {
                        pnlVideoPlayer.Attributes["data-video"] = ViewState["VideoURL"].ToString();
                    }
                    catch { }
                    lnkForumDiscussions.NavigateUrl = "Forums.aspx?recipeId=" + recipeId.ToString();

                    litVideoTitle.Text = Server.HtmlEncode(row["RecipeTitle"].ToString());
                    litVideoDuration.Text = row["Duration"].ToString() + ":00";

                    string rawIngredients = row["Ingredients"].ToString();
                    if (!string.IsNullOrEmpty(rawIngredients))
                    {
                        string[] ingList = rawIngredients.Split(new char[] { '|', '\n' }, StringSplitOptions.RemoveEmptyEntries);
                        rptIngredients.DataSource = ingList;
                        rptIngredients.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                litRecipeTitle.Text = "Error loading recipe: " + ex.Message;
            }
        }

        private void LoadRecipeSteps()
        {
            try
            {
                string sql = "SELECT StepNumber, Instruction, ImageURL FROM RecipeStep WHERE RecipeID = @RecipeID ORDER BY StepNumber ASC";
                SqlParameter[] parameters = { new SqlParameter("@RecipeID", recipeId) };
                DataTable dt = DbHelper.ExecuteQuery(sql, parameters);

                if (dt.Rows.Count > 0)
                {
                    rptSteps.DataSource = dt;
                    rptSteps.DataBind();
                    pnlNoSteps.Visible = false;
                }
                else
                {
                    pnlNoSteps.Visible = true;
                }
            }
            catch
            {
                pnlNoSteps.Visible = true;
            }
        }

        private void CheckUserProgressAndFavorites()
        {
            if (Session["UserID"] == null)
            {
                litProgressPercent.Text = "0%";
                pnlProgressFill.Style["width"] = "0%";
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                // Progress check
                string progSql = "SELECT IsCompleted FROM UserProgress WHERE UserID = @UserID AND RecipeID = @RecipeID";
                SqlParameter[] p1 = { new SqlParameter("@UserID", userId), new SqlParameter("@RecipeID", recipeId) };
                object completed = DbHelper.ExecuteScalar(progSql, p1);

                if (completed != null && Convert.ToBoolean(completed))
                {
                    litProgressPercent.Text = "100%";
                    pnlProgressFill.Style["width"] = "100%";
                    btnMarkComplete.Text = "Completed ✓";
                    btnMarkComplete.CssClass = "btn-dark";
                }
                else
                {
                    litProgressPercent.Text = "0%";
                    pnlProgressFill.Style["width"] = "0%";
                }

                // Favorite check
                string favSql = "SELECT COUNT(*) FROM FavoriteRecipe WHERE UserID = @UserID AND RecipeID = @RecipeID";
                SqlParameter[] p2 = { new SqlParameter("@UserID", userId), new SqlParameter("@RecipeID", recipeId) };
                int favCount = Convert.ToInt32(DbHelper.ExecuteScalar(favSql, p2));

                if (favCount > 0)
                {
                    btnSaveFavorite.Text = "Saved ♥";
                    btnSaveFavorite.Style["color"] = "var(--primary-orange)";
                }
                else
                {
                    btnSaveFavorite.Text = "Save";
                }
            }
            catch
            {
            }
        }

        private void CheckQuizAvailability()
        {
            try
            {
                string sql = "SELECT QuizID FROM Quiz WHERE RecipeID = @RecipeID";
                SqlParameter[] p = { new SqlParameter("@RecipeID", recipeId) };
                object quizIdObj = DbHelper.ExecuteScalar(sql, p);

                if (quizIdObj != null)
                {
                    lnkStartQuiz.NavigateUrl = "QuizDetail.aspx?quizId=" + quizIdObj.ToString();
                    lnkStartQuiz.Visible = true;
                }
                else
                {
                    lnkStartQuiz.NavigateUrl = "Quizzes.aspx";
                }
            }
            catch
            {
                lnkStartQuiz.NavigateUrl = "Quizzes.aspx";
            }
        }

        protected void btnMarkComplete_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                string checkSql = "SELECT ProgressID FROM UserProgress WHERE UserID = @UserID AND RecipeID = @RecipeID";
                SqlParameter[] pCheck = { new SqlParameter("@UserID", userId), new SqlParameter("@RecipeID", recipeId) };
                object progIdObj = DbHelper.ExecuteScalar(checkSql, pCheck);

                if (progIdObj != null)
                {
                    string updateSql = "UPDATE UserProgress SET IsCompleted = 1, CompletedDate = GETDATE() WHERE ProgressID = @ProgressID";
                    SqlParameter[] pUpd = { new SqlParameter("@ProgressID", Convert.ToInt32(progIdObj)) };
                    DbHelper.ExecuteNonQuery(updateSql, pUpd);
                }
                else
                {
                    string insSql = "INSERT INTO UserProgress (UserID, RecipeID, IsCompleted, CompletedDate) VALUES (@UserID, @RecipeID, 1, GETDATE())";
                    SqlParameter[] pIns = { new SqlParameter("@UserID", userId), new SqlParameter("@RecipeID", recipeId) };
                    DbHelper.ExecuteNonQuery(insSql, pIns);
                }

                litProgressPercent.Text = "100%";
                pnlProgressFill.Style["width"] = "100%";
                btnMarkComplete.Text = "Completed ✓";
                lblStatusMessage.Text = "Congratulations! Lesson marked as completed.";
                CheckUserProgressAndFavorites();
            }
            catch (Exception ex)
            {
                lblStatusMessage.Text = "Error updating progress: " + ex.Message;
            }
        }

        protected void btnSaveFavorite_Click(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                string checkSql = "SELECT FavoriteID FROM FavoriteRecipe WHERE UserID = @UserID AND RecipeID = @RecipeID";
                SqlParameter[] pCheck = { new SqlParameter("@UserID", userId), new SqlParameter("@RecipeID", recipeId) };
                object favIdObj = DbHelper.ExecuteScalar(checkSql, pCheck);

                if (favIdObj != null)
                {
                    string delSql = "DELETE FROM FavoriteRecipe WHERE FavoriteID = @FavoriteID";
                    SqlParameter[] pDel = { new SqlParameter("@FavoriteID", Convert.ToInt32(favIdObj)) };
                    DbHelper.ExecuteNonQuery(delSql, pDel);

                    lblStatusMessage.Text = "Removed from your saved recipes.";
                }
                else
                {
                    string insSql = "INSERT INTO FavoriteRecipe (UserID, RecipeID, AddedDate) VALUES (@UserID, @RecipeID, GETDATE())";
                    SqlParameter[] pIns = { new SqlParameter("@UserID", userId), new SqlParameter("@RecipeID", recipeId) };
                    DbHelper.ExecuteNonQuery(insSql, pIns);

                    lblStatusMessage.Text = "Added to your saved recipes!";
                }
                CheckUserProgressAndFavorites();
            }
            catch (Exception ex)
            {
                lblStatusMessage.Text = "Error updating favorite: " + ex.Message;
            }
        }
    }
}
