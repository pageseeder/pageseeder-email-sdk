<?xml version="1.0"?>
<!-- 
  Email sent to a moderator to accept/reject a comment.

  @version 5.8900
-->
<xsl:stylesheet version="2.0"
                xmlns:f="http://www.pageseeder.com/function"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
exclude-result-prefixes="#all">

<xsl:import href="_text.xsl"/>

<xsl:template match="/notification[@template='accept-comment']">
Hi <xsl:value-of select="comment/assignedto/@firstname"/>,

The comment below has been posted to the group <xsl:value-of select="group/@name" /> that you are moderating.

There are several options for handling this message, they are as follows:

ACCEPT - to accept this message click the link below:
  <xsl:value-of select="concat(@hosturl, '/email/moderatecommment?group=', group/@name, '&amp;comment=', comment/@id)" />

REJECT - to prevent the message from being broadcast to group members
  or lodged in the group archive, you can simply ignore this
  notification.

-----------------------------------------------------------------------
CONTEXT: <xsl:value-of select="f:context(comment/context)"/>
SUBJECT: <xsl:value-of select="comment/title" />
TYPE:    <xsl:value-of select="comment/@contentrole" /><xsl:text>
</xsl:text>
<xsl:if test="comment/attachment">
-----------------------------------------------------------------------</xsl:if>
<xsl:for-each select="comment/attachment">
ATTACHMENT:    <xsl:value-of select="uri/displaytitle" />
VIEW/DOWNLOAD: <xsl:value-of select="f:attachment-link(uri)"/><xsl:text>
</xsl:text>
  </xsl:for-each>
<xsl:if test="comment/attachment">
------------------------------------------------------------------------</xsl:if>
<xsl:text>
</xsl:text>
<xsl:value-of select="f:comment-content(comment)"/>

-----------------------------------------------------------------------
You have been sent this email because you are the moderator of group <xsl:value-of select="group/@name" /> on <xsl:value-of select="concat(@hosturl, '/')"/>

This is an automatically generated email - please do not reply to this email.
</xsl:template>

</xsl:stylesheet>
