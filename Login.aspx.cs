using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace KneadLMS
{
    public partial class Login : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
            {
                Response.Redirect("UserDashboard.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ShowError("Please enter both email and password.");
                return;
            }

            try
            {
                string sql = "SELECT UserID, FullName, Email, PasswordHash, Role FROM Users WHERE Email = @Email";
                SqlParameter[] parameters = { new SqlParameter("@Email", email) };

                DataTable dt = DbHelper.ExecuteQuery(sql, parameters);
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    string storedHash = row["PasswordHash"].ToString();

                    if (DbHelper.VerifyPassword(password, storedHash))
                    {
                        Session["UserID"] = Convert.ToInt32(row["UserID"]);
                        Session["FullName"] = row["FullName"].ToString();
                        Session["Email"] = row["Email"].ToString();
                        Session["Role"] = row["Role"].ToString();

                        if (string.Equals(row["Role"].ToString(), "Admin", StringComparison.OrdinalIgnoreCase))
                        {
                            Response.Redirect("AdminPanel.aspx");
                        }
                        else
                        {
                            Response.Redirect("UserDashboard.aspx");
                        }
                    }
                    else
                    {
                        ShowError("Invalid email or password.");
                    }
                }
                else
                {
                    ShowError("Invalid email or password.");
                }
            }
            catch (Exception ex)
            {
                ShowError("Database connection error: " + ex.Message);
            }
        }

        private void ShowError(string msg)
        {
            pnlError.Visible = true;
            litErrorMessage.Text = Server.HtmlEncode(msg);
        }
    }
}
