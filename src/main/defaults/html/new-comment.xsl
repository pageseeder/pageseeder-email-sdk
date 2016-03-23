<?xml version="1.0"?>
<!--
  Email sent to the user after a new comment is added.
-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:f="http://www.pageseeder.com/function"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all">

<xsl:import href="_frame.xsl"/>
<xsl:import href="_markdown.xsl"/>

<!-- Metadata -->
<xsl:template match="notification[@template='new-comment']" mode="meta">
  <meta name="replyto-email"      content="{comment/@id}-reply@{@emaildomain}" />
  <meta name="replyto-name"       content="Reply to {group/@name} group" />
  <meta name="list-id"            content="{group/@name}.{@emaildomain}" />
  <meta name="list-name"          content="{group/@description}" />
  <meta name="list-help"          content="{@hosturl}/page/{group/@name}/home" />
  <meta name="list-unsubscribe"   content="{@hosturl}/page/{group/@name}/preferences/mygroups" />
  <meta name="list-post"          content="{@hosturl}/page/{group/@name}/comment/new" />
  <meta name="list-archive"       content="{@hosturl}/page/{group/@name}/comments" />
  <meta name="message-id"         content="{comment/@id}.comment@{@emaildomain}" />
  <xsl:if test="comment/@id!=comment/@discussionid">
    <meta name="in-reply-to" content="{comment/@discussionid}.comment@{@emaildomain}" />
  </xsl:if>
  <title>
    <xsl:text>[</xsl:text>
    <xsl:value-of select="group/@name" />
    <xsl:text>] </xsl:text>
    <xsl:choose>
      <xsl:when test="comment/@status and comment/@contentrole='Workflow'">(Workflow) </xsl:when>
      <xsl:when test="comment/@status">(Task) </xsl:when>
    </xsl:choose>
    <xsl:value-of select="comment/title" />
  </title>
</xsl:template>

<!-- Task banner -->
<xsl:template match="notification[@template='new-comment']" mode="banner">
  <xsl:apply-templates select="comment" mode="task"/>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='new-comment']" mode="body">
  <!-- Document version -->
  <xsl:if test="@modified = 'true'">
    <table class="note"><tr><td>This <xsl:value-of select="if (empty(comment/@status)) then 'comment' else 'task'"/> 
    has been modified.</td></tr></table>
  </xsl:if>

  <!-- Status changed -->
  <xsl:if test="@taskchanged = 'true'">
    <table class="note"><tr><td>NOTE: The task details above have been changed.</td></tr></table>
  </xsl:if>

  <!-- Broadcast All -->
  <xsl:if test="@announcement = 'true'">
    <table class="announcement"><tr><td>This comment has been sent to you regardless of your PageSeeder notification 
    settings because it is an announcement.</td></tr></table>
  </xsl:if>

  <!-- Document Context -->
  <xsl:apply-templates select="comment" mode="context" />

  <!-- Check for recipients -->
  <xsl:apply-templates select="recipients" />

  <!-- Contents -->
  <xsl:choose>
    <!-- is there XHTML content? -->
    <xsl:when test="comment/content[@type = 'application/xhtml+xml']">
      <xsl:copy-of select="comment/content[@type = 'application/xhtml+xml']/node()" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:for-each select="comment/content[contains(@type,'text/plain')]">
        <xsl:sort select="id" />
        <xsl:sequence select="f:markdown(text())" />
      </xsl:for-each>

    </xsl:otherwise>
  </xsl:choose>

  <!-- Labels -->
  <xsl:apply-templates select="comment" mode="labels" />

  <!-- File Attachements -->
  <xsl:apply-templates select="comment" mode="attachments" />

  <!-- More info -->
  <h4 class="subtitle">More information about this message</h4>
  <p>You can reply to this message
    <xsl:choose>
      <xsl:when test="comment/@contentrole='Workflow'">
        <xsl:sequence select="f:link(concat(@hosturl, '/page/', group/@name, '/uri/', comment/context/uri/@id, '/workflow'), 'online')"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:sequence select="f:link(concat(@hosturl, '/page/', group/@name, '/comments/', comment/@id), 'online')"/>
      </xsl:otherwise>
    </xsl:choose>
    or directly by typing your response above this email.</p>
    
  <xsl:if test="comment/@due">
    <p class="timezone">Dates and times display for timezone <xsl:value-of select="format-date(current-date(), '[z]')"/></p>
  </xsl:if>
</xsl:template>

<!-- ====================================================================== -->
<!-- Supporting templates -->
<!-- ====================================================================== -->

<xsl:template match="recipients">
<xsl:if test="recipient">
  <table class="recipients"><tr><td>
    <xsl:for-each select="recipient">
      <p>
      <xsl:value-of select="upper-case(@type)" />
      <xsl:text>: </xsl:text>
      <xsl:if test="@name"><xsl:value-of select="concat(@name, ' ')" /></xsl:if>
      <xsl:value-of select="@email" />
      </p>
    </xsl:for-each>
  </td></tr></table>
</xsl:if>
</xsl:template>

