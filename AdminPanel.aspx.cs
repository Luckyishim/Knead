using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.IO;
using System.Web.UI.WebControls;

namespace KneadLMS
{
    public partial class AdminPanel : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null || Session["Role"] == null ||
                !string.Equals(Session["Role"].ToString(), "Admin", StringComparison.OrdinalIgnoreCase))
            {
                Response.Redirect("Login.aspx");
                return;
            }

            LoadAdminInfo();

            if (!IsPostBack)
            {
                LoadOverviewMetrics();
                LoadUsersTable();
                PopulateDropdowns();
                // If page requested with editRecipe query, load into top form
                if (!string.IsNullOrEmpty(Request.QueryString["editRecipe"]))
                {
                    int rid;
                    if (int.TryParse(Request.QueryString["editRecipe"], out rid))
                    {
                        LoadRecipeIntoForm(rid);
                        ShowTab("recipes");
                    }
                }
            }
        }

        private void LoadRecipeIntoForm(int recipeId)
        {
            try
            {
                DataTable dt = DbHelper.ExecuteQuery(@"SELECT r.RecipeID, r.RecipeTitle, r.Description, r.Ingredients, r.Duration, r.Difficulty, r.Thumbnail, r.VideoURL, r.CourseTypeID
                                                         FROM Recipe r
                                                         WHERE r.RecipeID = @RecipeID", new[] { new SqlParameter("@RecipeID", recipeId) });
                if (dt.Rows.Count > 0)
                {
                    var r = dt.Rows[0];
                    hfEditRecipeId.Value = r["RecipeID"].ToString();
                    txtRecipeTitle.Text = r["RecipeTitle"].ToString();
                    txtRecipeDesc.Text = r["Description"] != DBNull.Value ? r["Description"].ToString() : string.Empty;
                    txtRecipeIngredients.Text = r["Ingredients"] != DBNull.Value ? r["Ingredients"].ToString() : string.Empty;
                    txtRecipeDuration.Text = r["Duration"] != DBNull.Value ? r["Duration"].ToString() : string.Empty;
                    txtRecipeThumb.Text = r["Thumbnail"] != DBNull.Value ? r["Thumbnail"].ToString() : string.Empty;
                    txtRecipeVideo.Text = r["VideoURL"] != DBNull.Value ? r["VideoURL"].ToString() : string.Empty;
                    // ensure dropdowns populated and set selections
                    PopulateDropdowns();
                    if (r["CourseTypeID"] != DBNull.Value)
                    {
                        try { ddlRecipeCourseType.SelectedValue = r["CourseTypeID"].ToString(); } catch { }
                    }
                    if (r["Difficulty"] != DBNull.Value)
                    {
                        try { ddlRecipeDifficulty.SelectedValue = r["Difficulty"].ToString(); } catch { }
                    }
                    btnAddRecipe.Text = "Update Recipe";
                    BindRecipeSteps(recipeId);
                }
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error loading recipe: " + ex.Message, false);
            }
        }

        protected void ddlStepRecipe_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlStepRecipe.SelectedValue)) return;
            int recipeId = Convert.ToInt32(ddlStepRecipe.SelectedValue);
            BindRecipeSteps(recipeId);
            ShowTab("recipes");
        }

        private void BindRecipeSteps(int recipeId)
        {
            try
            {
                DataTable dt = DbHelper.ExecuteQuery("SELECT StepID, StepNumber, Instruction FROM RecipeStep WHERE RecipeID=@RecipeID ORDER BY StepNumber", new[] { new SqlParameter("@RecipeID", recipeId) });
                gvRecipeSteps.DataSource = dt;
                gvRecipeSteps.DataBind();
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error loading recipe steps: " + ex.Message, false);
            }
        }

        protected void gvRecipeSteps_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            if (string.Equals(e.CommandName, "EditStep", StringComparison.OrdinalIgnoreCase))
            {
                int stepId = Convert.ToInt32(e.CommandArgument);
                DataTable dt = DbHelper.ExecuteQuery("SELECT StepID, RecipeID, StepNumber, Instruction FROM RecipeStep WHERE StepID=@StepID", new[] { new SqlParameter("@StepID", stepId) });
                if (dt.Rows.Count > 0)
                {
                    var r = dt.Rows[0];
                    hfEditStepId.Value = r["StepID"].ToString();
                    ddlStepRecipe.SelectedValue = r["RecipeID"].ToString();
                    txtStepNumber.Text = r["StepNumber"].ToString();
                    txtStepInstruction.Text = r["Instruction"].ToString();
                    // btnAddStep is declared in markup; ensure designer contains it. If not, fall back to client text change
                    try { btnAddStep.Text = "Update Step"; } catch { }
                    ShowTab("recipes");
                }
                return;
            }

            if (string.Equals(e.CommandName, "MoveUp", StringComparison.OrdinalIgnoreCase) || string.Equals(e.CommandName, "MoveDown", StringComparison.OrdinalIgnoreCase))
            {
                int stepId = Convert.ToInt32(e.CommandArgument);
                // Load current step to get RecipeID and StepNumber
                DataTable dt = DbHelper.ExecuteQuery("SELECT RecipeID, StepNumber FROM RecipeStep WHERE StepID=@StepID", new[] { new SqlParameter("@StepID", stepId) });
                if (dt.Rows.Count == 0) return;
                int recipeId = Convert.ToInt32(dt.Rows[0]["RecipeID"]);
                int stepNum = Convert.ToInt32(dt.Rows[0]["StepNumber"]);
                if (e.CommandName == "MoveUp") stepNum--; else stepNum++;
                // Find step that currently occupies target slot and swap numbers
                DataTable other = DbHelper.ExecuteQuery("SELECT TOP 1 StepID, StepNumber FROM RecipeStep WHERE RecipeID=@RecipeID AND StepNumber=@StepNumber", new[] { new SqlParameter("@RecipeID", recipeId), new SqlParameter("@StepNumber", stepNum) });
                DbHelper.ExecuteNonQuery("UPDATE RecipeStep SET StepNumber = -1 WHERE StepID = @StepID", new[] { new SqlParameter("@StepID", stepId) });
                if (other.Rows.Count > 0)
                {
                    int otherId = Convert.ToInt32(other.Rows[0]["StepID"]);
                    DbHelper.ExecuteNonQuery("UPDATE RecipeStep SET StepNumber = @NewNum WHERE StepID = @StepID", new[] { new SqlParameter("@NewNum", Convert.ToInt32(other.Rows[0]["StepNumber"] == DBNull.Value ? stepNum : other.Rows[0]["StepNumber"])), new SqlParameter("@StepID", otherId) });
                }
                DbHelper.ExecuteNonQuery("UPDATE RecipeStep SET StepNumber = @NewNum WHERE StepID = @StepID", new[] { new SqlParameter("@NewNum", stepNum), new SqlParameter("@StepID", stepId) });
                BindRecipeSteps(recipeId);
                return;
            }
        }

        protected void gvRecipeSteps_RowDeleting(object sender, System.Web.UI.WebControls.GridViewDeleteEventArgs e)
        {
            int stepId = Convert.ToInt32(gvRecipeSteps.DataKeys[e.RowIndex].Value);
            try
            {
                DbHelper.ExecuteNonQuery("DELETE FROM RecipeStep WHERE StepID=@StepID", new[] { new SqlParameter("@StepID", stepId) });
                // reload steps for currently selected recipe
                if (!string.IsNullOrEmpty(ddlStepRecipe.SelectedValue)) BindRecipeSteps(Convert.ToInt32(ddlStepRecipe.SelectedValue));
                ShowAdminMsg("Step deleted.", true);
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error deleting step: " + ex.Message, false);
            }
        }

        // Attempts to find the actual column name on a table from a list of candidates.
        private string GetActualColumn(string tableName, string[] candidates)
        {
            try
            {
                DataTable cols = DbHelper.ExecuteQuery("SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName",
                    new[] { new SqlParameter("@TableName", tableName) });
                var existing = new System.Collections.Generic.HashSet<string>(StringComparer.OrdinalIgnoreCase);
                foreach (DataRow r in cols.Rows)
                {
                    existing.Add(r["COLUMN_NAME"].ToString());
                }
                foreach (var c in candidates)
                {
                    if (existing.Contains(c)) return c;
                }
            }
            catch
            {
                // ignore and return null
            }
            return null;
        }

        // Load data into admin GridViews for editing
        private void LoadAdminTables()
        {
            LoadCuisinesTable();
            LoadRecipesTable();
            LoadQuizzesTable();
        }

        private void LoadAdminInfo()
        {
            string fullName = Session["FullName"] != null ? Session["FullName"].ToString() : "System Admin";
            string role     = Session["Role"] != null ? Session["Role"].ToString() : "Admin";

            litAdminName.Text = Server.HtmlEncode(fullName);
            litAdminRole.Text = Server.HtmlEncode(role == "Admin" ? "System Administrator" : role);

            string[] parts = fullName.Split(' ');
            string initials = parts[0].Substring(0, 1).ToUpper();
            if (parts.Length > 1 && !string.IsNullOrEmpty(parts[parts.Length - 1]))
            {
                initials += parts[parts.Length - 1].Substring(0, 1).ToUpper();
            }
            litAdminInitials.Text = initials;
        }

        private void LoadOverviewMetrics()
        {
            try
            {
                object uCount = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM Users");
                object cCount = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM Cuisine");
                object rCount = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM Recipe");
                object qCount = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM Quiz");

                litTotalUsers.Text    = uCount != null ? uCount.ToString() : "0";
                litTotalCuisines.Text = cCount != null ? cCount.ToString() : "0";
                litTotalRecipes.Text  = rCount != null ? rCount.ToString() : "0";
                litTotalQuizzes.Text  = qCount != null ? qCount.ToString() : "0";
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error loading metrics (LoadOverviewMetrics): " + ex.Message, false);
            }
        }

        private void LoadUsersTable()
        {
            try
            {
                DataTable dt = DbHelper.ExecuteQuery(
                    "SELECT UserID, FullName, Email, Role, CreatedAt FROM Users ORDER BY UserID DESC");
                gvUsers.DataSource = dt;
                gvUsers.DataBind();
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error loading users table (LoadUsersTable): " + ex.Message, false);
            }
        }

        private void PopulateDropdowns()
        {
            try
            {
                // Resolve actual column name for Cuisine primary key (many schemas use Id or CuisineID)
                string cuisineIdCol = GetActualColumn("Cuisine", new[] { "CuisineID", "CuisineId", "Cuisine_Id", "Id", "ID", "cuisineid" });
                DataTable dtC;
                if (!string.IsNullOrEmpty(cuisineIdCol))
                {
                    dtC = DbHelper.ExecuteQuery("SELECT " + cuisineIdCol + " AS CuisineID, CuisineName FROM Cuisine ORDER BY CuisineName");
                }
                else
                {
                    // Fallback: try to load at least names so UI remains usable
                    dtC = DbHelper.ExecuteQuery("SELECT CuisineName FROM Cuisine ORDER BY CuisineName");
                }
                ddlCourseCuisine.DataSource     = dtC;
                ddlCourseCuisine.DataTextField  = "CuisineName";
                ddlCourseCuisine.DataValueField = "CuisineID";
                ddlCourseCuisine.DataBind();

                DataTable dtCT = DbHelper.ExecuteQuery(
                    "SELECT CourseTypeID, CourseTypeName FROM CourseType ORDER BY CourseTypeName");
                ddlRecipeCourseType.DataSource     = dtCT;
                ddlRecipeCourseType.DataTextField  = "CourseTypeName";
                ddlRecipeCourseType.DataValueField = "CourseTypeID";
                ddlRecipeCourseType.DataBind();

                DataTable dtR = DbHelper.ExecuteQuery(
                    "SELECT RecipeID, RecipeTitle FROM Recipe ORDER BY RecipeTitle");
                ddlStepRecipe.DataSource     = dtR;
                ddlStepRecipe.DataTextField  = "RecipeTitle";
                ddlStepRecipe.DataValueField = "RecipeID";
                ddlStepRecipe.DataBind();

                ddlQuizRecipe.DataSource     = dtR;
                ddlQuizRecipe.DataTextField  = "RecipeTitle";
                ddlQuizRecipe.DataValueField = "RecipeID";
                ddlQuizRecipe.DataBind();

                // Media manager recipe dropdown
                ddlMediaRecipe.DataSource     = dtR;
                ddlMediaRecipe.DataTextField  = "RecipeTitle";
                ddlMediaRecipe.DataValueField = "RecipeID";
                ddlMediaRecipe.DataBind();

                DataTable dtQ = DbHelper.ExecuteQuery(
                    "SELECT QuizID, QuizTitle FROM Quiz ORDER BY QuizTitle");
                ddlQuestionQuiz.DataSource     = dtQ;
                ddlQuestionQuiz.DataTextField  = "QuizTitle";
                ddlQuestionQuiz.DataValueField = "QuizID";
                ddlQuestionQuiz.DataBind();
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error loading dropdowns (PopulateDropdowns): " + ex.Message, false);
            }
        }

        private void ShowAdminMsg(string msg, bool isSuccess)
        {
            pnlAdminMsg.Visible = true;
            litAdminMsg.Text = Server.HtmlEncode(msg);
            pnlAdminMsg.Style["background-color"] = isSuccess ? "#D1FAE5" : "#FEE2E2";
            pnlAdminMsg.Style["color"]             = isSuccess ? "#065F46" : "#991B1B";
            pnlAdminMsg.Style["border"]            = isSuccess ? "1px solid #6EE7B7" : "1px solid #FCA5A5";
        }

        protected void btnNavOverview_Click(object sender, EventArgs e)
        {
            LoadOverviewMetrics();
            LoadUsersTable();
            ShowTab("overview");
        }

        protected void btnNavCuisines_Click(object sender, EventArgs e)
        {
            PopulateDropdowns();
            LoadAdminTables();
            ShowTab("cuisines");
        }

        protected void btnNavRecipes_Click(object sender, EventArgs e)
        {
            PopulateDropdowns();
            LoadAdminTables();
            ShowTab("recipes");
        }

        protected void btnNavQuizzes_Click(object sender, EventArgs e)
        {
            PopulateDropdowns();
            LoadAdminTables();
            ShowTab("quizzes");
        }

        // --- Cuisines Grid Events ---
        protected void gvAdminCuisines_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            try
            {
                if (e.CommandName == "EditCuisine")
                {
                    int id = Convert.ToInt32(e.CommandArgument);
                    // Load cuisine into form for editing
                    DataTable dt = DbHelper.ExecuteQuery("SELECT CuisineID, CuisineName, Description, ImageURL FROM Cuisine WHERE CuisineID = @ID",
                        new[] { new SqlParameter("@ID", id) });
                    if (dt.Rows.Count > 0)
                    {
                        var r = dt.Rows[0];
                        hfEditCuisineId.Value = r["CuisineID"].ToString();
                        txtNewCuisineName.Text = r["CuisineName"].ToString();
                        txtNewCuisineDesc.Text = r["Description"] != DBNull.Value ? r["Description"].ToString() : string.Empty;
                        txtNewCuisineImg.Text = r["ImageURL"] != DBNull.Value ? r["ImageURL"].ToString() : string.Empty;
                        btnAddCuisine.Text = "Update Cuisine";
                        ShowTab("cuisines");
                    }
                }
                else if (e.CommandName == "DeleteCuisine")
                {
                    int id = Convert.ToInt32(e.CommandArgument);
                    // Check for linked course types
                    object linked = DbHelper.ExecuteScalar("SELECT COUNT(*) FROM CourseType WHERE CuisineID = @ID", new[] { new SqlParameter("@ID", id) });
                    if (linked != null && Convert.ToInt32(linked) > 0)
                    {
                        ShowAdminMsg("Cannot delete cuisine: it has course types associated. Remove them first.", false);
                        return;
                    }
                    DbHelper.ExecuteNonQuery("DELETE FROM Cuisine WHERE CuisineID = @ID", new[] { new SqlParameter("@ID", id) });
                    LoadAdminTables();
                    PopulateDropdowns();
                    LoadOverviewMetrics();
                    ShowAdminMsg("Cuisine deleted.", true);
                    ShowTab("cuisines");
                }
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error processing action: " + ex.Message, false);
            }
        }

        protected void gvAdminCuisines_RowDeleting(object sender, System.Web.UI.WebControls.GridViewDeleteEventArgs e)
        {
            int cuisineId = Convert.ToInt32(gvAdminCuisines.DataKeys[e.RowIndex].Value);
            try
            {
                DbHelper.ExecuteNonQuery("DELETE FROM Cuisine WHERE CuisineID=@ID",
                    new[] { new SqlParameter("@ID", cuisineId) });
                LoadAdminTables();
                PopulateDropdowns();
                LoadOverviewMetrics();
                ShowAdminMsg("Cuisine deleted.", true);
                ShowTab("cuisines");
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error deleting cuisine: " + ex.Message, false);
            }
        }

        // --- Recipes Grid Events ---
        protected void gvAdminRecipes_RowEditing(object sender, System.Web.UI.WebControls.GridViewEditEventArgs e)
        {
            // Keep legacy in-grid editing but don't require it for top-form edits
            gvAdminRecipes.EditIndex = e.NewEditIndex;
            LoadRecipesTable();
            ShowTab("recipes");
        }

        protected void gvAdminRecipes_RowCommand(object sender, System.Web.UI.WebControls.GridViewCommandEventArgs e)
        {
            try
            {
                if (string.Equals(e.CommandName, "EditRecipe", StringComparison.OrdinalIgnoreCase))
                {
                    int recipeId = Convert.ToInt32(e.CommandArgument);
                    DataTable dt = DbHelper.ExecuteQuery(@"SELECT r.RecipeID, r.RecipeTitle, r.Description, r.Ingredients, r.Duration, r.Difficulty, r.Thumbnail, r.VideoURL, r.CourseTypeID, ct.CuisineID
                                                         FROM Recipe r
                                                         LEFT JOIN CourseType ct ON r.CourseTypeID = ct.CourseTypeID
                                                         WHERE r.RecipeID = @RecipeID", new[] { new SqlParameter("@RecipeID", recipeId) });
                    if (dt.Rows.Count > 0)
                    {
                        var r = dt.Rows[0];
                        hfEditRecipeId.Value = r["RecipeID"].ToString();
                        txtRecipeTitle.Text = r["RecipeTitle"].ToString();
                        txtRecipeDesc.Text = r["Description"] != DBNull.Value ? r["Description"].ToString() : string.Empty;
                        txtRecipeIngredients.Text = r["Ingredients"] != DBNull.Value ? r["Ingredients"].ToString() : string.Empty;
                        txtRecipeDuration.Text = r["Duration"] != DBNull.Value ? r["Duration"].ToString() : string.Empty;
                        txtRecipeThumb.Text = r["Thumbnail"] != DBNull.Value ? r["Thumbnail"].ToString() : string.Empty;
                        txtRecipeVideo.Text = r["VideoURL"] != DBNull.Value ? r["VideoURL"].ToString() : string.Empty;
                        // Try to set CourseType and difficulty dropdowns
                        if (r["CourseTypeID"] != DBNull.Value)
                        {
                            string ctId = r["CourseTypeID"].ToString();
                            PopulateDropdowns(); // ensure ddlRecipeCourseType is loaded
                            try { ddlRecipeCourseType.SelectedValue = ctId; } catch { }
                        }
                        if (r["Difficulty"] != DBNull.Value)
                        {
                            try { ddlRecipeDifficulty.SelectedValue = r["Difficulty"].ToString(); } catch { }
                        }
                        btnAddRecipe.Text = "Update Recipe";
                        try { litRecipeEditHint.Text = "Editing recipe ID: " + hfEditRecipeId.Value; litRecipeEditHint.Visible = true; } catch { }
                        // Load steps for this recipe in the steps grid
                        BindRecipeSteps(recipeId);
                        ShowTab("recipes");
                    }
                }
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error loading recipe for edit: " + ex.Message, false);
            }
        }

        protected void gvAdminRecipes_RowCancelingEdit(object sender, System.Web.UI.WebControls.GridViewCancelEditEventArgs e)
        {
            gvAdminRecipes.EditIndex = -1;
            LoadRecipesTable();
            ShowTab("recipes");
        }

        protected void gvAdminRecipes_RowUpdating(object sender, System.Web.UI.WebControls.GridViewUpdateEventArgs e)
        {
            int recipeId = Convert.ToInt32(gvAdminRecipes.DataKeys[e.RowIndex].Value);
            var row = gvAdminRecipes.Rows[e.RowIndex];
            var txtTitle = (System.Web.UI.WebControls.TextBox)row.FindControl("txtEditRecipeTitle");
            var ddlCourse = (System.Web.UI.WebControls.DropDownList)row.FindControl("ddlEditRecipeCourseType");
            var txtDuration = (System.Web.UI.WebControls.TextBox)row.FindControl("txtEditRecipeDuration");
            var ddlDiff = (System.Web.UI.WebControls.DropDownList)row.FindControl("ddlEditRecipeDifficulty");

            string title = txtTitle != null ? txtTitle.Text.Trim() : string.Empty;
            int courseTypeId = 0;
            if (ddlCourse != null)
            {
                int.TryParse(ddlCourse.SelectedValue, out courseTypeId);
            }
            int duration = 0;
            if (txtDuration != null)
            {
                int.TryParse(txtDuration.Text.Trim(), out duration);
            }
            string diff = ddlDiff != null ? ddlDiff.SelectedValue : "Intermediate";

            try
            {
                if (courseTypeId > 0)
                {
                    DbHelper.ExecuteNonQuery(@"UPDATE Recipe SET RecipeTitle=@Title, CourseTypeID=@CourseTypeID, Duration=@Duration, Difficulty=@Difficulty WHERE RecipeID=@ID",
                        new[] {
                            new SqlParameter("@Title", title),
                            new SqlParameter("@CourseTypeID", courseTypeId),
                            new SqlParameter("@Duration", duration),
                            new SqlParameter("@Difficulty", diff),
                            new SqlParameter("@ID", recipeId)
                        });
                }
                else
                {
                    DbHelper.ExecuteNonQuery(@"UPDATE Recipe SET RecipeTitle=@Title, Duration=@Duration, Difficulty=@Difficulty WHERE RecipeID=@ID",
                        new[] {
                            new SqlParameter("@Title", title),
                            new SqlParameter("@Duration", duration),
                            new SqlParameter("@Difficulty", diff),
                            new SqlParameter("@ID", recipeId)
                        });
                }
                gvAdminRecipes.EditIndex = -1;
                LoadRecipesTable();
                PopulateDropdowns();
                ShowAdminMsg("Recipe updated.", true);
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error updating recipe: " + ex.Message, false);
            }
            ShowTab("recipes");
        }

        protected void gvAdminRecipes_RowDeleting(object sender, System.Web.UI.WebControls.GridViewDeleteEventArgs e)
        {
            int recipeId = Convert.ToInt32(gvAdminRecipes.DataKeys[e.RowIndex].Value);
            try
            {
                DbHelper.ExecuteNonQuery("DELETE FROM Recipe WHERE RecipeID=@ID",
                    new[] { new SqlParameter("@ID", recipeId) });
                LoadRecipesTable();
                PopulateDropdowns();
                LoadOverviewMetrics();
                ShowAdminMsg("Recipe deleted.", true);
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error deleting recipe: " + ex.Message, false);
            }
            ShowTab("recipes");
        }

        protected void gvAdminRecipes_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
        {
            if (e.Row.RowType == System.Web.UI.WebControls.DataControlRowType.DataRow && (e.Row.RowState & System.Web.UI.WebControls.DataControlRowState.Edit) > 0)
            {
                var ddlCourse = (System.Web.UI.WebControls.DropDownList)e.Row.FindControl("ddlEditRecipeCourseType");
                if (ddlCourse != null)
                {
                    DataTable dtCT = DbHelper.ExecuteQuery(
                        @"SELECT ct.CourseTypeID, ct.CourseTypeName + ' (' + c.CuisineName + ')' AS CourseTypeDisplay
                          FROM CourseType ct
                          INNER JOIN Cuisine c ON ct.CuisineID = c.CuisineID
                          ORDER BY c.CuisineName, ct.CourseTypeName");
                    ddlCourse.DataSource = dtCT;
                    ddlCourse.DataTextField = "CourseTypeDisplay";
                    ddlCourse.DataValueField = "CourseTypeID";
                    ddlCourse.DataBind();

                    DataRowView drv = e.Row.DataItem as DataRowView;
                    if (drv != null && drv.Row.Table.Columns.Contains("CourseTypeID") && drv["CourseTypeID"] != DBNull.Value)
                    {
                        string currentCtId = drv["CourseTypeID"].ToString();
                        var item = ddlCourse.Items.FindByValue(currentCtId);
                        if (item != null) ddlCourse.SelectedValue = currentCtId;
                    }
                }

                var ddlDiff = (System.Web.UI.WebControls.DropDownList)e.Row.FindControl("ddlEditRecipeDifficulty");
                if (ddlDiff != null)
                {
                    DataRowView drv = e.Row.DataItem as DataRowView;
                    if (drv != null && drv.Row.Table.Columns.Contains("Difficulty") && drv["Difficulty"] != DBNull.Value)
                    {
                        string currentDiff = drv["Difficulty"].ToString();
                        var item = ddlDiff.Items.FindByValue(currentDiff);
                        if (item != null)
                        {
                            ddlDiff.SelectedValue = currentDiff;
                        }
                        else
                        {
                            ddlDiff.Items.Add(new System.Web.UI.WebControls.ListItem(currentDiff, currentDiff));
                            ddlDiff.SelectedValue = currentDiff;
                        }
                    }
                }
            }
        }

        // --- Quizzes Grid Events ---
        protected void gvAdminQuizzes_RowEditing(object sender, System.Web.UI.WebControls.GridViewEditEventArgs e)
        {
            gvAdminQuizzes.EditIndex = e.NewEditIndex;
            LoadQuizzesTable();
            ShowTab("quizzes");
        }

        protected void gvAdminQuizzes_RowCancelingEdit(object sender, System.Web.UI.WebControls.GridViewCancelEditEventArgs e)
        {
            gvAdminQuizzes.EditIndex = -1;
            LoadQuizzesTable();
            ShowTab("quizzes");
        }

        protected void gvAdminQuizzes_RowUpdating(object sender, System.Web.UI.WebControls.GridViewUpdateEventArgs e)
        {
            int quizId = Convert.ToInt32(gvAdminQuizzes.DataKeys[e.RowIndex].Value);
            var row = gvAdminQuizzes.Rows[e.RowIndex];
            var txtTitle = (System.Web.UI.WebControls.TextBox)row.FindControl("txtEditQuizTitle");
            var ddlRecipe = (System.Web.UI.WebControls.DropDownList)row.FindControl("ddlEditQuizRecipe");
            var txtPass = (System.Web.UI.WebControls.TextBox)row.FindControl("txtEditPassingScore");

            string title = txtTitle != null ? txtTitle.Text.Trim() : string.Empty;
            int recipeId = 0;
            if (ddlRecipe != null)
            {
                int.TryParse(ddlRecipe.SelectedValue, out recipeId);
            }
            int passing = 70;
            if (txtPass != null)
            {
                int.TryParse(txtPass.Text.Trim(), out passing);
            }

            try
            {
                if (recipeId > 0)
                {
                    DbHelper.ExecuteNonQuery("UPDATE Quiz SET QuizTitle=@Title, RecipeID=@RecipeID, PassingScore=@PS WHERE QuizID=@ID",
                        new[] {
                            new SqlParameter("@Title", title),
                            new SqlParameter("@RecipeID", recipeId),
                            new SqlParameter("@PS", passing),
                            new SqlParameter("@ID", quizId)
                        });
                }
                else
                {
                    DbHelper.ExecuteNonQuery("UPDATE Quiz SET QuizTitle=@Title, PassingScore=@PS WHERE QuizID=@ID",
                        new[] {
                            new SqlParameter("@Title", title),
                            new SqlParameter("@PS", passing),
                            new SqlParameter("@ID", quizId)
                        });
                }
                gvAdminQuizzes.EditIndex = -1;
                LoadQuizzesTable();
                PopulateDropdowns();
                ShowAdminMsg("Quiz updated.", true);
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error updating quiz: " + ex.Message, false);
            }
            ShowTab("quizzes");
        }

        protected void gvAdminQuizzes_RowDeleting(object sender, System.Web.UI.WebControls.GridViewDeleteEventArgs e)
        {
            int quizId = Convert.ToInt32(gvAdminQuizzes.DataKeys[e.RowIndex].Value);
            try
            {
                DbHelper.ExecuteNonQuery("DELETE FROM Quiz WHERE QuizID=@ID",
                    new[] { new SqlParameter("@ID", quizId) });
                LoadQuizzesTable();
                PopulateDropdowns();
                LoadOverviewMetrics();
                ShowAdminMsg("Quiz deleted.", true);
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error deleting quiz: " + ex.Message, false);
            }
            ShowTab("quizzes");
        }

        protected void gvAdminQuizzes_RowDataBound(object sender, System.Web.UI.WebControls.GridViewRowEventArgs e)
        {
            if (e.Row.RowType == System.Web.UI.WebControls.DataControlRowType.DataRow && (e.Row.RowState & System.Web.UI.WebControls.DataControlRowState.Edit) > 0)
            {
                var ddlRecipe = (System.Web.UI.WebControls.DropDownList)e.Row.FindControl("ddlEditQuizRecipe");
                if (ddlRecipe != null)
                {
                    DataTable dtR = DbHelper.ExecuteQuery(
                        "SELECT RecipeID, RecipeTitle FROM Recipe ORDER BY RecipeTitle");
                    ddlRecipe.DataSource = dtR;
                    ddlRecipe.DataTextField = "RecipeTitle";
                    ddlRecipe.DataValueField = "RecipeID";
                    ddlRecipe.DataBind();

                    DataRowView drv = e.Row.DataItem as DataRowView;
                    if (drv != null && drv.Row.Table.Columns.Contains("RecipeID") && drv["RecipeID"] != DBNull.Value)
                    {
                        string currentRId = drv["RecipeID"].ToString();
                        var item = ddlRecipe.Items.FindByValue(currentRId);
                        if (item != null) ddlRecipe.SelectedValue = currentRId;
                    }
                }
            }
        }

        protected void ddlMediaRecipe_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlMediaRecipe.SelectedValue)) return;
            int recipeId = Convert.ToInt32(ddlMediaRecipe.SelectedValue);
            try
            {
                string sql = "SELECT Thumbnail, VideoURL FROM Recipe WHERE RecipeID = @RecipeID";
                SqlParameter[] p = { new SqlParameter("@RecipeID", recipeId) };
                DataTable dt = DbHelper.ExecuteQuery(sql, p);
                if (dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    txtMediaImageUrl.Text = r["Thumbnail"] != DBNull.Value ? r["Thumbnail"].ToString() : string.Empty;
                    txtMediaVideoUrl.Text = r["VideoURL"] != DBNull.Value ? r["VideoURL"].ToString() : string.Empty;
                }
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error loading media: " + ex.Message, false);
            }
        }

        protected void btnSaveMedia_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlMediaRecipe.SelectedValue))
            {
                ShowAdminMsg("Please select a recipe to update.", false);
                return;
            }

            int recipeId = Convert.ToInt32(ddlMediaRecipe.SelectedValue);
            string imageUrl = txtMediaImageUrl.Text.Trim();
            string videoUrl = txtMediaVideoUrl.Text.Trim();

            try
            {
                // Handle uploaded image if provided
                if (fuMediaImage.HasFile)
                {
                    string[] allowed = new[] { ".png", ".jpg", ".jpeg", ".webp", ".gif" };
                    string ext = Path.GetExtension(fuMediaImage.FileName).ToLowerInvariant();
                    if (Array.IndexOf(allowed, ext) < 0)
                    {
                        ShowAdminMsg("Invalid image type. Allowed: jpg, png, webp, gif.", false);
                        return;
                    }
                    if (fuMediaImage.PostedFile.ContentLength > 5 * 1024 * 1024)
                    {
                        ShowAdminMsg("Image too large (max 5MB).", false);
                        return;
                    }

                    string folder = Server.MapPath("~/uploads/recipes/");
                    if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
                    string fileName = Guid.NewGuid().ToString("N") + ext;
                    string fullPath = Path.Combine(folder, fileName);
                    fuMediaImage.SaveAs(fullPath);
                    imageUrl = "~/uploads/recipes/" + fileName;
                }

                string sql = "UPDATE Recipe SET Thumbnail = @Thumb, VideoURL = @Video WHERE RecipeID = @RecipeID";
                SqlParameter[] pars = {
                    new SqlParameter("@Thumb", string.IsNullOrEmpty(imageUrl) ? (object)DBNull.Value : imageUrl),
                    new SqlParameter("@Video", string.IsNullOrEmpty(videoUrl) ? (object)DBNull.Value : videoUrl),
                    new SqlParameter("@RecipeID", recipeId)
                };
                DbHelper.ExecuteNonQuery(sql, pars);

                txtMediaImageUrl.Text = imageUrl;
                ShowAdminMsg("Media updated successfully.", true);
                PopulateDropdowns();
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error saving media: " + ex.Message, false);
            }
            ShowTab("recipes");
        }

        private void ShowTab(string tabName)
        {
            pnlOverview.Visible  = tabName == "overview";
            pnlCuisines.Visible  = tabName == "cuisines";
            pnlRecipes.Visible   = tabName == "recipes";
            pnlQuizzes.Visible   = tabName == "quizzes";

            btnNavOverview.CssClass  = "menu-item" + (tabName == "overview"  ? " active" : "");
            btnNavCuisines.CssClass  = "menu-item" + (tabName == "cuisines"  ? " active" : "");
            btnNavRecipes.CssClass   = "menu-item" + (tabName == "recipes"   ? " active" : "");
            btnNavQuizzes.CssClass   = "menu-item" + (tabName == "quizzes"   ? " active" : "");

            if (tabName == "cuisines") LoadCuisinesTable();
            if (tabName == "recipes") LoadRecipesTable();
            if (tabName == "quizzes") LoadQuizzesTable();
        }

        private void LoadCuisinesTable()
        {
            try
            {
                string cuisineIdCol = GetActualColumn("Cuisine", new[] { "CuisineID", "CuisineId", "Cuisine_Id", "Id", "ID", "cuisineid" });
                string idCol = cuisineIdCol ?? "CuisineID";
                string subcount = "(SELECT COUNT(*) FROM CourseType ct WHERE ct.CuisineID = c." + idCol + ")";
                DataTable dtC = DbHelper.ExecuteQuery(
                    "SELECT c." + idCol + " AS CuisineID, c.CuisineName, c.Description, " + subcount + " AS CourseCount " +
                    "FROM Cuisine c ORDER BY c." + idCol + " DESC");
                gvAdminCuisines.DataSource = dtC;
                gvAdminCuisines.DataBind();
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error loading Cuisines table (LoadCuisinesTable): " + ex.Message, false);
            }
        }

        private void LoadRecipesTable()
        {
            try
            {
                DataTable dtR = DbHelper.ExecuteQuery(
                    @"SELECT r.RecipeID, r.RecipeTitle, r.Duration, r.Difficulty, r.CourseTypeID,
                             ct.CuisineID, c.CuisineName, ct.CourseTypeName
                      FROM Recipe r
                      LEFT JOIN CourseType ct ON r.CourseTypeID = ct.CourseTypeID
                      LEFT JOIN Cuisine c ON ct.CuisineID = c.CuisineID
                      ORDER BY r.RecipeID DESC");
                gvAdminRecipes.DataSource = dtR;
                gvAdminRecipes.DataBind();
                // Also refresh steps grid if a recipe is selected in ddlStepRecipe
                if (!string.IsNullOrEmpty(ddlStepRecipe.SelectedValue))
                {
                    int sel = Convert.ToInt32(ddlStepRecipe.SelectedValue);
                    BindRecipeSteps(sel);
                }
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error loading Recipes table (LoadRecipesTable): " + ex.Message, false);
            }
        }

        private void LoadQuizzesTable()
        {
            try
            {
                DataTable dtQ = DbHelper.ExecuteQuery(
                    @"SELECT q.QuizID, q.QuizTitle, q.PassingScore, q.RecipeID, r.RecipeTitle,
                             (SELECT COUNT(*) FROM QuizQuestion qq WHERE qq.QuizID = q.QuizID) AS QuestionCount
                      FROM Quiz q
                      LEFT JOIN Recipe r ON q.RecipeID = r.RecipeID
                      ORDER BY q.QuizID DESC");
                gvAdminQuizzes.DataSource = dtQ;
                gvAdminQuizzes.DataBind();
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error loading Quizzes table (LoadQuizzesTable): " + ex.Message, false);
            }
        }

        protected void btnAddCuisine_Click(object sender, EventArgs e)
        {
            string name = txtNewCuisineName.Text.Trim();
            string desc = txtNewCuisineDesc.Text.Trim();
            string img  = txtNewCuisineImg.Text.Trim();

            if (string.IsNullOrEmpty(name))
            {
                ShowAdminMsg("Cuisine Name is required.", false);
                ShowTab("cuisines");
                return;
            }

            try
            {
                // If hfEditCuisineId has a value, perform UPDATE instead of INSERT
                if (!string.IsNullOrEmpty(hfEditCuisineId.Value))
                {
                    int editId = Convert.ToInt32(hfEditCuisineId.Value);
                    string sql = "UPDATE Cuisine SET CuisineName=@Name, Description=@Desc, ImageURL=@Img WHERE CuisineID=@ID";
                    SqlParameter[] p = {
                        new SqlParameter("@Name", name),
                        new SqlParameter("@Desc", string.IsNullOrEmpty(desc) ? (object)DBNull.Value : desc),
                        new SqlParameter("@Img",  string.IsNullOrEmpty(img)  ? "images/momo_dish.jpg" : img),
                        new SqlParameter("@ID", editId)
                    };
                    DbHelper.ExecuteNonQuery(sql, p);
                    // Reset edit state and inputs
                    hfEditCuisineId.Value = "";
                    btnAddCuisine.Text = "Add Cuisine";
                    txtNewCuisineName.Text = "";
                    txtNewCuisineDesc.Text = "";
                    txtNewCuisineImg.Text  = "";
                    ShowAdminMsg("Cuisine updated successfully.", true);
                }
                else
                {
                    string sql = "INSERT INTO Cuisine (CuisineName, Description, ImageURL) VALUES (@Name, @Desc, @Img)";
                    SqlParameter[] p = {
                        new SqlParameter("@Name", name),
                        new SqlParameter("@Desc", string.IsNullOrEmpty(desc) ? (object)DBNull.Value : desc),
                        new SqlParameter("@Img",  string.IsNullOrEmpty(img)  ? "images/momo_dish.jpg" : img)
                    };
                    DbHelper.ExecuteNonQuery(sql, p);
                    txtNewCuisineName.Text = "";
                    txtNewCuisineDesc.Text = "";
                    txtNewCuisineImg.Text  = "";
                    ShowAdminMsg("Cuisine '" + name + "' added successfully!", true);
                }

                // Refresh metrics and dropdowns after change
                LoadOverviewMetrics();
                PopulateDropdowns();
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error adding cuisine: " + ex.Message, false);
            }
            ShowTab("cuisines");
        }

        protected void btnAddCourseType_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlCourseCuisine.SelectedValue))
            {
                ShowAdminMsg("Please select a cuisine first.", false);
                ShowTab("cuisines");
                return;
            }

            int    cuisineId = Convert.ToInt32(ddlCourseCuisine.SelectedValue);
            string name      = txtCourseTypeName.Text.Trim();

            if (string.IsNullOrEmpty(name))
            {
                ShowAdminMsg("Course Type Name is required.", false);
                ShowTab("cuisines");
                return;
            }

            try
            {
                string sql = "INSERT INTO CourseType (CuisineID, CourseTypeName) VALUES (@CuisineID, @Name)";
                SqlParameter[] p = {
                    new SqlParameter("@CuisineID", cuisineId),
                    new SqlParameter("@Name",      name)
                };
                DbHelper.ExecuteNonQuery(sql, p);
                txtCourseTypeName.Text = "";
                PopulateDropdowns();
                ShowAdminMsg("Course Type '" + name + "' added successfully!", true);
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error adding course type: " + ex.Message, false);
            }
            ShowTab("cuisines");
        }

        protected void btnAddRecipe_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlRecipeCourseType.SelectedValue))
            {
                ShowAdminMsg("Please select a course type.", false);
                ShowTab("recipes");
                return;
            }

            int    courseTypeId = Convert.ToInt32(ddlRecipeCourseType.SelectedValue);
            string title        = txtRecipeTitle.Text.Trim();
            string desc         = txtRecipeDesc.Text.Trim();
            string ingredients  = txtRecipeIngredients.Text.Trim();
            int dur = 30;
            int.TryParse(txtRecipeDuration.Text, out dur);
            int duration = dur;
            string difficulty   = ddlRecipeDifficulty.SelectedValue;
            string thumb        = txtRecipeThumb.Text.Trim();
            string video        = txtRecipeVideo.Text.Trim();

            if (string.IsNullOrEmpty(title))
            {
                ShowAdminMsg("Recipe Title is required.", false);
                ShowTab("recipes");
                return;
            }

            try
            {
                // If editing existing recipe
                if (!string.IsNullOrEmpty(hfEditRecipeId.Value))
                {
                    int editId = Convert.ToInt32(hfEditRecipeId.Value);
                    // Read existing thumbnail for safe cleanup after replace
                    string oldThumb = null;
                    try
                    {
                        object cur = DbHelper.ExecuteScalar("SELECT Thumbnail FROM Recipe WHERE RecipeID = @RecipeID", new[] { new SqlParameter("@RecipeID", editId) });
                        if (cur != null && cur != DBNull.Value) oldThumb = cur.ToString();
                    }
                    catch { }

                    // Handle uploaded file if provided
                    string newThumb = thumb;
                    if (fuRecipeThumb.HasFile)
                    {
                        string[] allowed = new[] { ".png", ".jpg", ".jpeg", ".webp", ".gif" };
                        string ext = Path.GetExtension(fuRecipeThumb.FileName).ToLowerInvariant();
                        if (Array.IndexOf(allowed, ext) < 0)
                        {
                            ShowAdminMsg("Invalid image type. Allowed: jpg, png, webp, gif.", false);
                            return;
                        }
                        if (fuRecipeThumb.PostedFile.ContentLength > 5 * 1024 * 1024)
                        {
                            ShowAdminMsg("Image too large (max 5MB).", false);
                            return;
                        }
                        string folder = Server.MapPath("~/uploads/recipes/");
                        if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
                        string fileName = Guid.NewGuid().ToString("N") + ext;
                        string fullPath = Path.Combine(folder, fileName);
                        fuRecipeThumb.SaveAs(fullPath);
                        newThumb = "~/uploads/recipes/" + fileName;
                    }

                    string sql = @"UPDATE Recipe SET CourseTypeID=@CourseTypeID, RecipeTitle=@RecipeTitle, Description=@Description, Ingredients=@Ingredients, Duration=@Duration, Difficulty=@Difficulty, Thumbnail=@Thumbnail, VideoURL=@VideoURL WHERE RecipeID=@RecipeID";
                    SqlParameter[] p = {
                        new SqlParameter("@CourseTypeID", courseTypeId),
                        new SqlParameter("@RecipeTitle",  title),
                        new SqlParameter("@Description",  string.IsNullOrEmpty(desc) ? (object)DBNull.Value : desc),
                        new SqlParameter("@Ingredients",  string.IsNullOrEmpty(ingredients) ? (object)DBNull.Value : ingredients),
                        new SqlParameter("@Duration",     duration),
                        new SqlParameter("@Difficulty",   difficulty),
                        new SqlParameter("@Thumbnail",    string.IsNullOrEmpty(newThumb) ? "images/momo_dish.jpg" : newThumb),
                        new SqlParameter("@VideoURL",     string.IsNullOrEmpty(video) ? (object)DBNull.Value : video),
                        new SqlParameter("@RecipeID",     editId)
                    };
                    DbHelper.ExecuteNonQuery(sql, p);
                    hfEditRecipeId.Value = "";
                    btnAddRecipe.Text = "Save Recipe";
                    ShowAdminMsg("Recipe updated successfully.", true);

                    // Delete old thumbnail file if it was in uploads and different from new
                    try
                    {
                        if (!string.IsNullOrEmpty(oldThumb) && !string.Equals(oldThumb, newThumb, StringComparison.OrdinalIgnoreCase) && oldThumb.IndexOf("uploads/recipes", StringComparison.OrdinalIgnoreCase) >= 0)
                        {
                            string oldPath = oldThumb.StartsWith("~") ? Server.MapPath(oldThumb) : Server.MapPath("~/" + oldThumb.TrimStart('/'));
                            if (File.Exists(oldPath)) File.Delete(oldPath);
                        }
                    }
                    catch { /* ignore deletion errors */ }
                }
                else
                {
                    // Handle uploaded file if provided
                    string newThumb = thumb;
                    if (fuRecipeThumb.HasFile)
                    {
                        string[] allowed = new[] { ".png", ".jpg", ".jpeg", ".webp", ".gif" };
                        string ext = Path.GetExtension(fuRecipeThumb.FileName).ToLowerInvariant();
                        if (Array.IndexOf(allowed, ext) < 0)
                        {
                            ShowAdminMsg("Invalid image type. Allowed: jpg, png, webp, gif.", false);
                            return;
                        }
                        if (fuRecipeThumb.PostedFile.ContentLength > 5 * 1024 * 1024)
                        {
                            ShowAdminMsg("Image too large (max 5MB).", false);
                            return;
                        }
                        string folder = Server.MapPath("~/uploads/recipes/");
                        if (!Directory.Exists(folder)) Directory.CreateDirectory(folder);
                        string fileName = Guid.NewGuid().ToString("N") + ext;
                        string fullPath = Path.Combine(folder, fileName);
                        fuRecipeThumb.SaveAs(fullPath);
                        newThumb = "~/uploads/recipes/" + fileName;
                    }

                    // Prevent accidental duplicate records: if a recipe with same title+course exists, update it instead
                    object existsIdObj = null;
                    try
                    {
                        existsIdObj = DbHelper.ExecuteScalar("SELECT RecipeID FROM Recipe WHERE RecipeTitle = @Title AND CourseTypeID = @CourseTypeID",
                            new[] { new SqlParameter("@Title", title), new SqlParameter("@CourseTypeID", courseTypeId) });
                    }
                    catch { existsIdObj = null; }

                    int existingId;
                    if (existsIdObj != null && int.TryParse(existsIdObj.ToString(), out existingId))
                    {
                        // perform update instead of insert to avoid duplicates
                        string updateSql = @"UPDATE Recipe SET CourseTypeID=@CourseTypeID, RecipeTitle=@RecipeTitle, Description=@Description, Ingredients=@Ingredients, Duration=@Duration, Difficulty=@Difficulty, Thumbnail=@Thumbnail, VideoURL=@VideoURL WHERE RecipeID=@RecipeID";
                        SqlParameter[] up = {
                            new SqlParameter("@CourseTypeID", courseTypeId),
                            new SqlParameter("@RecipeTitle",  title),
                            new SqlParameter("@Description",  string.IsNullOrEmpty(desc) ? (object)DBNull.Value : desc),
                            new SqlParameter("@Ingredients",  string.IsNullOrEmpty(ingredients) ? (object)DBNull.Value : ingredients),
                            new SqlParameter("@Duration",     duration),
                            new SqlParameter("@Difficulty",   difficulty),
                            new SqlParameter("@Thumbnail",    string.IsNullOrEmpty(newThumb) ? "images/momo_dish.jpg" : newThumb),
                            new SqlParameter("@VideoURL",     string.IsNullOrEmpty(video) ? (object)DBNull.Value : video),
                            new SqlParameter("@RecipeID",     existingId)
                        };
                        DbHelper.ExecuteNonQuery(updateSql, up);
                        ShowAdminMsg("Existing recipe updated instead of creating duplicate (RecipeID=" + existingId + ").", true);
                    }
                    else
                    {
                        string sql = @"INSERT INTO Recipe (CourseTypeID, RecipeTitle, Description, Ingredients, Duration, Difficulty, Thumbnail, VideoURL, CreatedAt)
                                       VALUES (@CourseTypeID, @RecipeTitle, @Description, @Ingredients, @Duration, @Difficulty, @Thumbnail, @VideoURL, GETDATE())";

                        SqlParameter[] p = {
                            new SqlParameter("@CourseTypeID", courseTypeId),
                            new SqlParameter("@RecipeTitle",  title),
                            new SqlParameter("@Description",  string.IsNullOrEmpty(desc) ? (object)DBNull.Value : desc),
                            new SqlParameter("@Ingredients",  string.IsNullOrEmpty(ingredients) ? (object)DBNull.Value : ingredients),
                            new SqlParameter("@Duration",     duration),
                            new SqlParameter("@Difficulty",   difficulty),
                            new SqlParameter("@Thumbnail",    string.IsNullOrEmpty(newThumb) ? "images/momo_dish.jpg" : newThumb),
                            new SqlParameter("@VideoURL",     string.IsNullOrEmpty(video) ? (object)DBNull.Value : video)
                        };

                        DbHelper.ExecuteNonQuery(sql, p);
                        ShowAdminMsg("Recipe '" + title + "' added successfully!", true);
                    }
                    // no-op patch: context update only
                    txtRecipeTitle.Text       = "";
                    txtRecipeDesc.Text        = "";
                    txtRecipeIngredients.Text = "";
                    txtRecipeDuration.Text    = "";
                    txtRecipeThumb.Text       = "";
                    txtRecipeVideo.Text       = "";
                    ShowAdminMsg("Recipe '" + title + "' added successfully!", true);
                }
                LoadOverviewMetrics();
                PopulateDropdowns();
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error adding/updating recipe: " + ex.Message, false);
            }
            ShowTab("recipes");
        }

        protected void btnAddStep_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlStepRecipe.SelectedValue))
            {
                ShowAdminMsg("Please select a recipe.", false);
                ShowTab("recipes");
                return;
            }

            int    recipeId    = Convert.ToInt32(ddlStepRecipe.SelectedValue);
            int sn = 1;
            int.TryParse(txtStepNumber.Text, out sn);
            int stepNum = sn;
            string instruction = txtStepInstruction.Text.Trim();

            if (string.IsNullOrEmpty(instruction))
            {
                ShowAdminMsg("Step instruction is required.", false);
                ShowTab("recipes");
                return;
            }

            try
            {
                // If editing an existing step update, otherwise insert
                if (!string.IsNullOrEmpty(hfEditStepId.Value))
                {
                    int editStepId = Convert.ToInt32(hfEditStepId.Value);
                    string sql = "UPDATE RecipeStep SET StepNumber=@StepNumber, Instruction=@Instruction WHERE StepID=@StepID";
                    SqlParameter[] p = {
                        new SqlParameter("@StepNumber",  stepNum),
                        new SqlParameter("@Instruction", instruction),
                        new SqlParameter("@StepID", editStepId)
                    };
                    DbHelper.ExecuteNonQuery(sql, p);
                    hfEditStepId.Value = "";
                    try { btnAddStep.Text = "Add Step"; } catch { }
                    ShowAdminMsg("Recipe step updated.", true);
                }
                else
                {
                    string sql = "INSERT INTO RecipeStep (RecipeID, StepNumber, Instruction) VALUES (@RecipeID, @StepNumber, @Instruction)";
                    SqlParameter[] p = {
                        new SqlParameter("@RecipeID",    recipeId),
                        new SqlParameter("@StepNumber",  stepNum),
                        new SqlParameter("@Instruction", instruction)
                    };
                    DbHelper.ExecuteNonQuery(sql, p);
                    ShowAdminMsg("Recipe Step " + stepNum + " added successfully!", true);
                }
                txtStepInstruction.Text = "";
                txtStepNumber.Text      = "";
                // Refresh steps list
                BindRecipeSteps(recipeId);
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error adding step: " + ex.Message, false);
            }
            ShowTab("recipes");
        }

        protected void btnAddQuiz_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlQuizRecipe.SelectedValue))
            {
                ShowAdminMsg("Please select a recipe.", false);
                ShowTab("quizzes");
                return;
            }

            int    recipeId = Convert.ToInt32(ddlQuizRecipe.SelectedValue);
            string title    = txtQuizTitle.Text.Trim();
            int ps = 70;
            int.TryParse(txtPassingScore.Text, out ps);
            int passing = ps;

            if (string.IsNullOrEmpty(title))
            {
                ShowAdminMsg("Quiz title is required.", false);
                ShowTab("quizzes");
                return;
            }

            // Validate passing score range
            if (passing < 1 || passing > 100)
            {
                ShowAdminMsg("Passing score must be between 1 and 100.", false);
                ShowTab("quizzes");
                return;
            }

            try
            {
                // Prevent duplicate quiz for same recipe
                object existing = DbHelper.ExecuteScalar(
                    "SELECT COUNT(*) FROM Quiz WHERE RecipeID = @RecipeID",
                    new[] { new SqlParameter("@RecipeID", recipeId) });

                if (existing != null && Convert.ToInt32(existing) > 0)
                {
                    ShowAdminMsg("A quiz already exists for the selected recipe. Please add questions to the existing quiz instead.", false);
                    ShowTab("quizzes");
                    return;
                }

                string sql = "INSERT INTO Quiz (RecipeID, QuizTitle, PassingScore) VALUES (@RecipeID, @QuizTitle, @PassingScore)";
                SqlParameter[] p = {
                    new SqlParameter("@RecipeID",     recipeId),
                    new SqlParameter("@QuizTitle",    title),
                    new SqlParameter("@PassingScore", passing)
                };
                DbHelper.ExecuteNonQuery(sql, p);
                txtQuizTitle.Text    = "";
                txtPassingScore.Text = "70";
                LoadOverviewMetrics();
                PopulateDropdowns();
                ShowAdminMsg("Quiz '" + title + "' created successfully!", true);
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error creating quiz: " + ex.Message, false);
            }
            ShowTab("quizzes");
        }

        protected void btnAddQuestion_Click(object sender, EventArgs e)
        {
            if (string.IsNullOrEmpty(ddlQuestionQuiz.SelectedValue))
            {
                ShowAdminMsg("Please select a quiz.", false);
                ShowTab("quizzes");
                return;
            }

            int    quizId   = Convert.ToInt32(ddlQuestionQuiz.SelectedValue);
            string question = txtQuestionText.Text.Trim();
            string optA     = txtOptionA.Text.Trim();
            string optB     = txtOptionB.Text.Trim();
            string optC     = txtOptionC.Text.Trim();
            string optD     = txtOptionD.Text.Trim();
            string correct  = ddlCorrectAns.SelectedValue;

            if (string.IsNullOrEmpty(question) || string.IsNullOrEmpty(optA) || string.IsNullOrEmpty(optB))
            {
                ShowAdminMsg("Question text and at least Option A & Option B are required.", false);
                ShowTab("quizzes");
                return;
            }

            // If a specific answer is selected that has no text, reject
            if ((correct == "C" && string.IsNullOrEmpty(optC)) ||
                (correct == "D" && string.IsNullOrEmpty(optD)))
            {
                ShowAdminMsg("The selected correct answer option has no text. Please fill it in.", false);
                ShowTab("quizzes");
                return;
            }

            try
            {
                string sql = @"INSERT INTO QuizQuestion (QuizID, Question, OptionA, OptionB, OptionC, OptionD, CorrectAnswer)
                               VALUES (@QuizID, @Question, @OptionA, @OptionB, @OptionC, @OptionD, @CorrectAnswer)";

                SqlParameter[] p = {
                    new SqlParameter("@QuizID",        quizId),
                    new SqlParameter("@Question",      question),
                    new SqlParameter("@OptionA",       optA),
                    new SqlParameter("@OptionB",       optB),
                    new SqlParameter("@OptionC",       string.IsNullOrEmpty(optC) ? (object)DBNull.Value : optC),
                    new SqlParameter("@OptionD",       string.IsNullOrEmpty(optD) ? (object)DBNull.Value : optD),
                    new SqlParameter("@CorrectAnswer", correct)
                };

                DbHelper.ExecuteNonQuery(sql, p);
                txtQuestionText.Text = "";
                txtOptionA.Text      = "";
                txtOptionB.Text      = "";
                txtOptionC.Text      = "";
                txtOptionD.Text      = "";
                ShowAdminMsg("Quiz Question added successfully!", true);
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error adding question: " + ex.Message, false);
            }
            ShowTab("quizzes");
        }
    }
}
