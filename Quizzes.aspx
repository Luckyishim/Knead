<%@ Page Title="Quizzes - knead. Culinary LMS" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Quizzes.aspx.cs" Inherits="KneadLMS.Quizzes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link rel="stylesheet" href="styles/quizzes.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <main class="cuisine-section" style="padding-top: 40px; min-height: 80vh;">
    
    <div class="welcome-header" style="margin-bottom: 28px;">
      <h1>Recipe Quizzes & Assessments</h1>
      <p>Test your culinary knowledge, verify your understanding of techniques, and earn completion badges.</p>
    </div>

    <div class="cuisine-grid">
      <asp:Repeater ID="rptQuizzes" runat="server">
        <ItemTemplate>
          <div class="cuisine-card" style="display: flex; flex-direction: column; justify-content: space-between; text-align: left; padding: 20px;">
            <div>
              <div class="cuisine-img-box" style="height: 160px; margin-bottom: 12px;">
                <img src='<%# GetImageUrl(Eval("Thumbnail")) %>' alt='<%# Eval("QuizTitle") %>' />
              </div>
              <span class="badge-tag" style="background: var(--primary-orange-light); color: var(--primary-orange);"><%# Eval("CuisineName") %></span>
              <h4 style="margin-top: 8px; font-size: 16px; font-weight: 700;"><%# Eval("QuizTitle") %></h4>
              <p style="font-size: 13px; color: var(--text-muted); margin-top: 4px;">Recipe: <%# Eval("RecipeTitle") %></p>
              <p style="font-size: 13px; color: var(--text-dark); font-weight: 600; margin-top: 8px;">Passing Score: <%# Eval("PassingScore") %>%</p>
            </div>
            
            <div style="margin-top: 16px;">
              <a href='<%# "QuizDetail.aspx?quizId=" + Eval("QuizID") %>' class="btn-primary" style="display: block; text-align: center; text-decoration: none; padding: 10px;">Take Quiz →</a>
            </div>
          </div>
        </ItemTemplate>
      </asp:Repeater>

      <asp:Panel ID="pnlNoQuizzes" runat="server" Visible="false" Style="grid-column: 1 / -1; text-align: center; padding: 40px; background: white; border-radius: 16px;">
        <p style="font-size: 16px; color: var(--text-muted);">No quiz assessments available at the moment.</p>
        <a href="ItemList.aspx" class="btn-primary" style="display: inline-block; margin-top: 16px; text-decoration: none;">Browse Recipes</a>
      </asp:Panel>
    </div>

  </main>
</asp:Content>