<xsl:template match="comment" mode="context">
  <xsl:if test="context/uri">
    <table width="100%" cellpadding="0" cellspacing="0" border="0" style="height: 20px; border-bottom: 1px solid #d7d7d7;margin-bottom:10px">
      <tr><td style="font-size:13px;text-align:right;padding-bottom:4px;">
        <img src="{$images-url}/{f:media-type-icon(context/uri)}" style="vertical-align: bottom;" border="0" />
        <b>Document: </b>
        <xsl:sequence select="f:link(concat(/notification/@hosturl, '/page/', ../group/@name, '/uri/', context/uri/@id), context/uri/displaytitle)" />
      </td></tr>
    </table>
  </xsl:if>
</xsl:template>

<xsl:template match="comment" mode="task">
<xsl:if test="../@taskchanged = 'true' or not(empty(@status | @priority | assignedto | @due))">
  <table width="100%" cellpadding="0" cellspacing="0" border="0" wrapper-class="task-wrap"><tr>
    <td style="font-size:13px; width: 36px">
      <div style="padding-top: 2px; line-height:12px;">
      <img src="{$images-url}/{f:status-icon(@status)}" border="0" alt="{@status}" />
      <xsl:if test="@priority">
        <img src="{$images-url}/{f:priority-icon(@priority)}" border="0" alt="{@priority}" />
      </xsl:if>
      </div>
    </td>
    <td style="font-size:13px"><b style="font-size: 14px; margin: 0; padding:1px;">
      <xsl:choose>
        <xsl:when test="@contentrole='Workflow'">Workflow</xsl:when>
        <xsl:otherwise>Task</xsl:otherwise>
      </xsl:choose>
    </b></td>
    <td style="font-size:13px; text-align:right;">
      <span class="task-property">Status: <b class="task-value">
        <xsl:value-of select="@status" /></b>
      </span>
      <xsl:if test="@priority">
        <span class="task-separator"> | </span>
        <span class="task-property">Priority: <b class="task-value">
          <xsl:value-of select="@priority" />
        </b></span>
      </xsl:if>
      <xsl:if test="assignedto">
        <span class="task-separator"> | </span>
        <span class="task-property">Assigned to: <b class="task-value">
          <xsl:value-of select="assignedto/fullname" /></b>
        </span>
      </xsl:if>
      <xsl:if test="@due">
        <span class="task-separator"> | </span>
        <span class="task-property">Due date: <b class="task-value">
          <xsl:value-of select="format-dateTime(xs:dateTime(@due), '[D] [MNn,*-3] [Y]')" /></b>
        </span>
      </xsl:if>
    </td>
  </tr></table>
</xsl:if>
</xsl:template>

<xsl:template match="comment" mode="labels">
  <xsl:if test="labels">
    <table cellpadding="0" cellspacing="0" border="0"><tr><td style="text-align:right;font-size:12px">
      <xsl:for-each select="tokenize(labels, ',')">
        <img src="{$images-url}/ico-label.png" alt="Label:" border="0" />
        <span><xsl:value-of select="." /></span>
      </xsl:for-each>
    </td></tr></table>
  </xsl:if>
</xsl:template>

<xsl:template match="comment" mode="attachments">
<xsl:if test="attachment/uri">
  <h4 class="subtitle">File Attachments</h4>
  <table width="100%" cellpadding="2" cellspacing="0" border="0" style="border-collapse: collapse"><tbody>
    <xsl:for-each select="attachment/uri">
      <tr>
        <td style="width:20px;font-size:13px;"><img src="{$images-url}/{f:media-type-icon(.)}" border="0" alt="" /></td>
        <xsl:variable name="view"     select="concat(/notification/@hosturl, '/page/', ../../../group/@name, '/uri/', @id)" />
        <xsl:variable name="download" select="concat(/notification/@hosturl, '/uri/', @id, '?behavior=download')" />
        <td style="font-size: 13px;"><xsl:sequence select="f:link($view, displaytitle)" /></td>
        <td width="60" style="font-size: 13px;text-align:right">
          <xsl:if test="not(starts-with(@behavior, 'standard-')) and not(@mediatype = 'folder')">
            <xsl:sequence select="f:link($download, 'Download')" />
          </xsl:if>
        </td>
      </tr>
    </xsl:for-each>
  </tbody></table>
</xsl:if>
</xsl:template>

<!--
  Find the name of the icon corresponding to the status provided
  
  @param status the status
  
  @param the filename of the icon
 -->
<xsl:function name="f:status-icon">
<xsl:param name="status"/>
<xsl:choose>
  <xsl:when test="lower-case($status) = 'closed'">task-closed.png</xsl:when>
  <xsl:when test="lower-case($status) = 'resolved'">task-resolved.png</xsl:when>
  <xsl:otherwise>task-open.png</xsl:otherwise>
</xsl:choose>
</xsl:function>

<!--
  Find the name of the icon corresponding to the priority provided
  
  @param priority the priority
  
  @param the filename of the icon
 -->
<xsl:function name="f:priority-icon">
<xsl:param name="priority"/>
<xsl:choose>
  <xsl:when test="lower-case($priority) = 'high'">task-priority-1.png</xsl:when>
  <xsl:when test="lower-case($priority) = 'medium'">task-priority-2.png</xsl:when>
  <xsl:when test="lower-case($priority) = 'low'">task-priority-3.png</xsl:when>
  <xsl:otherwise>task-priority-4.png</xsl:otherwise>
</xsl:choose>
</xsl:function>

</xsl:stylesheet>
