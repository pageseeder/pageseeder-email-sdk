<?xml version="1.0"?>
<!--
  Email sent to the user when an "Out of Office" reply message was detected
  to warn him that its personal preferences will be changed to "On vacation".

  @version 5.8900
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_text.xsl"/>

<!-- Default template -->
<xsl:template match="/notification[@template='out-of-office-warning']">
WARNING: The string "<xsl:value-of select="f:find-string(outofoffice/@string, comment/title)" />" was detected in the subject of your message below.

Your notification options will automatically be set to 'On Vacation' after <xsl:value-of select="outofoffice/@limit" /> such detections.

If the message below is a valid message, please change the subject before re-sending it to the group.
The subject of a message cannot contain the following phrase<xsl:if test="count(tokenize(outofoffice/@string, ',')) &gt; 1">s</xsl:if>: <xsl:value-of select="outofoffice/@string"/>.
<xsl:for-each select="comment">
SUBJECT: <xsl:value-of select="title" />
<xsl:text>

</xsl:text>
<xsl:value-of select="f:comment-content(.)"/>
</xsl:for-each>

----------------------------------------------------------------------
You received this message because you are part of group <xsl:value-of select="group/@name"/>.
If you wish to change your notification settings, you can do so by visiting the unsubscribe page
  <xsl:value-of select="concat(@hosturl, '/email/unsubscribe?group=', group/@name, '&amp;token=', @unsubscribetoken)" />

This is an automatically generated email - please do not reply to this email.
</xsl:template>

</xsl:stylesheet>


