<?xml version="1.0"?>
<!--
  This stylesheet provides a set of common templates and functions for use by the email templates.

  @author Christophe Lauret
  @version 24 May 2012
-->
<xsl:stylesheet version="2.0"
        xmlns:f="http://www.pageseeder.com/function"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        exclude-result-prefixes="f">

<!-- Base URL for images -->
<xsl:variable name="images-url"  select="concat('https://ps.pageseeder.com/ps', '/weborganic/email')" />

<!-- ===================================================================================== -->
<!-- Enclosed Message                                                                      -->
<!-- ===================================================================================== -->
<xsl:template name="message">
  <xsl:param name="subject" />
  <xsl:param name="author" />
  <xsl:param name="content" />
  <xsl:param name="uri" />
  <xsl:param name="attachments" />

  <table cellspacing="0" cellpadding="0" class="ps-message">
    <thead>
      <tr>
        <th style="background-color:#e7e7e7;padding:3px;font-size: 16px;"><img src="{$images-url}/ico-comment.png" border="0" /></th>
        <th style="background-color:#e7e7e7;padding:3px;color:#000;font-weight: bold; vertical-align: middle; font-size: 16px; text-align: left;">Original message</th>
      </tr>
    </thead>
    <tbody>
      <tr>
        <th class="ps-message-th">Subject:</th>
        <td class="ps-message-td"><xsl:value-of select="$subject" /></td>
      </tr>
      <xsl:if test="$author">
        <tr>
          <th class="ps-message-th">Author:</th>
          <td class="ps-message-td"><xsl:value-of select="$author" /> (<xsl:value-of select="$author/@email"/>)</td>
        </tr>
      </xsl:if>
      <xsl:if test="$uri">
        <tr>
          <th class="ps-message-th">Document:</th>
          <td class="ps-message-td"><xsl:value-of select="$uri/displaytitle" /></td>
        </tr>
      </xsl:if>
      <xsl:if test="$attachments">
        <tr>
          <th class="ps-message-th">Attachment<xsl:value-of select="if (count($attachments) > 1) then 's' else ''" />:</th>
          <td class="ps-message-td">
            <xsl:for-each select="$attachments">
              <xsl:sequence select="f:link(concat(/notification/@hosturl, '/page/', /notification/group/@name, '/uri/', @id), displaytitle)" />
              <br/>
            </xsl:for-each>
          </td>
        </tr>
      </xsl:if>
      <tr>
        <th class="ps-message-th">Content:</th>
        <td class="ps-message-td">
          <xsl:if test="$content">
            <xsl:analyze-string select="$content" regex="\n" flags="m">
              <xsl:matching-substring><br/></xsl:matching-substring>
              <xsl:non-matching-substring><xsl:value-of select="." /></xsl:non-matching-substring>
            </xsl:analyze-string>
          </xsl:if>
        </td>
     </tr>
    </tbody>
  </table>
</xsl:template>

<!-- ===================================================================================== -->
<!-- Inside Table                                                                          -->
<!--  (icon, width, title and rows may change)                                             -->
<!-- ===================================================================================== -->
<xsl:template name="table">
  <xsl:param name="table-style" select="''" />
  <xsl:param name="title-image">ico-member.png</xsl:param>
  <xsl:param name="title" />
  <xsl:param name="rows" />

  <table cellspacing="0" cellpadding="0" class="ps-table" style="{$table-style}">
    <thead>
      <tr style="background-color:#D8F1FF;background-position:top left;background-repeat:repeat-x;">
        <!-- Icon: Same image, different vertical position -->
        <th style="padding:3px;font-size:16px;text-align:right;"><img src="{$images-url}/{$title-image}" border="0" /></th>
        <th style="padding:3px;color:#000;font-weight: bold; vertical-align: middle; font-size: 16px; text-align: left;">
          <xsl:value-of select="$title" />
        </th>
      </tr>
    </thead>
    <tbody>
      <xsl:for-each select="$rows//row">
        <tr>
          <th class="ps-table-th"><xsl:value-of select="@title" />:</th>
          <td class="ps-table-td"><xsl:sequence select="node()" /></td>
        </tr>
      </xsl:for-each>
    </tbody>
  </table>
</xsl:template>

</xsl:stylesheet>