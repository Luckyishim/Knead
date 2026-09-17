<%@ Page Title="Forum Discussion - knead. Culinary LMS" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="ForumDetail.aspx.cs" Inherits="KneadLMS.ForumDetail" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link rel="stylesheet" href="styles/forum-detail.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <main class="cuisine-section" style="padding-top: 40px; min-height: 80vh;">
    
    <div style="margin-bottom: 20px;">
      <a href="Forums.aspx" class="btn-action-outline" style="text-decoration: none;">← Back to Forum Topics</a>
    </div>

    <!-- Topic Card -->
    <div style="background: white; border-radius: 16px; border: 1px solid var(--border-light); padding: 28px; margin-bottom: 28px; box-shadow: var(--shadow-sm);">
      <div style="display: flex; gap: 8px; align-items: center; font-size: 13px; color: var(--text-muted); margin-bottom: 8px;">
        <span class="badge-tag orange"><asp:Literal ID="litRecipeBadge" runat="server">General</asp:Literal></span>
        <span>•</span>
        <span>Posted by <strong><asp:Literal ID="litAuthorName" runat="server">User</asp:Literal></strong></span>
        <span>•</span>
        <span><asp:Literal ID="litTopicDate" runat="server">Date</asp:Literal></span>
      </div>

      <h1 style="font-size: 24px; font-weight: 800; color: var(--text-dark); margin: 0 0 12px;"><asp:Literal ID="litTopicTitle" runat="server">Topic Title</asp:Literal></h1>
    </div>

    <!-- Comments Section -->
    <div style="margin-bottom: 32px;">
      <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 16px;">
        💬 Discussion Comments (<asp:Literal ID="litCommentCount" runat="server">0</asp:Literal>)
      </h3>

      <div style="display: flex; flex-direction: column; gap: 16px;">
        <asp:Repeater ID="rptComments" runat="server">
          <ItemTemplate>
            <div style="background: #FFFDF9; border: 1px solid var(--border-light); border-radius: 12px; padding: 20px;">
              <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 8px;">
                <strong style="font-size: 15px; color: var(--text-dark);"><%# Eval("AuthorName") %></strong>
                <span style="font-size: 12px; color: var(--text-muted);"><%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM dd, yyyy HH:mm") %></span>
              </div>
              <p style="font-size: 14px; color: var(--text-main); line-height: 1.6; margin: 0;"><%# Eval("CommentText") %></p>
            </div>
          </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoComments" runat="server" Visible="false" Style="padding: 24px; text-align: center; color: var(--text-muted); background: white; border-radius: 12px;">
          No comments yet. Be the first to join the conversation!
        </asp:Panel>
      </div>
    </div>

    <!-- Add Comment Form -->
    <div style="background: white; border-radius: 16px; border: 1px solid var(--border-light); padding: 24px; box-shadow: var(--shadow-sm);">
      <h4 style="font-size: 16px; font-weight: 700; margin-bottom: 12px;">Leave a Comment</h4>
      
      <asp:Panel ID="pnlCommentError" runat="server" Visible="false" Style="padding: 10px; background: #FEE2E2; color: #991B1B; border-radius: 8px; margin-bottom: 12px;">
        <asp:Literal ID="litCommentError" runat="server"></asp:Literal>
      </asp:Panel>

      <div class="form-group" style="margin-bottom: 16px;">
        <asp:TextBox ID="txtNewComment" runat="server" TextMode="MultiLine" Rows="4" CssClass="form-control" placeholder="Share your insights or ask a follow-up question..." Style="width: 100%; box-sizing: border-box; padding: 12px; border-radius: 10px; border: 1px solid var(--border-medium);"></asp:TextBox>
      </div>

      <asp:Button ID="btnAddComment" runat="server" Text="Submit Comment" OnClick="btnAddComment_Click" CssClass="btn-primary" Style="padding: 12px 28px; cursor: pointer;" />
    </div>

  </main>
</asp:Content>
