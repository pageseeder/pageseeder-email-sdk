<?xml version="1.0"?>
<!--
  Template used when a membership needs moderation

  @version 5.8900
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_text.xsl"/>

<xsl:template match="/notification[@template='membership-accept']">
Hi <xsl:value-of select="moderator/@firstname"/>,

Membership in <xsl:value-of select="membership/(group|project)/@name" /> has been configured for moderation
and you have been designated as the *moderator*.

To accept the application of the following person and trigger a confirmation message to them, follow the link below:
  <xsl:value-of select="concat(@hosturl, '/email/moderatemember?group=', membership/(group|project)/@name, '&amp;member=', membership/member/@id)"/>

-----------------------------------------------------------------------
<xsl:for-each select="membership">
<xsl:value-of select="if (project) then 'PROJECT' else 'GROUP'"/>: <xsl:value-of select="(group|project)/@name" />
TITLE: <xsl:value-of select="(group|project)/@description" />

Requested by:

NAME:     <xsl:value-of select="member/fullname" />
EMAIL:    <xsl:value-of select="member/@email" />
USERNAME: <xsl:value-of select="member/@username" />
</xsl:for-each>

To reject the above application, or to defer your decision, simply ignore this message.

This application will remain available under the 'Pending' section of the
Members page until a time that it is either 'Accepted' or 'Permanently Removed'.
</xsl:template>

</xsl:stylesheet>
