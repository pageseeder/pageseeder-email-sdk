<?xml version="1.0"?> 
<!-- 
  Email sent to a moderator to accept/reject a comment.
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_frame.xsl"/>

<!-- Metadata -->
<xsl:template match="notification[@template='accept-comment']" mode="meta">
  <title>[<xsl:value-of select="group/@name" />]* <xsl:value-of select="comment/title" /></title>
</xsl:template>

<xsl:template match="notification[@template='accept-comment']" mode="banner">
  <p wrapper-class="moderation-wrap">PageSeeder moderation</p>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='accept-comment']" mode="body">
  <h3>Hi <xsl:value-of select="comment/assignedto/@firstname"/>,</h3>

  <p>The message below has been posted to the group <b><xsl:value-of select="group/@name" /></b> 
  that you are moderating.</p>

  <xsl:call-template name="message">
    <xsl:with-param name="subject"     select="comment/title" />
    <xsl:with-param name="author"      select="comment/author" />
    <xsl:with-param name="content"     select="comment/content[contains(@type,'text/plain')]" />
    <xsl:with-param name="uri"         select="comment/context/uri" />
    <xsl:with-param name="attachments" select="comment/attachment/uri" />
  </xsl:call-template>

  <xsl:sequence select="f:button(concat(@hosturl, '/fullpage/', group/@name, '/comment/', comment/@id, '/moderate'), 'Accept')"/>

  <p class="last">Disregard this email, if you wish to prevent the message from being broadcast
   to group members or lodged in the group archive.</p>
</xsl:template>

<!-- Footer -->
<xsl:template match="notification[@template='accept-comment']" mode="footer">
  <p>You have been sent this email because you are a moderator of a group.</p>
</xsl:template>


</xsl:stylesheet>
