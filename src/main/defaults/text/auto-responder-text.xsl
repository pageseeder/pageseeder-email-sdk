<?xml version="1.0"?> 
<!-- 
  Auto responder email

  @version 5.8900
-->
<xsl:stylesheet version="2.0"
                xmlns:f="http://www.pageseeder.com/function"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
exclude-result-prefixes="#all">

<xsl:import href="_text.xsl"/>

<xsl:template match="/notification[@template='auto-responder']">
WARNING: The location this comment was sent to has almost reached its auto responder comment limit.
Please wait <xsl:value-of select="autoresponder/@minutes" /> minutes before submitting any more comments to this location.
<xsl:for-each select="comment">
VIEW - this comment in context:
  <xsl:value-of select="f:context-link(context)"/>
  
SUBJECT: <xsl:value-of select="title" />
AUTHOR:  <xsl:value-of select="f:author(author)" />
<xsl:text>

</xsl:text>
<xsl:value-of select="f:comment-content(.)"/>
</xsl:for-each>
</xsl:template>

</xsl:stylesheet>
