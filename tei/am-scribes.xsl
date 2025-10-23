<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns="http://www.tei-c.org/ns/1.0" xpath-default-namespace="http://www.tei-c.org/ns/1.0">

	<xsl:output encoding="UTF-8" indent="yes" method="xml" standalone="yes"/>

	<xsl:template match="/">
		<xsl:for-each select="TEI/teiHeader/fileDesc/sourceDesc/listWit/witness">
			<xsl:variable name="witness" select="concat('#', @xml:id)"/>
			<xsl:result-document href="am-{@xml:id}.xml">
				<xsl:apply-templates select="/TEI" mode="#current">
					<xsl:with-param name="witness" select="$witness"/>
				</xsl:apply-templates>
			</xsl:result-document>
		</xsl:for-each>
	</xsl:template>

	<!-- identity transform -->
	<xsl:template match="@* | node()">
		<xsl:param name="witness"/>
		<xsl:copy>
			<xsl:apply-templates select="@* | node()">
				<xsl:with-param name="witness" select="$witness"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="teiHeader//p">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="text//div[p[@source]]">
		<xsl:param name="witness"/>
		<xsl:if test="p[@source = $witness and not(@sameAs)]">
			<xsl:copy>
				<xsl:apply-templates select="@* | node()">
					<xsl:with-param name="witness" select="$witness"/>
				</xsl:apply-templates>
			</xsl:copy>
		</xsl:if>
	</xsl:template>

	<xsl:template match="text//p[@source and not(@sameAs)]" priority="+1">
		<xsl:param name="witness"/>
		<xsl:if test="@source = $witness">
			<xsl:copy>
				<xsl:apply-templates select="@* | node()"/>
			</xsl:copy>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="text//p"/>

</xsl:stylesheet>
