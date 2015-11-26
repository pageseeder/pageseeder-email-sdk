<?xml version="1.0"?>
<!--
  This module defines the common part of emails that need to be modified such
  as the header and footer and variables reused in other templates.

  To modify the styles, update the file `styles.css`  
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="f">

<!-- Host URL (when using SDK not available via /notification when using SDK) -->
<xsl:variable name="host-url"  select="if (/notification/@hosturl) then /notification/@hosturl else 'https://ps.pageseeder.com/ps'"/>

<!-- Base URL for images -->
<xsl:variable name="images-url"  select="concat($host-url, '/weborganic/email')" />

<!-- Header image (may need to be modified during testing before images are available on host) -->
<xsl:variable name="header-image-url"  select="concat($host-url, '/weborganic/email/ps-header-logo.png')" />

<!--
  Default header template
-->
<xsl:template match="notification" mode="header">
<table width="100%" style="width:100%; border-spacing:0; border-collapse: collapse">
  <tr>
    <td style="border-spacing:0">
      <a href="{@hosturl}/" class="header-pslogo" title="PageSeeder"
      ><img src="{$header-image-url}" border="0" alt="" /></a>
    </td>
    <td style="border-spacing:0" align="right">
      <xsl:if test="group and not(group/@name = 'admin') or comment/context/group">
        <xsl:variable name="group" select="if (group) then group else (comment/context/group)[1]"/>
        <h4 class="header-title"><xsl:value-of select="$group/@name"/></h4>
      </xsl:if>
    </td>
  </tr>
</table>
</xsl:template>

<!--
 Default footer template
-->
<xsl:template match="notification" mode="footer">
<xsl:choose>
  <xsl:when test="group and not(group/@name = 'admin') or comment/context/group">
    <xsl:variable name="group" select="if (group) then group else (comment/context/group)[1]"/>
    <p>You received this message because you are part of group <i><xsl:value-of select="$group/@name" /></i>.</p>
    <p>If you wish to change your notification settings, you can do so by visiting <a
      href="{@hosturl}/page/{$group/@name}/preferences/mygroups">your subscription options</a></p>
  </xsl:when>
  <xsl:otherwise>
    <p>This email has been sent to you because you have an account on 
    <a href="{@hosturl}"><xsl:value-of select="f:hostname(@hosturl)"/></a></p>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

</xsl:stylesheet>