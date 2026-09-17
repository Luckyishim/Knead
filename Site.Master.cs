using System;
using System.Web;
using System.Web.UI;

namespace KneadLMS
{
    public partial class SiteMaster : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                CheckUserSession();
            }
        }

        private void CheckUserSession()
        {
            if (Session["UserID"] != null)
            {
                pnlGuest.Visible = false;
                pnlUser.Visible = true;

                string fullName = Session["FullName"] != null ? Session["FullName"].ToString() : "Member";
                string role = Session["Role"] != null ? Session["Role"].ToString() : "Member";

                litUserName.Text = Server.HtmlEncode(fullName);
                
                string[] nameParts = fullName.Split(' ');
                string initials = nameParts[0].Substring(0, 1).ToUpper();
                if (nameParts.Length > 1 && !string.IsNullOrEmpty(nameParts[nameParts.Length - 1]))
                {
                    initials += nameParts[nameParts.Length - 1].Substring(0, 1).ToUpper();
                }
                litUserInitials.Text = initials;

                if (string.Equals(role, "Admin", StringComparison.OrdinalIgnoreCase))
                {
                    lnkUserProfile.NavigateUrl = "AdminPanel.aspx";
                }
                else
                {
                    lnkUserProfile.NavigateUrl = "UserDashboard.aspx";
                }
            }
            else
            {
                pnlGuest.Visible = true;
                pnlUser.Visible = false;
            }
        }

        public string GetNavActiveClass(string pageName)
        {
            string currentPath = Request.Url.AbsolutePath;
            if (currentPath.EndsWith(pageName, StringComparison.OrdinalIgnoreCase))
            {
                return "active";
            }
            if (pageName == "Default.aspx" && (currentPath.EndsWith("/") || currentPath.EndsWith("Default.aspx") || currentPath.EndsWith("Home.aspx")))
            {
                return "active";
            }
            return "";
        }
    }
}
