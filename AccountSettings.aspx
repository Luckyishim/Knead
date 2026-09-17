<%@ Page Title="Account Settings - knead. Culinary LMS" Language="C#" MasterPageFile="~/Profile.Master" AutoEventWireup="true" CodeFile="AccountSettings.aspx.cs" Inherits="KneadLMS.AccountSettings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link rel="stylesheet" href="styles/account-settings.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Full Width Member Page Container Without Sidebar -->
  <main class="member-page-container">
    
    <div class="member-page-header">
      <h1>Account Settings</h1>
      <p>Update your personal profile, email credentials, and security preferences.</p>
    </div>

    <div class="member-card-panel">
      <asp:Panel ID="pnlSettingsMsg" runat="server" Visible="false" Style="padding: 14px; border-radius: 10px; margin-bottom: 24px; font-weight: 600;">
        <asp:Literal ID="litSettingsMsg" runat="server"></asp:Literal>
      </asp:Panel>

      <div style="max-width: 650px;">
        <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 20px;">Profile Information</h3>

        <div class="form-group" style="margin-bottom: 16px;">
          <label style="display: block; font-weight: 600; font-size: 14px; margin-bottom: 6px;">Full Name</label>
          <asp:TextBox ID="txtFullName" runat="server" CssClass="form-control" Required="true" Style="width: 100%; box-sizing: border-box; padding: 10px; border-radius: 8px; border: 1px solid var(--border-medium);"></asp:TextBox>
        </div>

        <div class="form-group" style="margin-bottom: 24px;">
          <label style="display: block; font-weight: 600; font-size: 14px; margin-bottom: 6px;">Email Address</label>
          <asp:TextBox ID="txtEmail" runat="server" TextMode="Email" CssClass="form-control" Required="true" Style="width: 100%; box-sizing: border-box; padding: 10px; border-radius: 8px; border: 1px solid var(--border-medium);"></asp:TextBox>
        </div>

        <hr style="border: none; border-top: 1px solid var(--border-light); margin: 24px 0;" />

        <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 20px;">Change Password</h3>

        <div class="form-group" style="margin-bottom: 16px;">
          <label style="display: block; font-weight: 600; font-size: 14px; margin-bottom: 6px;">New Password (Optional)</label>
          <asp:TextBox ID="txtNewPassword" runat="server" TextMode="Password" placeholder="Leave blank to keep current password" CssClass="form-control" Style="width: 100%; box-sizing: border-box; padding: 10px; border-radius: 8px; border: 1px solid var(--border-medium);"></asp:TextBox>
        </div>

        <asp:Button ID="btnSaveSettings" runat="server" Text="Save Account Settings" OnClick="btnSaveSettings_Click" CssClass="btn-primary" Style="padding: 12px 28px; font-size: 15px; cursor: pointer; margin-top: 12px;" />
      </div>
    </div>

  </main>
</asp:Content>
