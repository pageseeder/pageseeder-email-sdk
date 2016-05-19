<?xml version="1.0"?>
<!--
  Template used when a member has been invited to a group or project

  @version 5.8900
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_text.xsl"/>

<xsl:template match="/notification[@template='membership-confirm']">
Hi <xsl:value-of select="membership/member/@firstname" />,

<xsl:choose>
  <xsl:when test="inviter">*<xsl:value-of select="inviter/fullname"/>* has invited you</xsl:when>
  <xsl:otherwise>You have been invited</xsl:otherwise>
</xsl:choose> to join the <xsl:value-of select="if (membership/project) then 'project' else 'group'
"/> *<xsl:value-of select="membership/(group|project)/@name" />*.

        NAME:  <xsl:value-of select="membership/(group|project)/@name" />
 DESCRIPTION:  <xsl:value-of select="membership/(group|project)/@description" />
      SERVER:  <xsl:value-of select="concat(@hosturl,'/')" />

To respond to this invitation follow the link below:
  <xsl:value-of select="concat(@hosturl, '/email/myinvitation?group=', membership/(group|project)/@name)"/>

Disregard this email, if you do not wish to join.
</xsl:template>

</xsl:stylesheet>
