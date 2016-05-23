<?xml version="1.0"?>
<!--
  Template used when a new member has been created and invited to a group

  @version 5.8900
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_text.xsl"/>

<xsl:template match="/notification[@template='membership-new-member']">
<xsl:variable name="firstname" select="membership/member/@firstname"/>
<xsl:choose>
  <xsl:when test="$firstname!='Member'">Hi <xsl:value-of select="$firstname"/>,</xsl:when>
  <xsl:otherwise>Hi,</xsl:otherwise>
</xsl:choose>

Welcome to PageSeeder at 
  <xsl:value-of select="concat(@hosturl,'/')" />

PageSeeder allows groups of people to collaborate on different documents
available on the site.

<xsl:value-of select="f:reason-for-joining(.)"/>

         NAME:  <xsl:value-of select="membership/(group|project)/@name" />
  DESCRIPTION:  <xsl:value-of select="membership/(group|project)/@description" />

You can login using your email *<xsl:value-of select="membership/member/@email"/>*.
<!-- Check if activated member was invited to group -->
<xsl:if test="membership/member/@status = 'activated' and membership/@status = 'invited'">
To respond to this invitation follow the link below:
  <xsl:value-of select="concat(@hosturl, '/email/myinvitation?group=', membership/(group|project)/@name)"/>

Disregard this email, if you do not wish to join.
</xsl:if>

<!-- Check if member is activated -->
<xsl:if test="membership/member/@status != 'activated'">
You must follow the link below to activate your account before being able to use PageSeeder.
  <xsl:value-of select="concat(@hosturl, '/email/getstarted?member=', membership/member/@id, '&amp;token=', @token)"/>
</xsl:if>

NOTE: this link will be valid for the next 48 hours.
</xsl:template>

<!-- 
  Explain reason for joining.
-->
<xsl:function name="f:reason-for-joining">
<xsl:param name="notification"/>
<xsl:variable name="inviter"    select="$notification/inviter"/>
<xsl:variable name="m"          select="$notification/membership"/>
<xsl:variable name="invitation" select="$m/@status = 'invited'"/>
<xsl:variable name="what"       select="concat(if ($m/project) then 'project *' else 'group *', $m/(group|project)/@name, '*')"/>
<xsl:choose>
  <xsl:when test="$inviter and $invitation"          >*<xsl:value-of select="$inviter/fullname"/>* has invited you to join the <xsl:value-of select="$what" />.</xsl:when>
  <xsl:when test="$inviter and not($invitation)"     >*<xsl:value-of select="$inviter/fullname"/>* has added to the <xsl:value-of  select="$what" />.</xsl:when>
  <xsl:when test="not($inviter) and $invitation"     >You have been invited you to join the <xsl:value-of select="$what" />.</xsl:when>
  <xsl:when test="not($inviter) and not($invitation)">You have been added to the <xsl:value-of select="$what" />.</xsl:when>
</xsl:choose>
</xsl:function>

</xsl:stylesheet>
