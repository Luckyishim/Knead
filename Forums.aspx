<%@ Page Title="Community Forum - knead. Culinary LMS" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeFile="Forums.aspx.cs" Inherits="KneadLMS.Forums" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
  <link rel="stylesheet" href="styles/forums-page.css" />
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
  <!-- Forum Title Header with Back Arrow -->
  <div class="forum-header" style="padding: 24px 0 12px; display: flex; align-items: center; gap: 16px;">
    <a href="Default.aspx" class="quiz-back-btn" title="Back to Home" style="display: inline-flex; align-items: center; justify-content: center; width: 44px; height: 44px; border-radius: 50%; background: #F5EFEB; color: #1C1917; text-decoration: none; flex-shrink: 0;">
      <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
        <path d="M19 12H5M12 19l-7-7 7-7"/>
      </svg>
    </a>
    <div class="forum-title-area">
      <h1 style="margin: 0; font-size: 28px; font-weight: 800;">Community Forum</h1>
      <p style="margin-top: 4px; color: var(--text-muted);">Connect with fellow culinary enthusiasts, share techniques, and discuss the finer points of gastronomy.</p>
    </div>
  </div>

  <!-- Main Forum Layout (3 Columns) -->
  <main class="forum-layout" style="min-height: 70vh;">
    
    <!-- Left Category Sidebar -->
    <aside class="forum-categories-card">
      <h4>Categories</h4>
      <nav class="category-nav-list">
        <a href="Forums.aspx" class="category-link active" data-category="all">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71"></path>
            <path d="M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71"></path>
          </svg>
          All Topics
        </a>
        
        <a href="Forums.aspx" class="category-link" data-category="cuisine">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M12 2v20M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
          </svg>
          Cuisine-Specific
        </a>
        
        <a href="Forums.aspx" class="category-link" data-category="technique">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="12" cy="12" r="10"></circle>
            <polyline points="12 6 12 12 16 14"></polyline>
          </svg>
          Technique
        </a>
        
        <a href="Forums.aspx" class="category-link" data-category="general">
          <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <path d="M21 15a2 2 0 0 1-2 2H7l-4 4V5a2 2 0 0 1 2-2h14a2 2 0 0 1 2 2z"></path>
          </svg>
          General
        </a>
      </nav>
    </aside>

    <!-- Middle Discussion Feed -->
    <section class="forum-main-feed">
      
      <!-- Top Search & Create Thread Controls -->
      <div class="forum-top-controls" style="margin-bottom: 24px; gap: 12px; flex-wrap: wrap;">
        <div class="forum-search-box" style="flex: 1; min-width: 250px;">
          <svg class="forum-search-icon" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
            <circle cx="11" cy="11" r="8"></circle>
            <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
          </svg>
          <asp:TextBox ID="txtSearchTopic" runat="server" placeholder="Search discussions..." AutoPostBack="true" OnTextChanged="btnSearch_Click"></asp:TextBox>
        </div>

        <asp:DropDownList ID="ddlRecipeSelect" runat="server" CssClass="form-control" Style="padding: 10px 14px; border-radius: 12px; border: 1px solid var(--border-medium);">
        </asp:DropDownList>
        
        <asp:Button ID="btnOpenNewTopic" runat="server" Text="+ New Thread" OnClick="btnOpenNewTopic_Click" CssClass="btn-primary" Style="padding: 10px 20px;" />
      </div>

      <!-- New Topic Creation Box -->
      <asp:Panel ID="pnlNewTopicForm" runat="server" Visible="false" Style="background: white; border: 1px solid var(--border-light); border-radius: 16px; padding: 24px; margin-bottom: 24px; box-shadow: var(--shadow-md);">
        <h3 style="font-size: 18px; font-weight: 700; margin-bottom: 16px;">Create a New Discussion Topic</h3>
        
        <asp:Panel ID="pnlTopicError" runat="server" Visible="false" Style="padding: 10px; background: #FEE2E2; color: #991B1B; border-radius: 8px; margin-bottom: 12px;">
          <asp:Literal ID="litTopicError" runat="server"></asp:Literal>
        </asp:Panel>

        <div class="form-group" style="margin-bottom: 12px;">
          <label style="font-size: 14px; font-weight: 600; display: block; margin-bottom: 4px;">Topic Title</label>
          <asp:TextBox ID="txtTopicTitle" runat="server" CssClass="form-control" placeholder="e.g. Tips on pleating Momo dough wrappers?" Required="true" Style="width: 100%; box-sizing: border-box; padding: 10px; border-radius: 8px; border: 1px solid var(--border-medium);"></asp:TextBox>
        </div>

        <div class="form-group" style="margin-bottom: 16px;">
          <label style="font-size: 14px; font-weight: 600; display: block; margin-bottom: 4px;">Initial Comment / Details</label>
          <asp:TextBox ID="txtInitialComment" runat="server" TextMode="MultiLine" Rows="3" CssClass="form-control" placeholder="Write your question or thoughts here..." Required="true" Style="width: 100%; box-sizing: border-box; padding: 10px; border-radius: 8px; border: 1px solid var(--border-medium);"></asp:TextBox>
        </div>

        <div style="display: flex; gap: 12px;">
          <asp:Button ID="btnPostTopic" runat="server" Text="Post Topic" OnClick="btnPostTopic_Click" CssClass="btn-primary" Style="padding: 10px 24px;" />
          <asp:Button ID="btnCancelTopic" runat="server" Text="Cancel" OnClick="btnCancelTopic_Click" CssClass="btn-action-outline" Style="padding: 10px 20px;" />
        </div>
      </asp:Panel>

      <!-- Thread Cards List -->
      <div class="thread-list">
        <asp:Repeater ID="rptTopics" runat="server">
          <ItemTemplate>
            <article class="thread-card" style="background: white; margin-bottom: 16px; padding: 20px; border-radius: 16px; border: 1px solid var(--border-light);">
              <div class="thread-meta-top" style="display: flex; gap: 8px; align-items: center; font-size: 13px; color: var(--text-muted);">
                <span class="badge-tag orange"><%# string.IsNullOrEmpty(Eval("RecipeTitle").ToString()) ? "General" : Eval("RecipeTitle") %></span>
                <span>•</span>
                <span>Posted by <strong><%# Eval("AuthorName") %></strong></span>
                <span>•</span>
                <span><%# Convert.ToDateTime(Eval("CreatedDate")).ToString("MMM dd, yyyy HH:mm") %></span>
              </div>

              <a href='<%# "ForumDetail.aspx?topicId=" + Eval("TopicID") %>' class="thread-title" style="display: block; font-size: 18px; font-weight: 700; color: var(--text-dark); margin: 8px 0; text-decoration: none;">
                <%# Eval("TopicTitle") %>
              </a>

              <div class="thread-footer-stats" style="display: flex; justify-content: space-between; font-size: 13px; color: var(--text-muted); margin-top: 12px;">
                <span>💬 <%# Eval("CommentCount") %> Replies</span>
                <a href='<%# "ForumDetail.aspx?topicId=" + Eval("TopicID") %>' style="color: var(--primary-orange); font-weight: 700; text-decoration: none;">View Discussion & Comments →</a>
              </div>
            </article>
          </ItemTemplate>
        </asp:Repeater>

        <asp:Panel ID="pnlNoTopics" runat="server" Visible="false" Style="padding: 40px; text-align: center; background: white; border-radius: 16px;">
          <p style="color: var(--text-muted);">No forum topics found.</p>
        </asp:Panel>
      </div>

    </section>

    <!-- Right Sidebar Widgets -->
    <aside class="forum-sidebar">
      
      <!-- Trending Topics -->
      <div class="trending-topics-card">
        <h4>📈 Trending Topics</h4>
        <div class="tags-cloud">
          <a href="#" class="tag-pill">#SourdoughStarter</a>
          <a href="#" class="tag-pill">#SousVide</a>
          <a href="#" class="tag-pill">#KnifeSharpening</a>
          <a href="#" class="tag-pill">#VeganBaking</a>
          <a href="#" class="tag-pill">#PlatingTechniques</a>
        </div>
      </div>

      <!-- Community Guidelines -->
      <div class="guidelines-card">
        <h4>Community Guidelines</h4>
        <p>Be respectful, constructive, and helpful. Keep discussions focused on culinary arts and education.</p>
        <a href="#">Read full guidelines →</a>
      </div>

    </aside>

  </main>
</asp:Content>
