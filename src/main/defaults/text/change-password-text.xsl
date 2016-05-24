<?xml version="1.0"?> 
<!--
  Template used to produce an email used to let the user know that 
  their password was updated.

  @version 5.8900
-->
<xsl:stylesheet version="2.0"
                xmlns:f="http://www.pageseeder.com/function"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
exclude-result-prefixes="#all">

<xsl:import href="_text.xsl"/>

<xsl:template match="/notification[@template='change-password']">
Hi <xsl:value-of select="member/@firstname" />,

Your *password has been updated* for the following PageSeeder site: 
  <xsl:value-of select="@hosturl" />.

If you changed your password, you can disregard this email. It was only sent to alert you in case you did not make the change yourself.

If you didn't change your password, your account might have been compromised and we recommend that you reset your password as soon as possible.

-----------------------------------------------------------------------
This email has been sent to you because you have an account on <xsl:value-of select="concat(@hosturl, '/')"/>

This is an automatically generated email - please do not reply to this email.
</xsl:template>

</xsl:stylesheet>
