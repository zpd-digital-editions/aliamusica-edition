<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">

	<xsl:output encoding="UTF-8" indent="yes" method="xml" standalone="yes"/>

	<xsl:template match="/">
		<xsl:result-document href="am-insertions.xml">
			<xsl:apply-templates select="@* | node()"/>
		</xsl:result-document>
	</xsl:template>

	<xsl:template match="p[@sameAs]">
		<p corresp="{@sameAs}">
			<xsl:apply-templates select="id(substring-after(@sameAs, '#'))/node()"/>
		</p>
	</xsl:template>

	<xsl:template match="back"/>

	<!-- identity transform -->
	<xsl:template match="@* | node()">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
