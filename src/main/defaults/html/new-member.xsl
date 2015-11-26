<?xml version="1.0"?>
<!-- 
  Email sent to the user after a user is created.
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_frame.xsl"/>

<!-- Metadata -->
<xsl:template match="notification[@template='new-member']" mode="meta">
  <title>Welcome to PageSeeder</title>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='new-member']" mode="body">
  <h3>Hi <xsl:value-of select="member/@firstname" />,</h3>

  <p class="lead">Welcome to PageSeeder at <a href="{@hosturl}"><xsl:value-of 
  select="f:hostname(@hosturl)" /></a>.</p>

  <p>PageSeeder allows groups of people to collaborate on different documents
     available on the site.</p>

  <p>You can login using your email <b><xsl:value-of select="member/@email"/></b>
  <xsl:if test="not(string(member/@username) = '' or member/@username = member/@email)">
    or your username <b><xsl:value-of select="member/@username" /></b>
  </xsl:if>.</p>

  <p>You've been assigned a temporary random password:</p>
  <center><h4><xsl:value-of select="@password" /></h4></center>

  <!-- check if member is activated -->
  <xsl:choose>
    <xsl:when test="member/@status = 'unactivated'">
      <p>You must click on the button below to activate your account before being able to use PageSeeder.
         If you have been assigned a random password you can also change it to something easier for you to remember.</p>
      <p>
        <xsl:variable name="link" select="concat(@hosturl, '/page/nogroup/preferences/mydetails?username=', encode-for-uri(if (member/@username) then member/@username else member/@email), '&amp;key=', encode-for-uri(@key))"/>
        <xsl:sequence select="f:button($link, 'Activate my account')"/>
      </p>
    </xsl:when>
    <xsl:otherwise>
      <p>If you have been assigned a random name or password you can change it to 
      something easier for you to remember.</p>
      <xsl:sequence select="f:button(concat(@hosturl, '/page/nogroup/preferences/mydetails'), 'Update your password')"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
