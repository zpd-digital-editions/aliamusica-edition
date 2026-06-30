<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
	xpath-default-namespace="http://www.tei-c.org/ns/1.0">

	<xsl:output encoding="UTF-8" indent="yes" method="xml" standalone="yes"/>
	
	<xsl:variable name="sourceDoc" select="substring-after(substring-before(base-uri(),'.xml'),'tei/')"/>

	<xsl:template match="/">
		<xsl:result-document href="{$sourceDoc}-edition.xml">
			<xsl:apply-templates select="@* | node()" mode="edition"/>
		</xsl:result-document>
		<xsl:result-document href="{$sourceDoc}-glosses.xml">
			<xsl:apply-templates select="@* | node()" mode="glosses"/>
		</xsl:result-document>
		<xsl:result-document href="{$sourceDoc}-sources.xml">
			<xsl:apply-templates select="@* | node()" mode="sources"/>
		</xsl:result-document>
		<xsl:result-document href="{$sourceDoc}-translation.xml">
			<xsl:apply-templates select="@* | node()" mode="translation"/>
		</xsl:result-document>
	</xsl:template>

	<!-- identity transform -->
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>

	<!-- base text -->
	<xsl:template match="body" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>

	<!-- apparatus -->
	<xsl:template match="app" mode="sources translation glosses"/>

	<!-- glosses -->
	<xsl:template match="seg[@type = 'glossed']/add[@type = 'gloss']" mode="edition sources translation"/>

	<!-- translation -->
	<xsl:template match="p" mode="translation">
		<div type="parallel">
			<xsl:copy>
				<xsl:apply-templates select="@* | node()" mode="#current"/>
			</xsl:copy>
			<xsl:copy-of select="//p[substring(@corresp, 2) = current()/@xml:id]"/>
		</div>
	</xsl:template>
	<xsl:template match="back" mode="#all"/>

	<!-- source -->
	<xsl:template match="standOff" mode="sources">
		<div type="parallel">
			<xsl:copy>
				<xsl:apply-templates select="@* | node()" mode="#current"/>
			</xsl:copy>
			<xsl:copy-of select="//zone[substring(@corresp, 2) = current()/@xml:id]"/>
		</div>
	</xsl:template>
	<xsl:template match="standOff" mode="edition glosses translation"/>

</xsl:stylesheet>
