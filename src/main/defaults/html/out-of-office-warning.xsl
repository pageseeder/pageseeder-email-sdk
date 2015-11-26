<?xml version="1.0"?>
<!--
  Email sent to the user when an "Out of Office" reply message was detected
  to warn him that its personal preferences will be changed to "On vacation".
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<!-- Common templates for emails -->
<xsl:import href="_frame.xsl"/>

<!-- Metadata -->
<xsl:template match="notification[@template='out-of-office-warning']" mode="meta">
  <title>WARNING: Out Of Office detected</title>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='out-of-office-warning']" mode="body">
  <table class="warning"><tr><td>The string "<b><xsl:value-of select="f:find-string(outofoffice/@string, comment/title)" /></b>" 
  was detected in the subject of your message below.</td></tr></table>

  <p>Your notification options will automatically be set to '<i>On Vacation</i>' 
  after <b><xsl:value-of select="outofoffice/@limit" /></b> such detections.</p>

  <p>If the message below is a valid message, please change the subject before 
  re-sending it to the group.</p>

  <p>The subject of a message cannot contain the following phrase<xsl:if 
    test="count(tokenize(outofoffice/@string, ',')) &gt; 1">s</xsl:if>:
  <xsl:for-each select="tokenize(outofoffice/@string, ',')">
    <b><xsl:value-of select="normalize-space(.)" /></b>
    <xsl:if test="position() != last()">, </xsl:if>
  </xsl:for-each>.</p>

  <xsl:call-template name="message">
    <xsl:with-param name="subject" select="comment/title" />
    <xsl:with-param name="content" select="comment/content[contains(@type,'text/plain')]" />
  </xsl:call-template>

  <p class="last">This is an automatically generated email - please do not respond 
  to this email.</p>
</xsl:template>

</xsl:stylesheet>


