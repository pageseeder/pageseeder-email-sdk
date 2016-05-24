<?xml version="1.0"?> 
<!-- 
  When a comment has been rejected, this email notifies the sender.

  @version 5.8900
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_frame.xsl"/>

<!-- Subject and metadata -->
<xsl:template match="notification[@template='reject-comment']" mode="meta">
  <title>RETURNED: <xsl:value-of select="comment/title" /></title>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='reject-comment']" mode="body">
  <p>Hi there,</p>

  <p>You have tried to post a message to a private group on PageSeeder.
  Unfortunately PageSeeder could not accept your message. This could be either because:</p>

  <ol>
    <li>You are not an authorised member of this group.</li>
    <li>You have tried to submit this message from a different email address to the one
    that you were originally registered with.</li>
  </ol>

  <p>If you would like to change the email address you use for PageSeeder to <b><xsl:value-of select="comment/author/@email" /></b>, 
  you can do so in your <a href="{@hosturl}/email/mydetails"> personal details</a>.</p>

  <xsl:call-template name="message">
    <xsl:with-param name="subject" select="comment/title" />
    <xsl:with-param name="content" select="comment/content[contains(@type,'text/plain')]" />
    <xsl:with-param name="uri"     select="comment/context/uri" />
  </xsl:call-template>

</xsl:template>

<!-- Footer -->
<xsl:template match="notification[@template='reject-comment']" mode="footer">
  <p>You received this message because you attempted to post a message on 
  <a href="@hosturl"><xsl:value-of select="f:hostname(@hosturl)" /></a>.</p>
  <p>This is an automatically generated email - please do not reply to this email.</p>
</xsl:template>

</xsl:stylesheet>
