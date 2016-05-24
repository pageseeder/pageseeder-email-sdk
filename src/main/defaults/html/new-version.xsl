<?xml version="1.0"?>
<!--
  Email sent to the user after a version is created.
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_frame.xsl"/>

<!-- Subject and metadata -->
<xsl:template match="notification[@template='new-version']" mode="meta">
  <meta name="list-id"            content="{group/@name}.{@hosturl}" />
  <meta name="list-name"          content="{group/@description}" />
  <meta name="list-help"          content="{@hosturl}/page/{group/@name}/home" />
  <meta name="list-unsubscribe"   content="{@hosturl}/email/mygroups" />
  <meta name="list-post"          content="{@hosturl}/page/{group/@name}/comment/new" />
  <meta name="list-archive"       content="{@hosturl}/page/{group/@name}/comments" />
  <title>
    <xsl:text>[</xsl:text>
    <xsl:value-of select="group/@name" />
    <xsl:text>] </xsl:text>
    <xsl:value-of select="uri/displaytitle" />
    <xsl:text> version </xsl:text>
    <xsl:value-of select="version/@name" />
  </title>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='new-version']" mode="body">
  <!-- Broadcast All -->
  <xsl:if test="@announcement = 'true'">
    <table class="announcement"><tr><td>This comment has been sent to you regardless of your 
    PageSeeder notification settings because it is an announcement.</td></tr></table>
  </xsl:if>

  <p class="lead">A new document version has been created.</p>

  <!-- Document Context -->
  <xsl:apply-templates select="version" mode="context" />

  <!-- Contents -->
  <xsl:for-each select="tokenize(version/description, '\n')"><xsl:copy-of select="f:linkify(.)" /><br/></xsl:for-each>

  <!-- Labels -->
  <xsl:apply-templates select="version" mode="labels" />

</xsl:template>

<!-- ====================================================================== -->
<!-- Supporting templates -->
<!-- ====================================================================== -->

<xsl:template match="version" mode="context">
  <table width="100%" cellpadding="0" cellspacing="0" border="0" style="height: 20px; border-bottom: 1px solid #d7d7d7;margin-bottom:10px">
    <tr><td style="font-size:13px;text-align:right;padding-bottom:4px;">
      <img src="{$images-url}/{f:media-type-icon(../uri)}" style="vertical-align: bottom;" border="0" />
      <b>Document: </b>
      <xsl:sequence select="f:link(concat(/notification/@hosturl, '/page/', ../group/@name, '/uri/', ../uri/@id), ../uri/displaytitle)" />
    </td></tr>
  </table>
</xsl:template>

<xsl:template match="version" mode="labels">
  <xsl:if test="labels">
    <table cellpadding="0" cellspacing="0" border="0"><tr><td style="text-align:right;font-size:13px">
      <xsl:for-each select="tokenize(labels, ',')">
        <img src="{$images-url}/ico-label.png" alt="Label:" border="0" />
        <span><xsl:value-of select="." /></span>
      </xsl:for-each>
    </td></tr></table>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
