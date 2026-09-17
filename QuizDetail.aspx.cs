using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace KneadLMS
{
    public partial class QuizDetail : Page
    {
        private int quizId = 0;
        private int passingScore = 70;
        private int recipeId = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["quizId"] != null && int.TryParse(Request.QueryString["quizId"], out quizId))
            {
                ViewState["QuizID"] = quizId;
            }
            else
            {
                quizId = ViewState["QuizID"] != null ? Convert.ToInt32(ViewState["QuizID"]) : 1;
            }

            if (!IsPostBack)
            {
                LoadQuizInfo();
                LoadQuestions();
            }
        }

        private void LoadQuizInfo()
        {
            try
            {
                string sql = "SELECT QuizTitle, PassingScore, RecipeID FROM Quiz WHERE QuizID = @QuizID";
                SqlParameter[] p = { new SqlParameter("@QuizID", quizId) };
                DataTable dt = DbHelper.ExecuteQuery(sql, p);

                if (dt.Rows.Count > 0)
                {
                    litQuizTitle.Text = Server.HtmlEncode(dt.Rows[0]["QuizTitle"].ToString());
                    passingScore = Convert.ToInt32(dt.Rows[0]["PassingScore"]);
                    litPassingScore.Text = passingScore.ToString();
                    ViewState["PassingScore"] = passingScore;
                    ViewState["RecipeID"] = dt.Rows[0]["RecipeID"];
                }
            }
            catch
            {
            }
        }

        private void LoadQuestions()
        {
            try
            {
                string sql = "SELECT QuestionID, Question, OptionA, OptionB, OptionC, OptionD, CorrectAnswer FROM QuizQuestion WHERE QuizID = @QuizID";
                SqlParameter[] p = { new SqlParameter("@QuizID", quizId) };
                DataTable dt = DbHelper.ExecuteQuery(sql, p);

                rptQuestions.DataSource = dt;
                rptQuestions.DataBind();
            }
            catch
            {
            }
        }

        protected void rptQuestions_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView drv = (DataRowView)e.Item.DataItem;
                RadioButtonList rbl = (RadioButtonList)e.Item.FindControl("rblOptions");

                if (rbl != null)
                {
                    rbl.Items.Add(new ListItem(" A. " + drv["OptionA"].ToString(), "A"));
                    rbl.Items.Add(new ListItem(" B. " + drv["OptionB"].ToString(), "B"));
                    rbl.Items.Add(new ListItem(" C. " + drv["OptionC"].ToString(), "C"));
                    rbl.Items.Add(new ListItem(" D. " + drv["OptionD"].ToString(), "D"));
                }
            }
        }

        protected void btnSubmitQuiz_Click(object sender, EventArgs e)
        {
            int totalQuestions = rptQuestions.Items.Count;
            if (totalQuestions == 0) return;

            int correctCount = 0;

            try
            {
                foreach (RepeaterItem item in rptQuestions.Items)
                {
                    HiddenField hfId = (HiddenField)item.FindControl("hfQuestionID");
                    RadioButtonList rbl = (RadioButtonList)item.FindControl("rblOptions");

                    if (hfId != null && rbl != null && !string.IsNullOrEmpty(rbl.SelectedValue))
                    {
                        int qId = Convert.ToInt32(hfId.Value);
                        string selectedAns = rbl.SelectedValue;

                        string sql = "SELECT CorrectAnswer FROM QuizQuestion WHERE QuestionID = @QuestionID";
                        SqlParameter[] p = { new SqlParameter("@QuestionID", qId) };
                        object correctAnsObj = DbHelper.ExecuteScalar(sql, p);

                        if (correctAnsObj != null && string.Equals(correctAnsObj.ToString().Trim(), selectedAns, StringComparison.OrdinalIgnoreCase))
                        {
                            correctCount++;
                        }
                    }
                }

                int scorePercent = (int)Math.Round((double)correctCount / totalQuestions * 100);
                int reqPassing = ViewState["PassingScore"] != null ? Convert.ToInt32(ViewState["PassingScore"]) : 70;
                bool passed = scorePercent >= reqPassing;

                // Require login to submit — never fall back to another user's ID
                if (Session["UserID"] == null)
                {
                    Response.Redirect("Login.aspx?returnUrl=QuizDetail.aspx?quizId=" + quizId);
                    return;
                }
                int userId = Convert.ToInt32(Session["UserID"]);

                string attSql = @"INSERT INTO QuizAttempt (QuizID, UserID, Score, Passed, AttemptDate) 
                                 VALUES (@QuizID, @UserID, @Score, @Passed, GETDATE())";
                SqlParameter[] attParams = {
                    new SqlParameter("@QuizID", quizId),
                    new SqlParameter("@UserID", userId),
                    new SqlParameter("@Score", scorePercent),
                    new SqlParameter("@Passed", passed)
                };
                DbHelper.ExecuteNonQuery(attSql, attParams);

                // Update UserProgress if passed
                if (passed && ViewState["RecipeID"] != null)
                {
                    int recId = Convert.ToInt32(ViewState["RecipeID"]);
                    string upSql = @"IF EXISTS (SELECT 1 FROM UserProgress WHERE UserID = @UserID AND RecipeID = @RecipeID)
                                     UPDATE UserProgress SET IsCompleted = 1, CompletedDate = GETDATE() WHERE UserID = @UserID AND RecipeID = @RecipeID
                                     ELSE
                                     INSERT INTO UserProgress (UserID, RecipeID, IsCompleted, CompletedDate) VALUES (@UserID, @RecipeID, 1, GETDATE())";
                    SqlParameter[] upParams = {
                        new SqlParameter("@UserID", userId),
                        new SqlParameter("@RecipeID", recId)
                    };
                    DbHelper.ExecuteNonQuery(upSql, upParams);
                }

                pnlQuestions.Visible = false;
                pnlResult.Visible = true;

                if (passed)
                {
                    litResultHeadline.Text = "🎉 Congratulations! You Passed!";
                    litResultScoreText.Text = string.Format("You scored {0}% ({1}/{2} correct answers). Required score was {3}%.", scorePercent, correctCount, totalQuestions, reqPassing);
                    pnlResult.Style["background-color"] = "#ECFDF5";
                }
                else
                {
                    litResultHeadline.Text = "❌ Keep practicing!";
                    litResultScoreText.Text = string.Format("You scored {0}% ({1}/{2} correct answers). You need {3}% to pass.", scorePercent, correctCount, totalQuestions, reqPassing);
                    pnlResult.Style["background-color"] = "#FEF2F2";
                }
            }
            catch (Exception ex)
            {
                pnlResult.Visible = true;
                litResultHeadline.Text = "Quiz Submission Error";
                litResultScoreText.Text = ex.Message;
            }
        }
    }
}
