using System;
using System.Data;
using System.Web.UI;

namespace KneadLMS
{
    public partial class Quizzes : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadQuizzes();
            }
        }

        private void LoadQuizzes()
        {
            try
            {
                string sql = @"SELECT q.QuizID, q.QuizTitle, q.PassingScore, r.RecipeTitle, r.Thumbnail, c.CuisineName 
                               FROM Quiz q
                               INNER JOIN Recipe r ON q.RecipeID = r.RecipeID
                               INNER JOIN CourseType ct ON r.CourseTypeID = ct.CourseTypeID
                               INNER JOIN Cuisine c ON ct.CuisineID = c.CuisineID
                               ORDER BY q.QuizID DESC";

                DataTable dt = DbHelper.ExecuteQuery(sql);
                if (dt.Rows.Count > 0)
                {
                    rptQuizzes.DataSource = dt;
                    rptQuizzes.DataBind();
                    pnlNoQuizzes.Visible = false;
                }
                else
                {
                    pnlNoQuizzes.Visible = true;
                }
            }
            catch
            {
                pnlNoQuizzes.Visible = true;
            }
        }
    }
}
