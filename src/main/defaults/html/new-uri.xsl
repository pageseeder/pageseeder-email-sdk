<?xml version="1.0"?>
<!--
  Template used when a URL is created or edited
-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:f="http://www.pageseeder.com/function"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                exclude-result-prefixes="#all">

<xsl:import href="_frame.xsl"/>

<!-- Subject and metadata -->
<xsl:template match="notification[@template='new-uri']" mode="meta">
  <meta name="list-id"            content="{group/@name}.{@emaildomain}" />
  <meta name="list-name"          content="{group/@description}" />
  <meta name="list-help"          content="{@hosturl}/page/{group/@name}/home" />
  <meta name="list-unsubscribe"   content="{@hosturl}/email/unsubscribe?group={group/@name}&amp;token={@unsubscribetoken}" />
  <meta name="list-post"          content="{@hosturl}/page/{group/@name}/comment/new" />
  <meta name="list-archive"       content="{@hosturl}/page/{group/@name}/comments" />
  <title>
    <xsl:text>[</xsl:text>
    <xsl:value-of select="group/@name" />
    <xsl:text>] </xsl:text>
    <xsl:value-of select="message/title" />
  </title>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='new-uri']" mode="body">
  <!-- Broadcast All -->
  <xsl:if test="@announcement = 'true'">
    <table class="announcement"><tr><td>This email has been sent to you regardless of your 
    PageSeeder notification settings because it is an announcement.</td></tr></table>
  </xsl:if>
  
  <!-- Contents -->
  <xsl:copy-of select="message/content[@type = 'application/xhtml+xml']/node()" />

  <!-- Labels -->
  <xsl:apply-templates select="message" mode="labels" />

  <!-- Attachments -->
  <xsl:apply-templates select="message" mode="attachments" />

  <xsl:call-template name="noreply"/>  
</xsl:template>


<!-- ====================================================================== -->
<!-- Supporting templates -->
<!-- ====================================================================== -->


<xsl:template match="message" mode="labels">
  <xsl:if test="labels">
    <table cellpadding="0" cellspacing="0" border="0"><tr><td style="text-align:right;font-size:12px">
      <xsl:for-each select="tokenize(labels, ',')">
        <img src="{$images-url}/ico-label.png" alt="Label:" border="0" />
        <span><xsl:value-of select="." /></span>
      </xsl:for-each>
    </td></tr></table>
  </xsl:if>
</xsl:template>

<xsl:template match="message" mode="attachments">
<xsl:if test="attachment/uri">
  <h4 class="subtitle">
    <xsl:choose>
      <xsl:when test="@contentrole='File Upload'">Uploaded documents</xsl:when>
      <xsl:when test="@contentrole='File Creation'">Created document</xsl:when>
      <xsl:when test="@contentrole='URL Creation'">Created URL</xsl:when>
      <xsl:otherwise>Modified URL</xsl:otherwise>
    </xsl:choose>
  </h4>
  <table width="100%" cellpadding="2" cellspacing="0" border="0" style="border-collapse: collapse"><tbody>
    <xsl:for-each select="attachment/uri">
      <tr>
        <td style="width:20px;font-size:13px;"><img src="{$images-url}/{f:media-type-icon(.)}" border="0" alt="" /></td>
        <xsl:variable name="view"     select="concat(/notification/@hosturl, '/page/', ../../../group/@name, '/uri/', @id)" />
        <xsl:variable name="download" select="concat(/notification/@hosturl, '/uri/', @id, '?behavior=download')" />
        <td style="font-size: 13px;"><xsl:sequence select="f:link($view, displaytitle)" /></td>
        <td width="50" style="font-size: 13px;text-align:right">
          <xsl:choose>
            <xsl:when test="@external = 'true'">
              <xsl:sequence select="f:link(f:url(.), 'Website')" />
            </xsl:when>
            <xsl:when test="not(@mediatype = 'folder')">
              <xsl:sequence select="f:link($download, 'Download')" />
            </xsl:when>
          </xsl:choose>
        </td>
      </tr>
    </xsl:for-each>
  </tbody></table>
</xsl:if>
</xsl:template>

<xsl:function name="f:url">
  <xsl:param name="uri" />
  <xsl:value-of select="$uri/@scheme" />
  <xsl:text>://</xsl:text>
  <xsl:value-of select="$uri/@host" />
  <xsl:if test="not($uri/@scheme = 'http' and $uri/@port = '80') and not($uri/@scheme = 'https' and $uri/@port = '443')">
    <xsl:text>:</xsl:text>
    <xsl:value-of select="$uri/@port" />
  </xsl:if>
  <xsl:value-of select="$uri/@path" />
</xsl:function>

</xsl:stylesheet>
