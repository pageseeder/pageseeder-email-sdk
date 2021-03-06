<?xml version="1.0"?>
<!--
  Template used for the daily digest notification
-->
<xsl:stylesheet version="2.0"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:f="http://www.pageseeder.com/function"
                exclude-result-prefixes="#all">

<xsl:import href="_frame.xsl"/>

<!-- Subject and metadata -->
<xsl:template match="notification[@template='daily-digest']" mode="meta">
  <title>[<xsl:value-of select="group/@name" />] Daily digest</title>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='daily-digest']" mode="banner">
  <p wrapper-class="digest-wrap">Daily digest for <b><xsl:value-of select="format-date(current-date(), '[D] [MNn] [Y0001]')"/></b></p>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='daily-digest']" mode="body">
  <xsl:apply-templates select="comments" mode="html" />
</xsl:template>

<!-- ===================================================================================== -->
<!-- Comments -->
<!-- ===================================================================================== -->

<xsl:template match="comments" mode="html">
  <p>The <b><xsl:value-of select="count(comment)"/></b> comments below have been added to 
  the group <i><xsl:value-of select="../group/@name" /></i> in the last 24 hours.</p>

  <div class="digest-summary">
    <table cellspacing="0" cellpadding="0">
      <xsl:for-each-group select="comment" group-by="@discussionid">
        <xsl:sort select="@created" order="descending"/>
        <tr>
          <th width="80">&#xa0;</th>
          <td><b><xsl:value-of select="title" /></b></td>
        </tr>
        <xsl:for-each select="current-group()">
          <xsl:sort select="@created" order="descending"/>
          <tr>
            <th><xsl:value-of select="translate(format-dateTime(@created, '[h]:[m01] [PN]'),'.','')"/></th>
            <td><a href="#ps-{@discussionid}-{position()}"><xsl:value-of select="if (position() = last()) then 'Comment' else 'Reply'"/></a> by <i><xsl:value-of select="author/fullname" /></i></td>
          </tr>
        </xsl:for-each>
      </xsl:for-each-group>
    </table>
  </div>

  <table cellspacing="0" cellpadding="0" style="vertical-align:top; width:100%; border-collapse: collapse; background: white">
    <xsl:for-each-group select="comment" group-by="@discussionid">
      <xsl:sort select="@created" order="descending"/>
      <xsl:variable name="notification" select="ancestor::notification"/>
      <xsl:variable name="href" select="concat($notification/@hosturl, '/page/', $notification/group/@name, '/comments/', @id)"/>
      <tr>
        <th class="digest-title"><a name="ps-{@discussionid}-{position()}" id="ps-{@discussionid}-{position()}"/></th>
        <th class="digest-title"><a href="{$notification/@hosturl}/page/{$notification/group/@name}/comments/{@id}"><xsl:value-of select="title" /></a></th>
      </tr>
      <xsl:for-each select="current-group()">
        <xsl:sort select="@created" order="descending"/>
        <tr>
          <th class="digest-time"><xsl:value-of select="format-dateTime(@created, '[h]:[m01]')"/>
          <div class="ampm"><xsl:value-of select="translate(format-dateTime(@created, '[PN]'), '.','')"/></div></th>
          <td class="digest-comment">
            <xsl:apply-templates select="." mode="digest-html" />
          </td>
        </tr>
      </xsl:for-each>
      <tr>
        <td></td>
        <td>
          <p style="color: #999999"><i>You can reply to this comment <xsl:text/>
            <xsl:sequence select="f:link($href, 'online')" />
            <xsl:if test="/notification/@emaildomain">
              <xsl:variable name="email">
                <xsl:value-of select="@id" />
                <xsl:text>-reply@</xsl:text>
                <xsl:value-of select="/notification/@emaildomain" />
              </xsl:variable>
              <xsl:text> or by email at </xsl:text>
              <xsl:sequence select="f:link(concat('mailto:', $email, '?subject=Reply'), $email)" />
            </xsl:if>.<xsl:text/>
          </i></p>
        </td>
      </tr>
      <tr>
        <td colspan="2">&#160;</td>
      </tr>
    </xsl:for-each-group>
  </table>

  <p class="timezone">Dates and times display for timezone <xsl:value-of select="format-date(current-date(), '[z]')"/></p>

  <xsl:call-template name="noreply"/>
</xsl:template>

<!-- ===================================================================================== -->
<!-- Single Message -->
<!-- ===================================================================================== -->
<xsl:template match="comment" mode="digest-html">
  <table cellspacing="0" cellpadding="0" style="vertical-align:top; width:100%; border-collapse: collapse; background: white">
    <tbody>
      <!-- If it's a task -->
      <xsl:if test="@status">
        <tr>
          <td style="background:#e7e7e7;font-size: 13px; padding: 10px 2px">
            <span class="task-property">Status: <b class="task-value"><xsl:value-of select="@status" /></b></span>
            <xsl:if test="@priority">
              <span class="task-separator"> | </span>
              <span class="task-property">Priority: <b class="task-value"><xsl:value-of select="@priority" /></b></span>
            </xsl:if>
            <xsl:if test="assignedto">
              <span class="task-separator"> | </span>
              <span class="task-property">Assigned to: <b class="task-value"><xsl:value-of select="assignedto/fullname" /></b></span>
            </xsl:if>
            <xsl:if test="@due">
              <span class="task-separator"> | </span>
              <span class="task-property">Due date: <b class="task-value"><xsl:value-of select="format-dateTime(xs:dateTime(@due), '[D] [MNn,*-3] [Y]')" /></b></span>
            </xsl:if>
          </td>
        </tr>
      </xsl:if>

      <!-- Author and content -->
      <tr>
        <td class="digest-author">
          <b><xsl:value-of select="author/fullname" /></b>
        </td>
      </tr>
      <tr>
        <td class="digest-content">
          <xsl:copy-of select="content[@type = 'application/xhtml+xml']/node()" />
        </td>
      </tr>

      <xsl:if test="context/uri">
        <tr>
          <td class="digest-context-title"><b>Context</b></td>
        </tr>
        <tr>
          <td class="digest-context">
            <xsl:value-of select="context/uri/displaytitle" />
          </td>
        </tr>
      </xsl:if>

      <xsl:variable name="attachments" select="attachment/uri" />
      <xsl:if test="$attachments">
        <xsl:variable name="notification" select="ancestor::notification"/>
        <tr>
          <td class="digest-attachments-title">
            <b>Attachment<xsl:value-of select="if (count($attachments) > 1) then 's' else ''" /></b>
          </td>
        </tr>
        <tr>
          <td class="digest-attachments">
            <table width="100%" cellpadding="2" cellspacing="0" border="0"><tbody>
              <xsl:for-each select="$attachments">
                <tr>
                  <td class="attachment-icon"><img src="{$images-url}/{f:media-type-icon(.)}" border="0" alt="" /></td>
                  <xsl:variable name="view"     select="concat($notification/@hosturl, '/page/', $notification/group/@name, '/uri/', @id)" />
                  <xsl:variable name="download" select="concat($notification/@hosturl, '/uri/', @id, '?behavior=download')" />
                  <td class="attachment-title"><xsl:sequence select="f:link($view, displaytitle)" /></td>
                  <td class="attachment-download">
                    <xsl:if test="not(@mediatype = 'folder')">
                      <xsl:sequence select="f:link($download, 'Download')" />
                    </xsl:if>
                  </td>
                </tr>
              </xsl:for-each>
            </tbody></table>
          </td>
        </tr>
      </xsl:if>
    </tbody>
  </table>
</xsl:template>

</xsl:stylesheet>
