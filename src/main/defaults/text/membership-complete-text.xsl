<?xml version="1.0"?>
<!--
  Template used when a membership has been accepted

  @version 5.8900
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_text.xsl"/>

<xsl:variable name="helpurl" select="if (starts-with(/notification/@helpurl, '/')) then concat(/notification/@hosturl, /notification/@helpurl)
                                else if (string(/notification/@helpurl) != '') then /notification/@helpurl
                                else 'http://user.pageseeder.com'"/>
<xsl:variable name="email-address" select="concat(/notification/membership/(group|project)/@name, '@', /notification/@emaildomain)" />

<xsl:template match="/notification[@template='membership-complete']">
<xsl:variable name="project-group" select="if (membership/project) then 'project' else 'group'"/>
Hi <xsl:value-of select="membership/member/@firstname" />,

<xsl:choose>
  <xsl:when test="inviter">*<xsl:value-of select="inviter/fullname"/>* has added you to <xsl:value-of 
  select="$project-group"/> *<xsl:value-of select="membership/(group|project)/@name" />*.</xsl:when>
  <xsl:otherwise>You have now joined <xsl:value-of select="$project-group"/> *<xsl:value-of 
  select="membership/(group|project)/@name" />*.</xsl:otherwise>
</xsl:choose>

Below is information on the <xsl:value-of select="$project-group"/> you have been registered for:
<xsl:if test="membership/(group|project)/message"><xsl:text>
</xsl:text>
<xsl:value-of select="membership/(group|project)/message" /><xsl:text>
</xsl:text>
</xsl:if>
NOTE: You may need to logout from PageSeeder and login again to gain access.

          NAME:  <xsl:value-of select="membership/(group|project)/@name" />
   DESCRIPTION:  <xsl:value-of select="membership/(group|project)/@description" />
  NOTIFICATION:  <xsl:value-of select="membership/@notification" /><xsl:if test="membership/(group|project)/@homeurl">
     HOME PAGE:  <xsl:value-of select="membership/(group|project)/@homeurl" /></xsl:if>
<xsl:if test="@generalcomments = 'true'">
   GROUP EMAIL:  messages can be sent to this <xsl:value-of select="$project-group"/> by posting
                 to the following address.                
                 mailto:<xsl:value-of select="$email-address" />
</xsl:if>

 READ ME FIRST:  The system powering this <xsl:value-of select="$project-group"/> is called PageSeeder.
                 If you are unfamiliar with PageSeeder please follow
                 the link below for an introduction to its features.
                 <xsl:value-of select="$helpurl"/>

To change your notification settings please visit:
  <xsl:value-of select="concat(@hosturl, '/email/mygroups')" />
</xsl:template>

</xsl:stylesheet>
