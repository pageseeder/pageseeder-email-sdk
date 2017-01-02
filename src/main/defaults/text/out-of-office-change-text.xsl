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

<xsl:import href="_text.xsl"/>

<xsl:template match="/notification[@template='out-of-office-change']">
WARNING: The string "<xsl:value-of select="f:find-string(outofoffice/@string, comment/title)" />" was detected in the subject of your message below.

Your notification options have been automatically set to 'On Vacation' because <xsl:value-of select="outofoffice/@limit" /> 'out of office' messages have been received in a row.

You can change your 'On Vacation' option by visiting the following link:
  <xsl:value-of select="concat(@hosturl, '/email/myoptions')" />
<xsl:for-each select="comment">

If the message below is a valid message, please change the subject before re-sending it to the group.
The subject of a message cannot contain the following phrase <xsl:if test="count(tokenize(../outofoffice/@string, ',')) &gt; 1">s</xsl:if>: <xsl:value-of select="../outofoffice/@string"/>.

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
