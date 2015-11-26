<?xml version="1.0"?> 
<!-- 
  Generate the filelist of messages
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes"/>

<xsl:param name="from"/>

<xsl:template match="/">
<filelist>
<xsl:for-each select="collection(concat($from, '?select=*.xml'))">
  <file href="{document-uri()}"/>
</xsl:for-each>
</filelist>
</xsl:template>

</xsl:stylesheet>