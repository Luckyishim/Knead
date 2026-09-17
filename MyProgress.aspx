<%@ Page Title="My Progress - knead. Culinary LMS" Language="C#" MasterPageFile="~/Profile.Master" AutoEventWireup="true" CodeFile="MyProgress.aspx.cs" Inherits="KneadLMS.MyProgress" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link rel="stylesheet" href="styles/my-progress.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Full Width Member Page Container Without Sidebar -->
  <main class="member-page-container">
    
    <div class="member-page-header">
      <h1>My Learning Progress & Path</h1>
      <p>Monitor your culinary learning milestones, completed masterclasses, and skill competencies.</p>
    </div>

    <div class="member-card-panel">
      <h3 style="font-size: 20px; font-weight: 800; margin-bottom: 20px;">Enrolled Masterclasses & History</h3>
      <div class="learning-cards-list">
        <asp:Repeater ID="rptProgress" runat="server">
          <ItemTemplate>
            <div class="course-progress-card" style="margin-bottom: 16px;">
              <div class="course-thumb">
                <img src='<%# string.IsNullOrEmpty(Eval("Thumbnail").ToString()) ? "images/momo_dish.jpg" : Eval("Thumbnail") %>' alt='<%# Eval("RecipeTitle") %>' />
              </div>
              <div class="course-info">
                <span class="course-category"><%# Eval("CuisineName") %> • <%# Eval("CourseTypeName") %></span>
                <h4 class="course-title"><%# Eval("RecipeTitle") %></h4>
                <p class="course-module"><%# Convert.ToBoolean(Eval("IsCompleted")) ? "Completed on " + Convert.ToDateTime(Eval("CompletedDate")).ToString("MMM dd, yyyy") : "In Progress" %></p>
                <div class="progress-bar-container">
                  <div class="progress-track">
                    <div class="progress-fill" style='<%# Convert.ToBoolean(Eval("IsCompleted")) ? "width: 100%;" : "width: 50%;" %>'></div>
                  </div>
                  <a href='<%# "RecipeDetail.aspx?recipeId=" + Eval("RecipeID") %>' class="btn-dark"><%# Convert.ToBoolean(Eval("IsCompleted")) ? "Review" : "Resume" %></a>
                </div>
              </div>
            </div>
          </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoProgress" runat="server" Visible="false" Style="padding: 40px; text-align: center; color: var(--text-muted); background: white; border-radius: 16px;">
          You have not started any lessons yet. <a href="ItemList.aspx" style="color: var(--primary-orange); font-weight: 700;">Explore Cuisines</a>
        </asp:Panel>
      </div>
    </div>

  </main>
</asp:Content>
