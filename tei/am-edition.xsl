<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
	xpath-default-namespace="http://www.tei-c.org/ns/1.0">

	<xsl:output encoding="UTF-8" indent="yes" method="xml" standalone="yes"/>

	<xsl:template match="/">
		<xsl:result-document href="am-about.xml">
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
		<xsl:result-document href="am-edition-abgd.xml">
			<xsl:apply-templates select="@* | node()" mode="abgd"/>
		</xsl:result-document>
		<xsl:result-document href="am-edition-ms.xml">
			<xsl:apply-templates select="@* | node()" mode="ms"/>
		</xsl:result-document>
	</xsl:template>

	<xsl:template match="body" mode="#default">
		<xsl:copy>
			<div xml:id="intro">
				<head>About</head>
				<xsl:copy-of select="id('about')/*"/>
			</div>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="body" mode="a">
		<xsl:copy>
			<div xml:id="intro">
				<head rend="#alpha">Author α</head>
				<xsl:copy-of select="id('edition-a')/*"/>
			</div>
			<xsl:apply-templates select="@* | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="body" mode="ab">
		<xsl:copy>
			<div xml:id="intro">
				<head rend="#beta">Authors α and β</head>
				<xsl:copy-of select="id('edition-ab')/*"/>
			</div>
			<xsl:apply-templates select="@* | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="body" mode="abg">
		<xsl:copy>
			<div xml:id="intro">
				<head rend="#gamma">Authors α, β, and γ</head>
				<xsl:copy-of select="id('edition-abg')/*"/>
			</div>
			<xsl:apply-templates select="@* | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="body" mode="abgd">
		<xsl:copy>
			<div xml:id="intro">
				<head rend="#delta">Authors α, β, γ, and δ</head>
				<xsl:copy-of select="id('edition-abgd')/*"/>
			</div>
			<xsl:apply-templates select="@* | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>
	<xsl:template match="body" mode="ms">
		<xsl:copy>
			<div xml:id="intro">
				<head rend="#delta">Manuscript Order</head>
				<xsl:copy-of select="id('edition-ms')/*"/>
			</div>
			<xsl:apply-templates select="@* | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>

	<!-- display head only in mode ms -->
	<xsl:template match="head" mode="a ab abg abgd"/>

	<!-- ignore other scribes' paragraphs depending on mode -->
	<xsl:template match="p[@source = '#beta']" mode="a"/>
	<xsl:template match="p[@source = '#gamma']" mode="a ab"/>
	<xsl:template match="p[@source = '#delta']" mode="a ab abg"/>

	<!-- abgd: display alpha's paragraphs in position before delta's rearrangement -->
	<xsl:template match="p[@sameAs]" mode="a ab abg abgd">
		<p xml:id="{substring(@sameAs,2)}" source="{@source}" ana="#rearranged">
			<xsl:apply-templates select="id(substring(@sameAs, 2))/node()" mode="#current"/>
		</p>
	</xsl:template>

	<!-- abgd: ignore alpha's paragraphs former position -->
	<xsl:template match="p[@source = '#alpha'][//p[substring(@sameAs, 2) = current()/@xml:id]]" mode="a ab abg abgd"/>

	<!-- identity transform -->
	<xsl:template match="@* | node()" mode="#all">
		<xsl:copy>
			<xsl:apply-templates select="@* | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
