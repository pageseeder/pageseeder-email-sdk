<?xml version="1.0"?> 
<!-- 
  When a comment has been rejected, this email notifies the sender.

  @version 5.8900
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_text.xsl"/>

<xsl:template match="/notification[@template='reject-comment']">
Hi there,

You have tried to post a message to a private group on PageSeeder.

Unfortunately PageSeeder could not accept your message. This could be either because:

1) You are not an authorised member of this group.

2) You have tried to submit this message from a different email address to the one that you were originally registered with.

3) You have used --announce in the email address and you are not a group contributor.

4) You have used --preserve in the email address and you are not a group manager.

If you would like to change the email address you use for PageSeeder to *<xsl:value-of select="comment/author/@email" />*, follow the link below:
  <xsl:value-of select="concat(@hosturl, '/email/mydetails')"/>

SUBJECT: <xsl:value-of select="comment/title" />
<xsl:text>

</xsl:text>
<xsl:value-of select="f:comment-content(comment)"/>

----------------------------------------------------------------------
You received this message because you attempted to post a message on <xsl:value-of select="concat(@hosturl, '/')"/>

This is an automatically generated email - please do not reply to this email.
</xsl:template>

</xsl:stylesheet>
