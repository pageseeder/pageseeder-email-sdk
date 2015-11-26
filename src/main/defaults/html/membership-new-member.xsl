<?xml version="1.0"?>
<!--
  Template used when a new member has been created and invited to a group
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_frame.xsl"/>

<!-- Metadata -->
<xsl:template match="notification[@template='membership-new-member']" mode="meta">
  <title>[<xsl:value-of select="membership/(group|project)/@name" />] <xsl:value-of select=" if (membership/project) then 'Project ' else 'Group '"/>
    <xsl:value-of select="if (membership/@status = 'invited') then 'invitation' else 'registration'"/></title>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='membership-new-member']" mode="body">
  <xsl:variable name="firstname" select="membership/member/@firstname"/>
  <h3>
    <xsl:choose>
      <xsl:when test="$firstname!='Member'">Hi <xsl:value-of select="$firstname"/>,</xsl:when>
      <xsl:otherwise>Hi,</xsl:otherwise>
    </xsl:choose>
  </h3>

  <p class="lead">Welcome to PageSeeder at <a href="{@hosturl}"><xsl:value-of select="f:hostname(@hosturl)" /></a>.</p>

  <p>PageSeeder allows groups of people to collaborate on different documents
     available on the site.</p>

  <p>You have been <xsl:value-of select="if (membership/@status = 'invited') then 'invited to join' else 'added to'"
  /> the <xsl:value-of select=" if (membership/project) then 'project ' else 'group '"/><b><xsl:value-of select="membership/(group|project)/@name" /></b>:</p>

  <p>You can login using your email <b><xsl:value-of select="membership/member/@email"/></b>
   and the temporary password below:</p>
  <center><h4><xsl:value-of select="@password" /></h4></center>

  <!-- Check if activated member was invited to group -->
  <xsl:if test="membership/member/@status = 'activated' and membership/@status = 'invited'">
    <xsl:sequence select="f:button(concat(@hosturl, '/page/', membership/(group|project)/@name, '/member/groupdetails?action=accept'), 'Accept the invitation')"/>
    <p style="clear: both; margin-top: 10px"><i>Disregard this email, if you do not wish to join.</i></p>
  </xsl:if>

  <!-- Check if member is activated -->
  <xsl:if test="membership/member/@status = 'unactivated'">
    <p>You must click on the button below to activate your account before being able to use PageSeeder.
      <xsl:if test="membership/@status = 'invited'">
        Finally you should <b>Accept</b> or <b>Decline</b> the invitation on the My Details page.
      </xsl:if>
    </p>
    <xsl:sequence select="f:button(concat(@hosturl, '/page/nogroup/preferences/mydetails?username=', encode-for-uri(membership/member/@username), '&amp;key=', encode-for-uri(@key)), 'Activate your account')"/>
  </xsl:if>
</xsl:template>

<!-- Footer -->
<xsl:template match="notification[@template='membership-new-member']" mode="footer">
  <p>You have received this email because a PageSeeder member created an account for you and 
  invited you to join a group.</p>
  <p>If you have been assigned a random name or password you can change it to something easier 
  for you to remember by visiting <a href="{@hosturl}/page/nogroup/preferences/mydetails">your personal details</a>.</p>
</xsl:template>

</xsl:stylesheet>
