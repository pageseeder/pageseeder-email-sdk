<?xml version="1.0"?>
<!--
  Email sent to the user after the limit of "Out of Office" reply messages was reached
  to notify him that its personal preferences have been changed to "On vacation".

  @version 5.8900
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<!-- Common templates for emails -->
<xsl:import href="_frame.xsl"/>

<!-- Subject and metadata -->
<xsl:template match="notification[@template='out-of-office-change']" mode="meta">
  <title>WARNING: Your notification options have been set to 'On Vacation'</title>
</xsl:template>

<!-- Banner -->
<xsl:template match="notification[@template='out-of-office-change']" mode="banner">
  <p wrapper-class="alert-wrap">PageSeeder warning</p>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='out-of-office-change']" mode="body">
  <table class="warning"><tr><td>The string "<b><xsl:value-of select="f:find-string(outofoffice/@string, comment/title)" /></b>" 
  was detected in the subject of your message below.</td></tr></table>

  <p>Your notification options have been automatically set to '<i>On Vacation</i>' because <b><xsl:value-of 
  select="outofoffice/@limit" /></b> 'Out of Office' messages have been received in a row.</p>

  <p>You can change your 'On Vacation' option by visiting <a
    href="{@hosturl}/email/myoptions">your notification options</a>.</p>

  <p>If the message below is a valid message, please change the subject before re-sending it to the group.</p>

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

  <xsl:call-template name="noreply"/>  
</xsl:template>

</xsl:stylesheet>
