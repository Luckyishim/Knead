using System;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace KneadLMS
{
    public partial class AccountSettings : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserID"] == null)
            {
                Response.Redirect("Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserInfo();
            }
        }

        private void LoadUserInfo()
        {
            int userId = Convert.ToInt32(Session["UserID"]);

            try
            {
                string sql = "SELECT FullName, Email, Role FROM Users WHERE UserID = @UserID";
                SqlParameter[] p = { new SqlParameter("@UserID", userId) };
                DataTable dt = DbHelper.ExecuteQuery(sql, p);

                if (dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    txtFullName.Text = r["FullName"].ToString();
                    txtEmail.Text = r["Email"].ToString();
                }
            }
            catch
            {
            }
        }

        protected void btnSaveSettings_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserID"]);
            string newName = txtFullName.Text.Trim();
            string newEmail = txtEmail.Text.Trim();
            string newPassword = txtNewPassword.Text;

            if (string.IsNullOrEmpty(newName) || string.IsNullOrEmpty(newEmail))
            {
                ShowMessage("Name and Email are required.", false);
                return;
            }

            try
            {
                if (!string.IsNullOrEmpty(newPassword))
                {
                    if (newPassword.Length < 6)
                    {
                        ShowMessage("Password must be at least 6 characters long.", false);
                        return;
                    }

                    string newHash = DbHelper.HashPassword(newPassword);
                    string sql = "UPDATE Users SET FullName = @FullName, Email = @Email, PasswordHash = @PasswordHash WHERE UserID = @UserID";
                    SqlParameter[] p = {
                        new SqlParameter("@FullName", newName),
                        new SqlParameter("@Email", newEmail),
                        new SqlParameter("@PasswordHash", newHash),
                        new SqlParameter("@UserID", userId)
                    };
                    DbHelper.ExecuteNonQuery(sql, p);
                }
                else
                {
                    string sql = "UPDATE Users SET FullName = @FullName, Email = @Email WHERE UserID = @UserID";
                    SqlParameter[] p = {
                        new SqlParameter("@FullName", newName),
                        new SqlParameter("@Email", newEmail),
                        new SqlParameter("@UserID", userId)
                    };
                    DbHelper.ExecuteNonQuery(sql, p);
                }

                Session["FullName"] = newName;
                Session["Email"] = newEmail;

                ShowMessage("Account settings updated successfully!", true);
                LoadUserInfo();
            }
            catch (Exception ex)
            {
                ShowMessage("Error updating account: " + ex.Message, false);
            }
        }

        private void ShowMessage(string msg, bool isSuccess)
        {
            pnlSettingsMsg.Visible = true;
            litSettingsMsg.Text = Server.HtmlEncode(msg);
            if (isSuccess)
            {
                pnlSettingsMsg.Style["background-color"] = "#D1FAE5";
                pnlSettingsMsg.Style["color"] = "#065F46";
            }
            else
            {
                pnlSettingsMsg.Style["background-color"] = "#FEE2E2";
                pnlSettingsMsg.Style["color"] = "#991B1B";
            }
        }
    }
}
