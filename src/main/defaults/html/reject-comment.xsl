<?xml version="1.0"?> 
<!-- 
  When a comment has been rejected, this email notifies the sender.
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_frame.xsl"/>

<!-- Subject and metadata -->
<xsl:template match="notification[@template='reject-comment']" mode="meta">
  <title>RETURNED: <xsl:value-of select="comment/title" /></title>
</xsl:template>

<!-- Body content -->
<xsl:template match="notification[@template='reject-comment']" mode="body">
  <p>Hi there,</p>

  <p>You have tried to post a message to a private group on PageSeeder.
  Unfortunately PageSeeder could not accept your message. This could be either because:</p>

  <ol>
    <li>You are not an authorised member of this group.</li>
    <li>You have tried to submit this message from a different email address to the one
    that you were originally registered with.</li>
  </ol>

  <p>To check that your details on this group are set to: <b><xsl:choose>
    <xsl:when test="comment/author/@email">
      <xsl:value-of select="comment/author/@email" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="comment/@authoremail" />
    </xsl:otherwise>
  </xsl:choose></b>, please follow the link below: <br/><a href="{@hosturl}/page/~/preferences/mydetails"
  ><xsl:value-of select="@hosturl"/>/page/~/preferences/mydetails</a></p>

  <p>If you would like to have permission to post from an additional email address,
     please contact the person who originally subscribed you to this group.</p>

  <xsl:call-template name="message">
    <xsl:with-param name="subject" select="comment/title" />
    <xsl:with-param name="content" select="comment/content[contains(@type,'text/plain')]" />
    <xsl:with-param name="uri"     select="comment/context/uri" />
  </xsl:call-template>

  <p class="last">This is an automatically generated email - please do not respond 
  to this email.</p>

</xsl:template>

<xsl:template match="notification[@template='reject-comment']" mode="footer">
 <!-- TODO: text? -->
</xsl:template>

</xsl:stylesheet>
