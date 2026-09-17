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
                string currentPath = Request.Url.AbsolutePath;
                if (!referrer.AbsolutePath.Equals(currentPath, StringComparison.OrdinalIgnoreCase))
                {
                    return ResolveUrl(referrer.PathAndQuery);
                }
            }

            return ResolveUrl("~/Default.aspx");
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }
    }
}
