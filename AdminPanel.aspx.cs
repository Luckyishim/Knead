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
            }
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
                ShowAdminMsg("Error loading metrics: " + ex.Message, false);
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
                ShowAdminMsg("Error loading users table: " + ex.Message, false);
            }
        }

        private void PopulateDropdowns()
        {
            try
            {
                DataTable dtC = DbHelper.ExecuteQuery(
                    "SELECT CuisineID, CuisineName FROM Cuisine ORDER BY CuisineName");
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
                ShowAdminMsg("Error loading dropdowns: " + ex.Message, false);
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
            ShowTab("cuisines");
        }

        protected void btnNavRecipes_Click(object sender, EventArgs e)
        {
            PopulateDropdowns();
            ShowTab("recipes");
        }

        protected void btnNavQuizzes_Click(object sender, EventArgs e)
        {
            PopulateDropdowns();
            ShowTab("quizzes");
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
                DataTable dt = DbHelper.ExecuteQuery(
                    @"SELECT c.CuisineID, c.CuisineName, c.Description, 
                             (SELECT COUNT(*) FROM CourseType ct WHERE ct.CuisineID = c.CuisineID) AS CourseCount
                      FROM Cuisine c ORDER BY c.CuisineID DESC");
                gvAdminCuisines.DataSource = dt;
                gvAdminCuisines.DataBind();
            }
            catch { }
        }

        private void LoadRecipesTable()
        {
            try
            {
                DataTable dt = DbHelper.ExecuteQuery(
                    @"SELECT r.RecipeID, r.RecipeTitle, r.Duration, r.Difficulty, c.CuisineName, ct.CourseTypeName
                      FROM Recipe r
                      INNER JOIN CourseType ct ON r.CourseTypeID = ct.CourseTypeID
                      INNER JOIN Cuisine c ON ct.CuisineID = c.CuisineID
                      ORDER BY r.RecipeID DESC");
                gvAdminRecipes.DataSource = dt;
                gvAdminRecipes.DataBind();
            }
            catch { }
        }

        private void LoadQuizzesTable()
        {
            try
            {
                DataTable dt = DbHelper.ExecuteQuery(
                    @"SELECT q.QuizID, q.QuizTitle, q.PassingScore, r.RecipeTitle,
                             (SELECT COUNT(*) FROM QuizQuestion qq WHERE qq.QuizID = q.QuizID) AS QuestionCount
                      FROM Quiz q
                      INNER JOIN Recipe r ON q.RecipeID = r.RecipeID
                      ORDER BY q.QuizID DESC");
                gvAdminQuizzes.DataSource = dt;
                gvAdminQuizzes.DataBind();
            }
            catch { }
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
                LoadOverviewMetrics();
                PopulateDropdowns();
                ShowAdminMsg("Cuisine '" + name + "' added successfully!", true);
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
                string sql = @"INSERT INTO Recipe (CourseTypeID, RecipeTitle, Description, Ingredients, Duration, Difficulty, Thumbnail, VideoURL, CreatedAt)
                               VALUES (@CourseTypeID, @RecipeTitle, @Description, @Ingredients, @Duration, @Difficulty, @Thumbnail, @VideoURL, GETDATE())";

                SqlParameter[] p = {
                    new SqlParameter("@CourseTypeID", courseTypeId),
                    new SqlParameter("@RecipeTitle",  title),
                    new SqlParameter("@Description",  string.IsNullOrEmpty(desc) ? (object)DBNull.Value : desc),
                    new SqlParameter("@Ingredients",  string.IsNullOrEmpty(ingredients) ? (object)DBNull.Value : ingredients),
                    new SqlParameter("@Duration",     duration),
                    new SqlParameter("@Difficulty",   difficulty),
                    new SqlParameter("@Thumbnail",    string.IsNullOrEmpty(thumb) ? "images/momo_dish.jpg" : thumb),
                    new SqlParameter("@VideoURL",     string.IsNullOrEmpty(video) ? (object)DBNull.Value : video)
                };

                DbHelper.ExecuteNonQuery(sql, p);
                txtRecipeTitle.Text       = "";
                txtRecipeDesc.Text        = "";
                txtRecipeIngredients.Text = "";
                txtRecipeDuration.Text    = "";
                txtRecipeThumb.Text       = "";
                txtRecipeVideo.Text       = "";
                LoadOverviewMetrics();
                PopulateDropdowns();
                ShowAdminMsg("Recipe '" + title + "' added successfully!", true);
            }
            catch (Exception ex)
            {
                ShowAdminMsg("Error adding recipe: " + ex.Message, false);
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
                string sql = "INSERT INTO RecipeStep (RecipeID, StepNumber, Instruction) VALUES (@RecipeID, @StepNumber, @Instruction)";
                SqlParameter[] p = {
                    new SqlParameter("@RecipeID",    recipeId),
                    new SqlParameter("@StepNumber",  stepNum),
                    new SqlParameter("@Instruction", instruction)
                };
                DbHelper.ExecuteNonQuery(sql, p);
                txtStepInstruction.Text = "";
                txtStepNumber.Text      = "";
                ShowAdminMsg("Recipe Step " + stepNum + " added successfully!", true);
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
