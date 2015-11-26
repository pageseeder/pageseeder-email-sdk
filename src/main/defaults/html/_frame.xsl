<?xml version="1.0"?>
<!--
  Define common frame for the templates.
  
  Note: There is no usually reason to modify this module.
-->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:f="http://www.pageseeder.com/function"
                exclude-result-prefixes="#all">

<!-- CSS inliner -->
<xsl:import href="_inliner.xsl"/>

<!-- Common functions used in the templates -->
<xsl:import href="_functions.xsl"/>

<!-- Legacy templates are defined here -->
<xsl:import href="_legacy.xsl"/>

<!-- Legacy templates are defined here -->
<xsl:import href="_custom.xsl"/>

<!-- 
  Default template for all notifications.
  
  This template sets the general structure of the generated HTML.
-->
<xsl:template match="notification" priority="0">
<html>
  <head>
    <!-- Leave these alone -->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/> <!--Media queries on windows phone 8 -->
    <meta name="format-detection" content="telephone=no"/> <!-- Disable auto telephone linking in iOS -->
    <xsl:apply-templates select="." mode="meta"/>
  </head>
  <!-- We generate the content... -->
  <xsl:variable name="body">
    <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
      <xsl:if test="@template='new-comment'">
        <div class="type-above">Type response above.</div>
      </xsl:if>
      <xsl:apply-templates select="." mode="header-wrap"/>
      <xsl:apply-templates select="." mode="banner-wrap"/>
      <xsl:apply-templates select="." mode="body-wrap"/>
      <xsl:apply-templates select="." mode="footer-wrap"/>
    </body>
  </xsl:variable>
  <!-- ... then invoke the CSS inliner -->
  <xsl:sequence select="f:inliner($body)"/>
</html>
</xsl:template>


<!-- ====================================================================== -->
<!-- Default templates -->
<!-- ====================================================================== -->

<!--
  By default, no content for the metadata, banner or content.
-->
<xsl:template match="notification" mode="meta banner content"/>

<!-- ====================================================================== -->
<!-- Wrappers -->
<!-- The templates below are only used to -->
<!-- ====================================================================== -->

<!--
  Default template for the complete header including wrapping
-->
<xsl:template match="notification" mode="header-wrap">
  <xsl:variable name="header" as="node()*">
    <xsl:apply-templates select="." mode="header"/>
  </xsl:variable>
  <xsl:sequence select="f:_wrap('header', $header)"/>
</xsl:template>

<!--
  Default template for the banner including wrapping
-->
<xsl:template match="notification" mode="banner-wrap">
  <xsl:variable name="banner" as="node()*">
    <xsl:apply-templates select="." mode="banner"/>
  </xsl:variable>
  <xsl:sequence select="f:_wrap('banner', $banner)"/>
</xsl:template>

<!--
  Default template for the main content including wrapping
-->
<xsl:template match="notification" mode="body-wrap">
  <xsl:variable name="body" as="node()*">
    <xsl:apply-templates select="." mode="body"/>
  </xsl:variable>
  <xsl:sequence select="f:_wrap('body', $body)"/>
</xsl:template>

<!--
  Default template for the banner including wrapping
-->
<xsl:template match="notification" mode="footer-wrap">
  <xsl:variable name="footer" as="node()*">
    <xsl:apply-templates select="." mode="footer"/>
  </xsl:variable>
  <xsl:sequence select="f:_wrap('footer', $footer)"/>
</xsl:template>

<!-- 
  Wraps content in a table so that it formats properly and consistently.
  
  The content is only wrapped if it is NOT empty.

  To provide more styling options is the first node in the content has 
  the attribute 'wrapper-class' or 'wrapper-style', these overwrite the
  defaults for the wrapping table.
  
  @param name    The name of the part to wrap (e.g. 'footer', 'body', etc...)
  @param content The content to wrap
  
  @return the content wrapped in a table.
-->
<xsl:function name="f:_wrap" as="element(table)?">
<xsl:param name="name"/>
<xsl:param name="content"/>
<xsl:if test="not(empty($content))">
  <table class="{if ($content[1]/@wrapper-class) then $content[1]/@wrapper-class else concat($name,'-wrap')}" 
    border="0" cellpadding="0" cellspacing="0">
    <xsl:for-each select="$content[1]/@wrapper-style">
      <xsl:attribute name="style" select="."/>
    </xsl:for-each>
    <tr>
      <td></td>
      <td class="container">
        <div class="content">
          <table class="content-table">
            <tr>
              <td class="{$name}"><xsl:sequence select="$content"/></td>
            </tr>
          </table>
        </div>
      </td>
      <td></td>
    </tr>
  </table>
</xsl:if>
</xsl:function>

</xsl:stylesheet>
