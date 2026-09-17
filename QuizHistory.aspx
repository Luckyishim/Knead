<%@ Page Title="Quiz History - knead. Culinary LMS" Language="C#" MasterPageFile="~/Profile.Master" AutoEventWireup="true" CodeFile="QuizHistory.aspx.cs" Inherits="KneadLMS.QuizHistory" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link rel="stylesheet" href="styles/quiz-history.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Full Width Member Page Container Without Sidebar -->
  <main class="member-page-container">
    
    <div class="member-page-header">
      <h1>Quiz Attempt History</h1>
      <p>Track your score achievements, test attempts, and certificate qualifications.</p>
    </div>

    <!-- Quiz History Data Table Card -->
    <div class="member-card-panel">
      <div class="history-table-wrapper">
        <asp:GridView ID="gvQuizHistory" runat="server" AutoGenerateColumns="False" CssClass="history-table">
          <Columns>
            <asp:TemplateField HeaderText="QUIZ ASSESSMENT">
              <ItemTemplate>
                <strong><%# Eval("QuizTitle") %></strong>
              </ItemTemplate>
            </asp:TemplateField>

            <asp:BoundField DataField="RecipeTitle" HeaderText="RECIPE" />
            
            <asp:TemplateField HeaderText="SCORE (%)">
              <ItemTemplate>
                <span style="font-weight: 800; color: <%# Convert.ToBoolean(Eval("Passed")) ? "#2D4C2A" : "#C26300" %>;">
                  <%# Eval("Score") %>%
                </span>
              </ItemTemplate>
            </asp:TemplateField>

            <asp:TemplateField HeaderText="STATUS">
              <ItemTemplate>
                <span class='<%# Convert.ToBoolean(Eval("Passed")) ? "status-pill passed" : "status-pill retry" %>'>
                  <%# Convert.ToBoolean(Eval("Passed")) ? "PASSED ✓" : "RETRY" %>
                </span>
              </ItemTemplate>
            </asp:TemplateField>

            <asp:BoundField DataField="AttemptDate" HeaderText="DATE TAKEN" DataFormatString="{0:yyyy-MM-dd HH:mm}" />

            <asp:TemplateField HeaderText="ACTION">
              <ItemTemplate>
                <%# Convert.ToBoolean(Eval("Passed")) ? 
                    "<button class=\"btn-action-outline\" style=\"padding: 4px 12px; font-size: 12px;\" onclick=\"alert('Certificate generated!'); return false;\">🎓 Certificate</button>" : 
                    "<a href=\"Quizzes.aspx\" class=\"btn-dark\" style=\"padding: 6px 14px; font-size: 12px;\">Retake Quiz</a>" %>
              </ItemTemplate>
            </asp:TemplateField>
          </Columns>
        </asp:GridView>

        <asp:Panel ID="pnlNoAttempts" runat="server" Visible="false" Style="padding: 30px; text-align: center; color: var(--text-muted);">
          You haven't taken any quizzes yet. <a href="Quizzes.aspx" style="color: var(--primary-orange); font-weight: 700;">Take a Quiz</a>
        </asp:Panel>
      </div>
    </div>

    <!-- Quick Start Quiz Banner -->
    <div style="background-color: #FAF0E4; border: 1.5px dashed var(--primary-orange); border-radius: 18px; padding: 24px; display: flex; align-items: center; justify-content: space-between; gap: 20px; flex-wrap: wrap;">
      <div>
        <h4 style="font-size: 18px; font-weight: 800; margin-bottom: 4px;">Ready to test your culinary skills?</h4>
        <p style="font-size: 14px; color: var(--text-muted);">Choose from available course assessments and earn verified culinary credentials.</p>
      </div>
      <a href="Quizzes.aspx" class="btn-primary">Start New Quiz →</a>
    </div>

  </main>
</asp:Content>
