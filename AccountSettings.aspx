<%@ Page Title="Account Settings - knead. Culinary LMS" Language="C#" MasterPageFile="~/Profile.Master" AutoEventWireup="true" CodeFile="AccountSettings.aspx.cs" Inherits="KneadLMS.AccountSettings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link rel="stylesheet" href="styles/account-settings.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <div class="dashboard-layout">
    
    <!-- Sidebar Navigation -->
    <aside class="dashboard-sidebar">
      <div class="user-profile-badge">
        <div class="user-avatar" style="background: var(--primary-orange); color: white; border-radius: 50%; font-weight: 800; font-size: 16px;">
          <asp:Literal ID="litSidebarInitials" runat="server">U</asp:Literal>
        </div>
        <div class="user-info">
          <h5><asp:Literal ID="litSidebarName" runat="server">Member Portal</asp:Literal></h5>
          <p><asp:Literal ID="litSidebarRole" runat="server">Culinary Student</asp:Literal></p>
        </div>
      </div>

      <nav class="sidebar-menu">
        <a href="UserDashboard.aspx" class="menu-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <rect x="3" y="3" width="7" height="7" rx="1"></rect>
            <rect x="14" y="3" width="7" height="7" rx="1"></rect>
            <rect x="14" y="14" width="7" height="7" rx="1"></rect>
            <rect x="3" y="14" width="7" height="7" rx="1"></rect>
          </svg>
          Dashboard
        </a>

        <a href="MyProgress.aspx" class="menu-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <line x1="18" y1="20" x2="18" y2="10"></line>
            <line x1="12" y1="20" x2="12" y2="4"></line>
            <line x1="6" y1="20" x2="6" y2="14"></line>
          </svg>
          My Progress
        </a>

        <a href="SavedRecipes.aspx" class="menu-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M19 21l-7-5-7 5V5a2 2 0 0 1 2-2h10a2 2 0 0 1 2 2z"></path>
          </svg>
          Saved Recipes
        </a>

        <a href="QuizHistory.aspx" class="menu-item">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="10"></circle>
            <polyline points="12 6 12 12 16 14"></polyline>
          </svg>
          Quiz History
        </a>

        <a href="AccountSettings.aspx" class="menu-item active">
          <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="3"></circle>
            <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 0 1 0 2.83 2 2 0 0 1-2.83 0l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-2 2 2 2 0 0 1-2-2v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 0 1-2.83 0 2 2 0 0 1 0-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1-2-2 2 2 0 0 1 2-2h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 0 1 0-2.83 2 2 0 0 1 2.83 0l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 2-2 2 2 0 0 1 2 2v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 0 1 2.83 0 2 2 0 0 1 0 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 2 2 2 2 0 0 1-2 2h-.09a1.65 1.65 0 0 0-1.51 1z"></path>
          </svg>
          Account Settings
        </a>
      </nav>
    </aside>

    <!-- Main Content Area -->
    <main class="dashboard-main">
      <div class="welcome-header">
        <h1 style="margin: 0;">Account Settings</h1>
        <p style="margin-top: 4px;">Update your personal profile, email credentials, and security preferences.</p>
      </div>

      <div class="member-card-panel" style="background: white; border: 1px solid var(--border-light); border-radius: 18px; padding: 28px;">
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

  </div>
</asp:Content>
