using System;
using System.Web.UI;

namespace KneadLMS
{
    public partial class About : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
        }
    }

    // DbHelper moved here to ensure it's compiled into the web application assembly
    public static class DbHelper
    {
        public static string GetConnectionString()
        {
            var cs = System.Configuration.ConfigurationManager.ConnectionStrings["KneadDB"];
            if (cs != null && !string.IsNullOrEmpty(cs.ConnectionString))
            {
                return cs.ConnectionString;
            }
            return @"Data Source=localhost;Initial Catalog=KneadDB;Integrated Security=True;";
        }

        public static System.Data.SqlClient.SqlConnection GetConnection()
        {
            return new System.Data.SqlClient.SqlConnection(GetConnectionString());
        }

        public static System.Data.DataTable ExecuteQuery(string query, System.Data.SqlClient.SqlParameter[] parameters = null)
        {
            System.Data.DataTable dt = new System.Data.DataTable();
            using (var conn = GetConnection())
            using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
            {
                if (parameters != null)
                {
                    cmd.Parameters.AddRange(parameters);
                }
                using (var da = new System.Data.SqlClient.SqlDataAdapter(cmd))
                {
                    da.Fill(dt);
                }
            }
            return dt;
        }

        public static int ExecuteNonQuery(string query, System.Data.SqlClient.SqlParameter[] parameters = null)
        {
            using (var conn = GetConnection())
            {
                conn.Open();
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    return cmd.ExecuteNonQuery();
                }
            }
        }

        public static object ExecuteScalar(string query, System.Data.SqlClient.SqlParameter[] parameters = null)
        {
            using (var conn = GetConnection())
            {
                conn.Open();
                using (var cmd = new System.Data.SqlClient.SqlCommand(query, conn))
                {
                    if (parameters != null)
                    {
                        cmd.Parameters.AddRange(parameters);
                    }
                    return cmd.ExecuteScalar();
                }
            }
        }

        public static string HashPassword(string rawPassword)
        {
            if (string.IsNullOrEmpty(rawPassword)) return string.Empty;
            using (var sha256 = System.Security.Cryptography.SHA256.Create())
            {
                byte[] bytes = sha256.ComputeHash(System.Text.Encoding.UTF8.GetBytes(rawPassword));
                var builder = new System.Text.StringBuilder();
                for (int i = 0; i < bytes.Length; i++)
                {
                    builder.Append(bytes[i].ToString("x2"));
                }
                return builder.ToString();
            }
        }

        public static bool VerifyPassword(string inputPassword, string storedHash)
        {
            if (string.IsNullOrEmpty(storedHash)) return false;
            if (inputPassword == storedHash) return true;
            string hashedInput = HashPassword(inputPassword);
            return string.Equals(hashedInput, storedHash, StringComparison.OrdinalIgnoreCase);
        }
    }
}
