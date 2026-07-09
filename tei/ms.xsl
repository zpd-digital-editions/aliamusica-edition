<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="xs" version="2.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
	xpath-default-namespace="http://www.tei-c.org/ns/1.0">

	<xsl:output encoding="UTF-8" indent="yes" method="xml" standalone="yes"/>

	<xsl:variable name="sourceDoc" select="substring-after(substring-before(base-uri(), '.xml'), 'tei/')"/>

	<xsl:variable name="ms-m" select="document('ms-m.xml')"/>
	<xsl:variable name="ms-p" select="document('ms-p.xml')"/>

	<xsl:template match="/">
		<xsl:result-document href="{$sourceDoc}-apparatus.xml">
			<xsl:apply-templates select="@* | node()" mode="apparatus"/>
		</xsl:result-document>
		<xsl:result-document href="{$sourceDoc}-glosses.xml">
			<xsl:apply-templates select="@* | node()" mode="glosses"/>
		</xsl:result-document>
		<xsl:result-document href="{$sourceDoc}-sources.xml">
			<xsl:apply-templates select="@* | node()" mode="sources"/>
		</xsl:result-document>
		<xsl:result-document href="{$sourceDoc}-synopsis.xml">
			<xsl:apply-templates select="@* | node()" mode="synopsis"/>
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

	<!-- ignore standOff (sources) -->
	<xsl:template match="standOff" mode="#all"/>

	<!-- ignore back matter (translation) -->
	<xsl:template match="back" mode="#all"/>

	<!-- apparatus -->

	<!-- ignore readings everywhere but in apparatus view -->
	<xsl:template match="app" mode="glosses sources synopsis translation">
		<xsl:apply-templates select="lem" mode="#current"/>
	</xsl:template>
	<xsl:template match="lem" mode="glosses sources synopsis translation">
		<xsl:apply-templates select="@* | node()" mode="#current"/>
	</xsl:template>

	<!-- ignore figure notes everywhere but in apparatus view -->
	<xsl:template match="figure/note" mode="glosses sources synopsis translation"/>

	<!-- glosses -->

	<!-- ignore glosses everywhere but in glosses view -->
	<xsl:template match="add[@type = 'gloss']" mode="apparatus sources synopsis translation"/>

	<!-- source -->

	<!-- parallel view: manuscript / source -->
	<xsl:template match="p" mode="sources">
		<div type="parallel">
			<xsl:copy>
				<xsl:apply-templates select="@* | node()" mode="#current"/>
			</xsl:copy>
			<xsl:variable name="sourceRef" select="
					//standOff/seg[@sameAs = concat('#', current()/@xml:id)]
					/ref"/>
			<xsl:variable name="sourceDoc" select="document($sourceRef/@source)/TEI"/>
			<xsl:variable name="sourceLines" select="
					$sourceRef/@target
					! tokenize(., '\s+')"/>
			<p corresp="concat('#',.)">
				<xsl:for-each select="$sourceLines">
					<seg type="line">
						<xsl:value-of select="$sourceDoc//line[@xml:id = substring(current(), 2)]"/>
					</seg>
				</xsl:for-each>
			</p>
		</div>
	</xsl:template>
	<!-- segment highlighting -->
	<xsl:template match="seg" mode="sources">
		<xsl:copy>
			<xsl:if test="//standOff/seg[contains(@corresp, current()/@xml:id)]">
				<xsl:attribute name="type" select="'source'"/>
			</xsl:if>
			<xsl:apply-templates select="@* | node()" mode="#current"/>
		</xsl:copy>
	</xsl:template>

	<!-- synopsis -->

	<!-- parallel view: manuscript / corresponding sections -->
	<xsl:template match="seg" mode="synopsis">
		<seg type="parallel">
			<xsl:copy>
				<xsl:apply-templates select="@* | node()" mode="#current"/>
			</xsl:copy>
			<!-- get all corresponding sections from other manuscripts -->
			<seg corresp="{concat('#',@xml:id)}">
				<lb source="M"/>
				<xsl:choose>
					<xsl:when test="$ms-m//seg[@xml:id = current()/@xml:id]">
						<xsl:apply-templates select="$ms-m//seg[@xml:id = current()/@xml:id]/node()" mode="#current"/>
					</xsl:when>
					<xsl:otherwise>
						<seg corresp="#">--</seg>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text> </xsl:text>
				<lb source="P"/>
				<xsl:choose>
					<xsl:when test="$ms-p//seg[@xml:id = current()/@xml:id]">
						<xsl:apply-templates select="$ms-p//seg[@xml:id = current()/@xml:id]/node()" mode="#current"/>
					</xsl:when>
					<xsl:otherwise>
						<seg corresp="#">--</seg>
					</xsl:otherwise>
				</xsl:choose>
			</seg>
		</seg>
	</xsl:template>

	<!-- translation -->

	<!-- parallel view: manuscript / translation -->
	<xsl:template match="p" mode="translation">
		<div type="parallel">
			<xsl:copy>
				<xsl:apply-templates select="@* | node()" mode="#current"/>
			</xsl:copy>
			<!-- get translated paragraph -->
			<xsl:copy-of select="//p[substring(@corresp, 2) = current()/@xml:id]"/>
		</div>
	</xsl:template>

</xsl:stylesheet>
