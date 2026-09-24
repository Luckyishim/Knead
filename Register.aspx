<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Register.aspx.cs" Inherits="KneadLMS.Register" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Register - knead. Culinary LMS</title>
  <link rel="stylesheet" href="styles/register.css" />
</head>
<body style="background-color: var(--bg-primary); display: flex; flex-direction: column; justify-content: center; align-items: center; min-height: 100vh; margin: 0; padding: 20px;">

  <form id="formRegister" runat="server" style="width: 100%; max-width: 460px;">
    
    <div style="text-align: center; margin-bottom: 32px;">
      <a href="Default.aspx" class="logo" style="justify-content: center; margin-bottom: 16px;">
        <div class="logo-icon" style="width: 48px; height: 48px; font-size: 24px;">k.</div>
        <div class="logo-text">
          <h4 style="font-size: 28px;">knead<span>.</span></h4>
          <p>CULINARY LMS</p>
        </div>
      </a>
      <h2 style="font-size: 24px; font-weight: 800; color: var(--text-dark);">Create your account</h2>
      <p style="font-size: 14px; color: var(--text-muted); margin-top: 4px;">Join over 10,000+ passionate culinary students</p>
    </div>

    <div style="background-color: #FFFFFF; border: 1px solid var(--border-light); border-radius: 20px; padding: 32px; box-shadow: var(--shadow-md);">
      
      <asp:Panel ID="pnlError" runat="server" Visible="false" Style="margin-bottom: 16px; padding: 12px; border-radius: 8px; background-color: #FEE2E2; border: 1px solid #FCA5A5; color: #991B1B; font-size: 14px;">
        <asp:Literal ID="litErrorMessage" runat="server"></asp:Literal>
      </asp:Panel>

      <div class="form-group" style="margin-bottom: 16px;">
        <label style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 6px;">Full Name</label>
        <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" placeholder="Chef Anna Smith" Required="true" Style="width: 100%; box-sizing: border-box; padding: 10px; border-radius: 8px; border: 1px solid var(--border-medium);"></asp:TextBox>
      </div>

      <div class="form-group" style="margin-bottom: 16px;">
        <label style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 6px;">Email Address</label>
        <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" TextMode="Email" placeholder="chef@example.com" Required="true" Style="width: 100%; box-sizing: border-box; padding: 10px; border-radius: 8px; border: 1px solid var(--border-medium);"></asp:TextBox>
      </div>

      <div class="form-group" style="margin-bottom: 20px;">
        <label style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 6px;">Password</label>
        <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="At least 6 characters" Required="true" Style="width: 100%; box-sizing: border-box; padding: 10px; border-radius: 8px; border: 1px solid var(--border-medium);"></asp:TextBox>
      </div>

      <asp:Button ID="btnRegister" runat="server" Text="Create Free Account" OnClick="btnRegister_Click" CssClass="btn-primary" Style="width: 100%; justify-content: center; margin-top: 8px; border: none; cursor: pointer; font-size: 16px; padding: 12px;" />

      <div style="text-align: center; margin-top: 24px; font-size: 14px; color: var(--text-muted);">
        Already have an account? <a href="Login.aspx" style="color: var(--primary-orange); font-weight: 700; text-decoration: none;">Sign in</a>
      </div>
    </div>

  </form>

</body>
</html>
