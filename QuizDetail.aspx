<%@ Page Language="C#" AutoEventWireup="true" CodeFile="QuizDetail.aspx.cs" Inherits="KneadLMS.QuizDetail" %>

<!DOCTYPE html>
<html lang="en">
<head runat="server">
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>Quiz Assessment - knead. Culinary LMS</title>
  <link rel="stylesheet" href="styles/quiz-detail.css" />
</head>
<body class="quiz-page-body">
  <form id="formQuiz" runat="server">

    <!-- Top Minimal Header -->
    <div class="quiz-top-bar">
      <a href="Quizzes.aspx" class="quiz-back-btn" title="Back to Quizzes">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
          <path d="M19 12H5M12 19l-7-7 7-7"/>
        </svg>
      </a>
      <a href="Default.aspx" class="logo" style="gap: 8px; text-decoration: none;">
        <div class="logo-icon" style="width: 32px; height: 32px; font-size: 16px;">k.</div>
        <span class="logo-text">
          <h4 style="font-size: 18px;">knead.</h4>
        </span>
      </a>
      <div></div>
    </div>

    <!-- Quiz Main Container -->
    <main class="quiz-main-container">
      
      <!-- Quiz Header Info & Progress -->
      <div class="quiz-header-info">
        <div class="quiz-header-title-row">
          <div>
            <h2><asp:Literal ID="litQuizTitle" runat="server">Quiz Assessment</asp:Literal></h2>
            <div class="quiz-question-step">PASSING SCORE: <asp:Literal ID="litPassingScore" runat="server">70</asp:Literal>%</div>
          </div>
          <div class="quiz-timer">
            <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
              <circle cx="12" cy="12" r="10"></circle>
              <polyline points="12 6 12 12 16 14"></polyline>
            </svg>
            Untimed
          </div>
        </div>
      </div>

      <!-- Result Result Card -->
      <asp:Panel ID="pnlResult" runat="server" Visible="false" Style="margin-bottom: 24px; padding: 24px; border-radius: 16px; background-color: #FFFFFF; box-shadow: var(--shadow-md); text-align: center;">
        <h3 style="font-size: 22px; font-weight: 800;"><asp:Literal ID="litResultHeadline" runat="server"></asp:Literal></h3>
        <p style="font-size: 16px; margin-top: 8px; color: var(--text-dark);"><asp:Literal ID="litResultScoreText" runat="server"></asp:Literal></p>
        <div style="margin-top: 20px; display: flex; gap: 12px; justify-content: center;">
          <a href="UserDashboard.aspx" class="btn-primary">Go to Dashboard</a>
          <a href="Quizzes.aspx" class="btn-outline">More Quizzes</a>
        </div>
      </asp:Panel>

      <!-- Questions List -->
      <asp:Panel ID="pnlQuestions" runat="server">
        <asp:Repeater ID="rptQuestions" runat="server" OnItemDataBound="rptQuestions_ItemDataBound">
          <ItemTemplate>
            <div class="quiz-card-wrapper" style="margin-bottom: 24px;">
              <div class="quiz-card-inner">
                <h4 style="color: var(--primary-orange); font-size: 14px; font-weight: 700; margin-bottom: 8px;">QUESTION <%# Container.ItemIndex + 1 %></h4>
                <h3 class="quiz-question-text" style="margin-bottom: 20px;"><%# Eval("Question") %></h3>

                <asp:HiddenField ID="hfQuestionID" runat="server" Value='<%# Eval("QuestionID") %>' />

                <div class="quiz-options-list">
                  <asp:RadioButtonList ID="rblOptions" runat="server" CssClass="quiz-rbl" Style="width: 100%; border: none;">
                  </asp:RadioButtonList>
                </div>
              </div>
            </div>
          </ItemTemplate>
        </asp:Repeater>

        <div style="text-align: center; margin: 32px 0;">
          <asp:Button ID="btnSubmitQuiz" runat="server" Text="Submit Quiz Answers" OnClick="btnSubmitQuiz_Click" CssClass="btn-primary" Style="padding: 14px 40px; font-size: 16px; cursor: pointer;" />
        </div>
      </asp:Panel>

    </main>

  </form>
</body>
</html>
