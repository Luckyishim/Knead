using System;
using System.Web.UI;

namespace KneadLMS
{
    public partial class ProfileMaster : MasterPage
    {
        protected string GetBackUrl()
        {
            Uri referrer = Request.UrlReferrer;

            if (referrer != null && referrer.Host.Equals(Request.Url.Host, StringComparison.OrdinalIgnoreCase))
            {
                string refPath = referrer.AbsolutePath;
                string currentPath = Request.Url.AbsolutePath;

                // Internal portal pages and authentication pages that shouldn't trap the user
                bool isProfileOrAuthPage =
                    refPath.EndsWith("/UserDashboard.aspx", StringComparison.OrdinalIgnoreCase) ||
                    refPath.EndsWith("/MyProgress.aspx", StringComparison.OrdinalIgnoreCase) ||
                    refPath.EndsWith("/SavedRecipes.aspx", StringComparison.OrdinalIgnoreCase) ||
                    refPath.EndsWith("/QuizHistory.aspx", StringComparison.OrdinalIgnoreCase) ||
                    refPath.EndsWith("/AccountSettings.aspx", StringComparison.OrdinalIgnoreCase) ||
                    refPath.EndsWith("/AdminPanel.aspx", StringComparison.OrdinalIgnoreCase) ||
                    refPath.EndsWith("/Login.aspx", StringComparison.OrdinalIgnoreCase) ||
                    refPath.EndsWith("/Register.aspx", StringComparison.OrdinalIgnoreCase) ||
                    refPath.EndsWith("/Logout.aspx", StringComparison.OrdinalIgnoreCase);

                // If user came from a public main page (e.g., Default, ItemList, RecipeDetail, Quizzes, Forums, About), return there
                if (!isProfileOrAuthPage && !refPath.Equals(currentPath, StringComparison.OrdinalIgnoreCase))
                {
                    return ResolveUrl(referrer.PathAndQuery);
                }
            }

            // Always fall back to Home page
            return ResolveUrl("~/Default.aspx");
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }
    }
}
