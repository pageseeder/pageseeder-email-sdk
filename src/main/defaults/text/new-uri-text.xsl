<?xml version="1.0"?> 
<!--
  Template used when a URL is created or edited

  @version 5.8900
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_text.xsl"/>

<xsl:template match="/notification[@template='new-uri']">
<xsl:if test="@announcement = 'true'">
NOTE: This email has been sent to you regardless of your PageSeeder notification settings because it is an announcement.
</xsl:if>
<xsl:for-each select="message/labels[text() != '' and text() != ',']">
LABELS: <xsl:value-of select="string-join(tokenize(., ','), ', ')" />
</xsl:for-each>
<xsl:for-each select="message/attachment/uri">
----------------------------------------------------------------------
ATTACHMENT: <xsl:value-of select="displaytitle" />
<xsl:if test="@external='true'"><xsl:text>
            </xsl:text><xsl:value-of select="f:url(.)" />&#xA0;
</xsl:if>
VIEW/DOWNLOAD:
  <xsl:value-of select="concat(/notification/@hosturl, '/page/', ../../../group/@name, '/uri/', @id)" />
</xsl:for-each>
----------------------------------------------------------------------

<xsl:value-of select="message/content" />

----------------------------------------------------------------------
Change my notification preferences:
  <xsl:value-of select="concat(@hosturl, '/email/mygroups')" />

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