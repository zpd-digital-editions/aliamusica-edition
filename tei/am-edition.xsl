<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
	xpath-default-namespace="http://www.tei-c.org/ns/1.0">

	<xsl:output encoding="UTF-8" indent="yes" method="xml" standalone="yes"/>

	<xsl:template match="/">
		<xsl:result-document href="am-edition.xml">
			<xsl:apply-templates select="@* | node()"/>
		</xsl:result-document>
		<xsl:result-document href="am-edition-a.xml">
			<xsl:apply-templates select="@* | node()" mode="a"/>
		</xsl:result-document>
		<xsl:result-document href="am-edition-ab.xml">
			<xsl:apply-templates select="@* | node()" mode="ab"/>
		</xsl:result-document>
		<xsl:result-document href="am-edition-abg.xml">
			<xsl:apply-templates select="@* | node()" mode="abg"/>
		</xsl:result-document>
	</xsl:template>

	<xsl:template match="body" mode="#default">
		<xsl:copy>
			<div xml:id="intro">
				<xsl:copy-of select="id('edition')"/>
				<xsl:copy-of select="id('edition-abgd')"/>
			</div>
			<xsl:apply-templates select="@* | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="body" mode="a">
		<xsl:copy>
			<div xml:id="intro">
				<xsl:copy-of select="id('edition-a')"/>
			</div>
			<xsl:apply-templates select="@* | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="body" mode="ab">
		<xsl:copy>
			<div xml:id="intro">
				<xsl:copy-of select="id('edition-ab')"/>
			</div>
			<xsl:apply-templates select="@* | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="body" mode="abg">
		<xsl:copy>
			<div xml:id="intro">
				<xsl:copy-of select="id('edition-abg')"/>
			</div>
			<xsl:apply-templates select="@* | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="head" mode="a ab abg"/>

	<xsl:template match="p[@source = '#beta']" mode="a"/>
	<xsl:template match="p[@source = '#gamma']" mode="a ab"/>
	<xsl:template match="p[@source = '#delta']" mode="a ab abg"/>

	<xsl:template match="p[@sameAs]" mode="#all">
		<p corresp="{@sameAs}" source="{@source}">
			<xsl:apply-templates select="id(substring-after(@sameAs, '#'))/node()" mode="#current"/>
		</p>
	</xsl:template>

	<xsl:template match="p[@source = '#alpha'][//p[substring(@sameAs, 2) = current()/@xml:id]]" mode="#all"/>

	<xsl:template match="back" mode="#all"/>

	<!-- identity transform -->
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
