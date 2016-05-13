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
<xsl:template match="notification[@template='new-url']" mode="meta">
  <meta name="list-id"            content="{group/@name}.{@emaildomain}" />
  <meta name="list-name"          content="{group/@description}" />
  <meta name="list-help"          content="{@hosturl}/page/{group/@name}/home" />
  <meta name="list-unsubscribe"   content="{@hosturl}/page/{group/@name}/preferences/mygroups" />
  <meta name="list-post"          content="{@hosturl}/page/{group/@name}/comment/new" />
  <meta name="list-archive"       content="{@hosturl}/page/{group/@name}/comments" />
  <title>
    <xsl:text>[</xsl:text>
    <xsl:value-of select="group/@name" />
    <xsl:text>] URL </xsl:text>
    <xsl:value-of select="if (@modified = 'true') then 'Modified' else 'Created'" />
    <xsl:text>: </xsl:text>
    <xsl:value-of select="uri/displaytitle" />
  </title>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='new-url']" mode="body">
  <!-- Broadcast All -->
  <xsl:if test="@announcement = 'true'">
    <table class="announcement"><tr><td>This comment has been sent to you regardless of your 
    PageSeeder notification settings because it is an announcement.</td></tr></table>
  </xsl:if>
  <!-- Contents -->
  <p>
    <xsl:choose>
      <xsl:when test="@modified = 'true'">An existing URL was updated in </xsl:when>
      <xsl:otherwise>A new URL was added to </xsl:otherwise>
    </xsl:choose>
    <xsl:text>the group </xsl:text>
    <b><xsl:value-of select="group/@name" /></b>:
  </p>
  
  <table class="newurl"><tr><td>

    <p><a href="{f:url(uri)}">
      <xsl:choose>
        <xsl:when test="uri/displaytitle"><xsl:value-of select="uri/displaytitle" /></xsl:when>
        <xsl:otherwise><xsl:value-of select="f:url(uri)" /></xsl:otherwise>
      </xsl:choose>
    </a></p>
    
    <!-- Description -->
    <xsl:if test="uri/description"><p><xsl:sequence select="f:text-to-html(uri/description)" /></p></xsl:if>

  </td></tr></table>

  <!-- Labels -->
  <xsl:apply-templates select="uri" mode="labels" />

  <!--  more info -->
  <h4 style="border-top: 1px solid #d7d7d7; padding-top: 4px">More information about this URL</h4>
  <p>You can access this URL <a href="{@hosturl}/page/{group/@name}/uri/{uri/@id}">online</a>.</p>
</xsl:template>


<!-- ====================================================================== -->
<!-- Supporting templates -->
<!-- ====================================================================== -->


<xsl:template match="uri" mode="labels">
  <xsl:if test="string(labels) != ''">
    <br/>
    <table cellpadding="0" cellspacing="0" border="0"><tr><td style="text-align:right;font-size:13px">
      <xsl:for-each select="tokenize(labels, ',')">
        <img src="{$images-url}/ico-label.png" alt="Label:" border="0" />
        <span><xsl:value-of select="." /></span>
      </xsl:for-each>
    </td></tr></table>
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
