<?xml version="1.0"?>
<!-- 
  Email sent to the user after they change their email address.

  @version 5.8900
-->
<xsl:stylesheet version="2.0"
                xmlns:f="http://www.pageseeder.com/function"
              xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
exclude-result-prefixes="#all">

<xsl:import href="_text.xsl"/>

<xsl:template match="/notification[@template='change-email-confirm']">
Hi <xsl:value-of select="member/@firstname" />,

We would like to confirm that you prefer using *<xsl:value-of select="@newemail"/>* as your email for PageSeeder at <xsl:value-of select="concat(@hosturl, '/')" />.

If you do not wish to change your email address and continue using your current email address *<xsl:value-of select="member/@email" />*, simply disregard this email.

Until you confirm this change, you will need to use your current email address to login to PageSeeder.

CONFIRM EMAIL CHANGE:
  <xsl:value-of select="concat(@hosturl, '/email/changeemail?member=', member/@id, '&amp;token=', @token)" />

NOTE: this link will be valid for the next 12 hours.

-----------------------------------------------------------------------
SUMMARY
Old email:  <xsl:value-of select="member/@email" />
New email:  <xsl:value-of select="@newemail" />

</xsl:template>

</xsl:stylesheet>