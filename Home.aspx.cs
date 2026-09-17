using System;
using System.Web.UI;

namespace KneadLMS
{
    public partial class HomePage : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Redirect("Default.aspx");
        }
    }
}
