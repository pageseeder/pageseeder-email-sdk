<?xml version="1.0"?> 
<!-- 
  Auto responder email
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_frame.xsl"/>

<!-- Subject and metadata -->
<xsl:template match="notification[@template='auto-responder']" mode="meta">
  <title>WARNING: Comment limit reached</title>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='auto-responder']" mode="body">
  <table class="warning"><tr><td>WARNING: The location this comment was sent to has almost reached 
  the maximum allowed within <xsl:value-of select="autoresponder/@minutes" /> minutes.</td></tr></table>

  <p>Please wait <b><xsl:value-of select="autoresponder/@minutes" /></b> minutes before 
  submitting any more comments to this location.</p>

  <xsl:call-template name="message">
    <xsl:with-param name="subject"     select="comment/title" />
    <xsl:with-param name="author"      select="comment/author" />
    <xsl:with-param name="content"     select="comment/content" />
  </xsl:call-template>

  <!-- More info -->
  <xsl:variable name="link" select="if (comment/context/group)
        then concat(@hosturl, '/page/', comment/context/group/@name, '/comments')
        else concat(@hosturl, '/page/uri/', comment/context/uri/@id)"/>
  <p>View this comment in <a href="{$link}">context</a>.</p>

  <p class="last">This is an automatically generated email - please do not respond to this email.</p>
</xsl:template>

<!-- Footer -->
<xsl:template match="notification[@template='auto-responder']" mode="footer">
  <p>You received this message because you attempted to post a 
  message on <a href="@hosturl"><xsl:value-of select="f:hostname(@hosturl)" /></a>.</p>
</xsl:template>

</xsl:stylesheet>
