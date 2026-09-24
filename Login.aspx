<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="KneadLMS.Login" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Login - knead. Culinary LMS</title>
  <link rel="stylesheet" href="styles/login.css" />
</head>
<body style="background-color: var(--bg-primary); display: flex; flex-direction: column; justify-content: center; align-items: center; min-height: 100vh; margin: 0; padding: 20px;">

  <form id="formLogin" runat="server" style="width: 100%; max-width: 440px;">
    
    <div style="text-align: center; margin-bottom: 32px;">
      <a href="Default.aspx" class="logo" style="justify-content: center; margin-bottom: 16px;">
        <div class="logo-icon" style="width: 48px; height: 48px; font-size: 24px;">k.</div>
        <div class="logo-text">
          <h4 style="font-size: 28px;">knead<span>.</span></h4>
          <p>CULINARY LMS</p>
        </div>
      </a>
      <h2 style="font-size: 24px; font-weight: 800; color: var(--text-dark);">Welcome back</h2>
      <p style="font-size: 14px; color: var(--text-muted); margin-top: 4px;">Sign in to continue your culinary journey</p>
    </div>

    <div style="background-color: #FFFFFF; border: 1px solid var(--border-light); border-radius: 20px; padding: 32px; box-shadow: var(--shadow-md);">
      
      <asp:Panel ID="pnlError" runat="server" Visible="false" Style="margin-bottom: 16px; padding: 12px; border-radius: 8px; background-color: #FEE2E2; border: 1px solid #FCA5A5; color: #991B1B; font-size: 14px;">
        <asp:Literal ID="litErrorMessage" runat="server"></asp:Literal>
      </asp:Panel>

      <div class="form-group" style="margin-bottom: 16px;">
        <label style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 6px;">Email Address</label>
        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="chef@example.com" Text="student@knead.com" Required="true" Style="width: 100%; box-sizing: border-box; padding: 10px; border-radius: 8px; border: 1px solid var(--border-medium);"></asp:TextBox>
      </div>

      <div class="form-group" style="margin-bottom: 20px;">
        <label style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 6px;">Password</label>
        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter your password" Text="password123" Required="true" Style="width: 100%; box-sizing: border-box; padding: 10px; border-radius: 8px; border: 1px solid var(--border-medium);"></asp:TextBox>
      </div>

      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; font-size: 13px;">
        <label style="display: flex; align-items: center; gap: 6px; cursor: pointer; color: var(--text-muted);">
          <input type="checkbox" checked /> Remember me
        </label>
        <a href="#" style="color: var(--primary-orange); font-weight: 700; text-decoration: none;">Forgot Password?</a>
      </div>

      <asp:Button ID="btnLogin" runat="server" Text="Sign In" OnClick="btnLogin_Click" CssClass="btn-primary" Style="width: 100%; justify-content: center; border: none; cursor: pointer; font-size: 16px; padding: 12px;" />

      <div style="text-align: center; margin-top: 24px; font-size: 14px; color: var(--text-muted);">
        Don't have an account? <a href="Register.aspx" style="color: var(--primary-orange); font-weight: 700; text-decoration: none;">Sign up free</a>
      </div>
    </div>

  </form>

</body>
</html>
