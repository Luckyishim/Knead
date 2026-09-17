using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace KneadLMS
{
    public partial class Register : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] != null)
            {
                Response.Redirect("UserDashboard.aspx");
            }
        }

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            string fullName = txtFullName.Text.Trim();
            string email = txtEmail.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email) || string.IsNullOrEmpty(password))
            {
                ShowError("All fields are required.");
                return;
            }

            if (password.Length < 6)
            {
                ShowError("Password must be at least 6 characters long.");
                return;
            }

            try
            {
                string checkSql = "SELECT COUNT(*) FROM Users WHERE Email = @Email";
                SqlParameter[] checkParams = { new SqlParameter("@Email", email) };
                int existing = Convert.ToInt32(DbHelper.ExecuteScalar(checkSql, checkParams));

                if (existing > 0)
                {
                    ShowError("An account with this email address already exists.");
                    return;
                }

                string pwdHash = DbHelper.HashPassword(password);
                string insertSql = @"INSERT INTO Users (FullName, Email, PasswordHash, Role, CreatedAt) 
                                     OUTPUT INSERTED.UserID 
                                     VALUES (@FullName, @Email, @PasswordHash, 'Member', GETDATE())";

                SqlParameter[] insertParams = {
                    new SqlParameter("@FullName", fullName),
                    new SqlParameter("@Email", email),
                    new SqlParameter("@PasswordHash", pwdHash)
                };

                int newUserId = Convert.ToInt32(DbHelper.ExecuteScalar(insertSql, insertParams));

                Session["UserID"] = newUserId;
                Session["FullName"] = fullName;
                Session["Email"] = email;
                Session["Role"] = "Member";

                Response.Redirect("UserDashboard.aspx");
            }
            catch (Exception ex)
            {
                ShowError("Registration error: " + ex.Message);
            }
        }

        private void ShowError(string msg)
        {
            pnlError.Visible = true;
            litErrorMessage.Text = Server.HtmlEncode(msg);
        }
    }
}
