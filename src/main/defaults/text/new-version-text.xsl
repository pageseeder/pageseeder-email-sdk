<?xml version="1.0"?>
<!-- 
  Email sent to the user after a version is created.

  @version 5.8900
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="#all">

<xsl:import href="_text.xsl"/>

<xsl:template match="/notification[@template='new-version']">
<xsl:if test="@announcement = 'true'">
NOTE: This comment has been sent to you regardless of your PageSeeder notification settings because it is an announcement.

</xsl:if>
A new document version has been created.

<xsl:if test="version/labels">
LABELS: <xsl:value-of select="string-join(tokenize(version/labels, ','), ', ')" />
</xsl:if>

<xsl:value-of select="version/description" />

----------------------------------------------------------------------
DOCUMENT: <xsl:value-of select="uri/displaytitle" />&#xA0;
  <xsl:value-of select="concat(@hosturl, '/page/', group/@name, '/uri/', uri/@id)" />

----------------------------------------------------------------------
You received this message because you are part of group <xsl:value-of select="group/@name"/>.
If you wish to change your notification settings, you can do so by visiting the unsubscribe page
  <xsl:value-of select="concat(@hosturl, '/email/unsubscribe?group=', group/@name, '&amp;token=', @unsubscribetoken)" />

This is an automatically generated email - please do not reply to this email.
</xsl:template>

</xsl:stylesheet>
