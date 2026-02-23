---
name: jasper-helper
description: helper for JasperReports migration.
---

# JasperReports 7 Migration Guide (JacksonReportLoader Format)

## ⚠️ CRITICAL: DynamicJasper Uses Different XML Format

When using **DynamicJasper with JasperReports 7**, reports are loaded using `JacksonReportLoader` which expects a **completely different XML format** than the standard XSD schema format documented in JasperReports official documentation.

**DO NOT follow standard JasperReports 7 XSD migration guides** - they will not work with DynamicJasper!

## Successfully Migrated Files

✅ **FisaReportDefaultTemplate.jrxml** - Working reference implementation  
✅ **FisaReportBlankTemplate.jrxml**  
✅ **FisaReportDefaultTemplate_sub.jrxml**

## Quick Reference: Key Differences

| Feature | Standard JR7 XSD | JacksonReportLoader (DynamicJasper) |
|---------|------------------|-------------------------------------|
| Namespace | Required | ❌ NOT allowed |
| Root element | `<jasperReport xmlns="...">` | `<jasperReport>` (no xmlns) |
| Alignment | `hAlign`, `vAlign` | `hTextAlign`, `vTextAlign` |
| Font bold | `isBold="true"` | `bold="true"` |
| Parameter | `isForPrompting` | `forPrompting` |
| TextField | `isBlankWhenNull` | `blankWhenNull` |
| Elements | `<staticText>`, `<textField>`, etc. | `<element kind="staticText">`, etc. |
| Element structure | Nested `<reportElement>`, `<textElement>` | Flat - all attributes on `<element>` |
| Expressions | `<textFieldExpression>`, `<imageExpression>` | `<expression>` for both |
| Detail section | `<detail height="...">` | `<detail><band height="..."/></detail>` |

## Complete Migration Rules

### 1. NO Namespace Declarations

**❌ WRONG (Standard XSD):**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<jasperReport xmlns="http://jasperreports.sourceforge.net/jasperreports" 
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
              xsi:schemaLocation="...">
```

**✅ CORRECT (JacksonReportLoader):**
```xml
<?xml version="1.0" encoding="UTF-8"?>
<jasperReport name="Report" pageWidth="842" pageHeight="1190" ...>
```

### 2. Attribute Name Changes

#### Style Attributes:
- `hAlign` → `hTextAlign`
- `vAlign` → `vTextAlign`
- `hImageAlign`, `vImageAlign` (for images - keep as is)
- `isBold` → `bold`
- `isItalic` → `italic`
- `isUnderline` → `underline`
- `isStrikeThrough` → `strikeThrough`

#### Parameter Attributes:
- `isForPrompting` → `forPrompting`

#### TextField Attributes:
- `isBlankWhenNull` → `blankWhenNull`

#### JasperReport Root Attributes:
- `isTitleNewPage` → `titleNewPage`
- `isSummaryNewPage` → `summaryNewPage`

#### Style Attributes:
- `isDefault` → `default`
- `isStyledText` → NOT supported (remove this attribute)

#### Import Statements:
```xml
<import value="net.sf.jasperreports.engine.*"/>
<import value="java.util.*"/>
<import value="net.sf.jasperreports.engine.data.*"/>
```

### 3. Band Structure

**Most sections** (title, pageHeader, columnHeader, columnFooter, pageFooter, lastPageFooter, summary, background):
- Attributes go directly on the section tag
- No `<band>` wrapper

**❌ WRONG:**
```xml
<title>
    <band height="108" splitType="Stretch">
        ...
    </band>
</title>
```

**✅ CORRECT:**
```xml
<title height="108" splitType="Stretch">
    ...
</title>
```

**EXCEPTION - Detail section** requires `<band>` wrapper:
```xml
<detail>
    <band height="94" splitType="Stretch">
        <element kind="...">...</element>
    </band>
</detail>
```

### 4. Element Structure - Completely Flattened

All report elements use `<element kind="...">` with ALL attributes directly on the element tag.

**❌ WRONG (Standard XSD):**
```xml
<staticText>
    <reportElement key="text-1" x="10" y="10" width="100" height="20" uuid="..."/>
    <textElement textAlignment="Center">
        <font size="14" isBold="true" pdfFontName="Helvetica-Bold"/>
    </textElement>
    <text><![CDATA[Hello]]></text>
</staticText>
```

**✅ CORRECT (JacksonReportLoader):**
```xml
<element kind="staticText" key="text-1" x="10" y="10" width="100" height="20" uuid="..." 
         hTextAlign="Center" fontSize="14" bold="true" pdfFontName="Helvetica-Bold">
    <text><![CDATA[Hello]]></text>
</element>
```

#### Element Kind Values:
- `kind="staticText"` - static text labels
- `kind="textField"` - dynamic text fields
- `kind="line"` - horizontal/vertical lines
- `kind="rectangle"` - rectangles
- `kind="ellipse"` - ellipses/circles
- `kind="image"` - images
- `kind="subreport"` - subreports
- `kind="chart"` - charts
- `kind="frame"` - frames/containers

#### All Attributes Go on `<element>` Tag:

**Position & Size:**
- `x`, `y`, `width`, `height`
- `key` - element identifier (optional)
- `uuid` - unique identifier (required)

**Appearance:**
- `mode` - Opaque/Transparent
- `forecolor`, `backcolor` - colors (e.g., "#FFFFFF")

**Text Alignment (for text elements):**
- `hTextAlign` - Left/Center/Right/Justified
- `vTextAlign` - Top/Middle/Bottom

**Image Alignment (for images):**
- `hImageAlign` - Left/Center/Right
- `vImageAlign` - Top/Middle/Bottom

**Font Properties (for text elements):**
- `fontName` - font family (e.g., "Arial")
- `fontSize` - font size (e.g., "12")
- `bold` - true/false
- `italic` - true/false
- `underline` - true/false
- `strikeThrough` - true/false
- `pdfFontName` - PDF font name (e.g., "Helvetica-Bold")
- `pdfEncoding` - PDF encoding
- `pdfEmbedded` - true/false

**TextField Specific:**
- `blankWhenNull` - true/false
- `pattern` - format pattern (e.g., "dd/MM/yyyy")
- `evaluationTime` - Now/Report/Page/Group/etc.
- `patternExpression` - dynamic pattern

**Layout:**
- `positionType` - Float/FixRelativeToTop/FixRelativeToBottom
- `stretchType` - NoStretch/RelativeToTallestObject/RelativeToBandHeight
- `printRepeatedValues` - true/false
- `removeLineWhenBlank` - true/false
- `printInFirstWholeBand` - true/false
- `printWhenDetailOverflows` - true/false

**Style:**
- `style` - reference to style name
- `styleExpression` - dynamic style reference

**Other:**
- `rotation` - None/Left/Right/UpsideDown
- `markup` - none/styled/html/rtf

#### Child Elements (Kept Inside `<element>`):

**✅ KEEP these nested elements:**
- `<text>` - for staticText content
- `<expression>` - for textField expressions AND image paths
- `<box>` - for borders with nested `<topPen>`, `<leftPen>`, `<bottomPen>`, `<rightPen>`
- `<pen>` - for line styling (inside `<box>` or styles)
- `<paragraph>` - for paragraph formatting
- `<printWhenExpression>` - conditional printing
- `<patternExpression>` - dynamic pattern for textFields
- `<anchorNameExpression>` - for hyperlink anchors
- `<hyperlinkReferenceExpression>` - for hyperlinks
- `<hyperlinkTooltipExpression>` - for hyperlink tooltips

**❌ REMOVE these - move attributes to `<element>`:**
- `<reportElement>` - all attributes go on `<element>`
- `<textElement>` - all attributes go on `<element>`
- `<font>` - all attributes go on `<element>`
- `<graphicElement>` - all attributes go on `<element>`
- `<imageExpression>` - use `<expression>` instead
- `<textFieldExpression>` - use `<expression>` instead

### 5. Expression Tags

**Use `<expression>` for ALL expressions:**
- TextFields: `<expression><![CDATA[...]]></expression>`
- Images: `<expression><![CDATA[...]]></expression>`

**❌ DO NOT USE:**
- `<textFieldExpression>` 
- `<imageExpression>`

### 6. Box Element (Borders)

Box elements can be kept for complex borders:

```xml
<element kind="textField" key="field1" x="10" y="10" width="100" height="20" uuid="...">
    <box>
        <topPen lineWidth="1.0" lineStyle="Solid" lineColor="#000000"/>
        <leftPen lineWidth="1.0" lineStyle="Solid" lineColor="#000000"/>
        <bottomPen lineWidth="1.0" lineStyle="Solid" lineColor="#000000"/>
        <rightPen lineWidth="1.0" lineStyle="Solid" lineColor="#000000"/>
    </box>
    <expression><![CDATA[$F{fieldName}]]></expression>
</element>
```

### 7. Styles

Styles use the same attribute naming:

```xml
<style name="HeaderStyle" 
       hTextAlign="Center" 
       vTextAlign="Middle" 
       fontName="Arial" 
       fontSize="12" 
       bold="true" 
       italic="false"
       underline="false"
       strikeThrough="false"
       forecolor="#000000"
       backcolor="#CCCCCC"
       mode="Opaque">
    <box>
        <pen lineWidth="1.0" lineStyle="Solid"/>
    </box>
</style>
```

## Complete Working Example

```xml
<?xml version="1.0" encoding="UTF-8"?>
<jasperReport name="Report" pageWidth="842" pageHeight="1190" columnWidth="782" 
              leftMargin="30" rightMargin="30" topMargin="20" bottomMargin="20" 
              uuid="078ed3c9-6195-4f23-8b09-8aec12819ae6">
    <property name="ireport.encoding" value="UTF-8"/>
    <import value="net.sf.jasperreports.engine.*"/>
    <import value="java.util.*"/>
    <import value="net.sf.jasperreports.engine.data.*"/>
    
    <style name="HEADER" hTextAlign="Center" vTextAlign="Middle" 
           fontName="Arial" fontSize="12" bold="true"/>
    
    <parameter name="REPORT_PATH" class="java.lang.String" forPrompting="false"/>
    <parameter name="REPORT_TITLE" class="java.lang.String" forPrompting="false"/>
    
    <background height="0" splitType="Stretch"/>
    
    <title height="80" splitType="Stretch">
        <element kind="staticText" key="title-1" x="200" y="10" width="400" height="30" 
                 uuid="a1b2c3d4-e5f6-7890-1234-567890abcdef" 
                 hTextAlign="Center" fontSize="16" bold="true">
            <text><![CDATA[Report Title]]></text>
        </element>
        <element kind="image" key="logo" x="10" y="10" width="100" height="50" 
                 uuid="b2c3d4e5-f6a7-8901-2345-67890abcdef1">
            <expression><![CDATA[$P{REPORT_PATH} + "logo.gif"]]></expression>
        </element>
        <element kind="textField" key="date" x="650" y="10" width="130" height="20" 
                 uuid="c3d4e5f6-a7b8-9012-3456-7890abcdef12" 
                 pattern="dd/MM/yyyy HH:mm" blankWhenNull="false">
            <expression><![CDATA[new Date()]]></expression>
        </element>
    </title>
    
    <pageHeader height="30" splitType="Stretch">
        <element kind="line" key="line-1" x="0" y="25" width="782" height="1" 
                 uuid="d4e5f6a7-b8c9-0123-4567-890abcdef123"/>
    </pageHeader>
    
    <columnHeader height="20" splitType="Stretch">
        <element kind="staticText" key="col1" x="0" y="0" width="100" height="20" 
                 uuid="e5f6a7b8-c9d0-1234-5678-90abcdef1234" 
                 hTextAlign="Center" bold="true">
            <text><![CDATA[Column 1]]></text>
        </element>
    </columnHeader>
    
    <detail>
        <band height="20" splitType="Stretch">
            <element kind="textField" key="field1" x="0" y="0" width="100" height="20" 
                     uuid="f6a7b8c9-d0e1-2345-6789-0abcdef12345" 
                     blankWhenNull="true">
                <expression><![CDATA[$F{fieldName}]]></expression>
            </element>
        </band>
    </detail>
    
    <columnFooter height="20" splitType="Stretch">
        <element kind="line" key="line-2" x="0" y="0" width="782" height="1" 
                 uuid="a7b8c9d0-e1f2-3456-7890-abcdef123456"/>
    </columnFooter>
    
    <pageFooter height="20" splitType="Stretch">
        <element kind="textField" key="pageNum" x="700" y="5" width="80" height="15" 
                 uuid="b8c9d0e1-f2a3-4567-8901-bcdef1234567" 
                 blankWhenNull="false" hTextAlign="Right">
            <expression><![CDATA["Page " + $V{PAGE_NUMBER}]]></expression>
        </element>
    </pageFooter>
    
    <lastPageFooter height="20" splitType="Stretch"/>
    
    <summary height="50" splitType="Stretch"/>
</jasperReport>
```

## Step-by-Step Migration Process

### Step 1: Backup Original File
```bash
cp original.jrxml original.jrxml.backup
```

### Step 2: Remove Namespace Declarations
Remove from `<jasperReport>` tag:
- `xmlns="..."`
- `xmlns:xsi="..."`
- `xsi:schemaLocation="..."`

### Step 3: Update Imports
Change:
```xml
<import>net.sf.jasperreports.engine.*</import>
```
To:
```xml
<import value="net.sf.jasperreports.engine.*"/>
```

### Step 4: Update Attribute Names in Styles
- `hAlign` → `hTextAlign`
- `vAlign` → `vTextAlign`
- `isBold` → `bold`
- `isItalic` → `italic`
- `isUnderline` → `underline`
- `isStrikeThrough` → `strikeThrough`

### Step 5: Update Parameter Attributes
- `isForPrompting` → `forPrompting`

### Step 6: Flatten Band Structure
Remove `<band>` wrappers from all sections EXCEPT `<detail>`:

**Before:**
```xml
<title>
    <band height="100" splitType="Stretch">
        ...
    </band>
</title>
```

**After:**
```xml
<title height="100" splitType="Stretch">
    ...
</title>
```

**Detail section keeps band:**
```xml
<detail>
    <band height="20" splitType="Stretch">
        ...
    </band>
</detail>
```

### Step 7: Convert Elements to Flattened Structure

For each element (staticText, textField, image, line, etc.):

1. **Wrap with `<element kind="...">`**
2. **Move ALL attributes from nested tags to `<element>`**
3. **Remove wrapper tags**

**Before:**
```xml
<staticText>
    <reportElement key="text1" x="10" y="10" width="100" height="20" uuid="..."/>
    <textElement textAlignment="Center">
        <font size="14" isBold="true"/>
    </textElement>
    <text><![CDATA[Hello]]></text>
</staticText>
```

**After:**
```xml
<element kind="staticText" key="text1" x="10" y="10" width="100" height="20" uuid="..." 
         hTextAlign="Center" fontSize="14" bold="true">
    <text><![CDATA[Hello]]></text>
</element>
```

### Step 8: Convert Expression Tags

Replace:
- `<textFieldExpression>` → `<expression>`
- `<imageExpression>` → `<expression>`

### Step 9: Update TextField Attributes
- `isBlankWhenNull` → `blankWhenNull`

### Step 10: Remove graphicElement Wrappers
For lines, remove `<graphicElement>` and move attributes to `<element>`.

### Step 11: Validate XML
```bash
xmllint --noout yourfile.jrxml
```

### Step 12: Test Report
Deploy and test the report with actual data.

## Common Migration Patterns

### Pattern 1: Static Text with Formatting
**Before:**
```xml
<staticText>
    <reportElement x="0" y="0" width="200" height="30" uuid="..."/>
    <textElement textAlignment="Center" verticalAlignment="Middle">
        <font fontName="Arial" size="16" isBold="true" pdfFontName="Helvetica-Bold"/>
    </textElement>
    <text><![CDATA[Title Text]]></text>
</staticText>
```

**After:**
```xml
<element kind="staticText" x="0" y="0" width="200" height="30" uuid="..." 
         hTextAlign="Center" vTextAlign="Middle" fontName="Arial" fontSize="16" 
         bold="true" pdfFontName="Helvetica-Bold">
    <text><![CDATA[Title Text]]></text>
</element>
```

### Pattern 2: TextField with Pattern
**Before:**
```xml
<textField pattern="dd/MM/yyyy" isBlankWhenNull="true">
    <reportElement x="100" y="10" width="150" height="20" uuid="..."/>
    <textElement textAlignment="Right"/>
    <textFieldExpression><![CDATA[$F{date}]]></textFieldExpression>
</textField>
```

**After:**
```xml
<element kind="textField" x="100" y="10" width="150" height="20" uuid="..." 
         pattern="dd/MM/yyyy" blankWhenNull="true" hTextAlign="Right">
    <expression><![CDATA[$F{date}]]></expression>
</element>
```

### Pattern 3: Image
**Before:**
```xml
<image>
    <reportElement x="10" y="10" width="100" height="50" uuid="..."/>
    <imageExpression><![CDATA[$P{LOGO_PATH}]]></imageExpression>
</image>
```

**After:**
```xml
<element kind="image" x="10" y="10" width="100" height="50" uuid="...">
    <expression><![CDATA[$P{LOGO_PATH}]]></expression>
</element>
```

### Pattern 4: Line
**Before:**
```xml
<line>
    <reportElement x="0" y="20" width="500" height="1" uuid="..."/>
    <graphicElement>
        <pen lineWidth="2.0" lineStyle="Solid"/>
    </graphicElement>
</line>
```

**After:**
```xml
<element kind="line" x="0" y="20" width="500" height="1" uuid="..."/>
```

Or with pen styling:
```xml
<element kind="line" x="0" y="20" width="500" height="1" uuid="...">
    <pen lineWidth="2.0" lineStyle="Solid"/>
</element>
```

### Pattern 5: TextField with Box (Border)
**Before:**
```xml
<textField isBlankWhenNull="false">
    <reportElement x="50" y="50" width="100" height="30" uuid="..."/>
    <box>
        <topPen lineWidth="1.0"/>
        <leftPen lineWidth="1.0"/>
        <bottomPen lineWidth="1.0"/>
        <rightPen lineWidth="1.0"/>
    </box>
    <textElement textAlignment="Center"/>
    <textFieldExpression><![CDATA[$V{PAGE_NUMBER}]]></textFieldExpression>
</textField>
```

**After:**
```xml
<element kind="textField" x="50" y="50" width="100" height="30" uuid="..." 
         blankWhenNull="false" hTextAlign="Center">
    <box>
        <topPen lineWidth="1.0"/>
        <leftPen lineWidth="1.0"/>
        <bottomPen lineWidth="1.0"/>
        <rightPen lineWidth="1.0"/>
    </box>
    <expression><![CDATA[$V{PAGE_NUMBER}]]></expression>
</element>
```

## Troubleshooting

### Error: "Unrecognized field 'xmlns'"
**Cause:** Namespace declarations present  
**Fix:** Remove all `xmlns` attributes from `<jasperReport>`

### Error: "Unrecognized field 'hAlign'"
**Cause:** Using old attribute names  
**Fix:** Change to `hTextAlign`, `vTextAlign`

### Error: "Unrecognized field 'isBold'"
**Cause:** Using old boolean attribute names  
**Fix:** Change to `bold`, `italic`, `underline`, `strikeThrough`

### Error: "Unrecognized field 'band'"
**Cause:** Band wrapper in wrong section  
**Fix:** Remove `<band>` wrapper except in `<detail>` section

### Error: "Unrecognized field 'staticText'"
**Cause:** Nested element structure  
**Fix:** Flatten - move all attributes to `<element kind="staticText">`

### Error: "Unrecognized field 'textElement'"
**Cause:** Nested textElement tag  
**Fix:** Move attributes directly to `<element>` tag

### Error: "Unrecognized field 'textFieldExpression'"
**Cause:** Using specific expression tag  
**Fix:** Change to generic `<expression>` tag

### Error: "Unrecognized field 'imageExpression'"
**Cause:** Using specific expression tag  
**Fix:** Change to generic `<expression>` tag

### Error: "Unrecognized field 'graphicElement'"
**Cause:** Using `<graphicElement>` wrapper inside line elements  
**Fix:** Remove `<graphicElement>` tag completely from line elements. Lines don't support this nested element in JacksonReportLoader format.

### Error: "missing type id property 'kind'"
**Cause:** Missing `kind` attribute on `<element>`  
**Fix:** Add `kind="staticText"`, `kind="textField"`, etc.

### Error: "Unrecognized field 'height'" in detail section
**Cause:** Missing `<band>` wrapper in detail  
**Fix:** Wrap detail content with `<band height="..." splitType="Stretch">`

## Validation Checklist

Before deploying migrated report:

- [ ] No namespace declarations in `<jasperReport>`
- [ ] All `<import>` tags use `value` attribute
- [ ] All style attributes use correct names (`hTextAlign`, `bold`, etc.)
- [ ] All parameter attributes use correct names (`forPrompting`)
- [ ] All sections except `<detail>` have no `<band>` wrapper
- [ ] `<detail>` section HAS `<band>` wrapper
- [ ] All elements wrapped with `<element kind="...">`
- [ ] All element attributes on `<element>` tag (not nested)
- [ ] No `<reportElement>`, `<textElement>`, `<font>`, `<graphicElement>` tags
- [ ] All expressions use `<expression>` (not `<textFieldExpression>` or `<imageExpression>`)
- [ ] TextField attributes use `blankWhenNull` (not `isBlankWhenNull`)
- [ ] XML validates with `xmllint`
- [ ] Report loads without JRException
- [ ] Report compiles and generates output

## Version Information

- **JasperReports:** 7.0.3
- **JBoss EAP:** 8.1 (Jakarta EE)
- **DynamicJasper:** Compatible version
- **XML Parser:** Jackson XML (not standard SAX/DOM)

## Additional Notes

### Why This Format?
DynamicJasper uses `JacksonReportLoader` which parses XML using Jackson's XML parser instead of the standard JasperReports XML parser. This loader expects a flatter, more attribute-based structure without namespaces.

### Can I Use Jaspersoft Studio?
Jaspersoft Studio generates standard XSD format which is NOT compatible. You must manually convert or use a text editor. The studio can open these files but may show errors.

### Performance Impact?
No performance difference at runtime. The format only affects loading/parsing.

### Future Compatibility?
This format is specific to DynamicJasper + JasperReports 7. Future versions may change requirements.

## Support Resources

- **Working Reference:** `FisaReportDefaultTemplate.jrxml` in this directory
- **JasperReports Docs:** https://jasperreports.sourceforge.net/
- **DynamicJasper Docs:** http://dynamicjasper.com/

## Migration Summary

Successfully migrated 3 template files using this format. All reports now load and compile correctly in JBoss EAP 8.1 with JasperReports 7.0.3 and DynamicJasper.

## Critical Discovery

When using **DynamicJasper with JasperReports 7**, the reports are loaded using `JacksonReportLoader` which expects a **different XML format** than the standard XSD schema format.

## Files Upgraded

All JRXML files in this directory have been successfully upgraded to JasperReports 7 JacksonReportLoader format.

### Files Modified:
1. **FisaReportBlankTemplate.jrxml**
2. **FisaReportDefaultTemplate_sub.jrxml**
3. **FisaReportDefaultTemplate.jrxml**

## JacksonReportLoader Format Requirements

### 1. NO Namespace Declarations
- **DO NOT USE**: XSD namespace declarations (`xmlns`, `xsi:schemaLocation`)
- **USE**: Simple root element without namespaces
```xml
<?xml version="1.0" encoding="UTF-8"?>
<jasperReport name="Report" pageWidth="842" ...>
```

### 2. Attribute Name Changes

#### Style Attributes:
- **USE**: `hTextAlign`, `vTextAlign` (NOT `hAlign`, `vAlign`)
- **USE**: `hImageAlign`, `vImageAlign` for images
- **USE**: `bold`, `italic`, `underline`, `strikeThrough` (NOT `isBold`, `isItalic`, etc.)

#### Parameter Attributes:
- **USE**: `forPrompting` (NOT `isForPrompting`)

#### TextField Attributes:
- **USE**: `blankWhenNull` (NOT `isBlankWhenNull`)

### 3. Band Structure - Mixed Format

Most sections ARE the bands directly (no wrapper), but `<detail>` is special:

**Most Sections (title, pageHeader, columnHeader, columnFooter, pageFooter, lastPageFooter, summary, background):**
```xml
<title height="108" splitType="Stretch">
    <element kind="...">...</element>
</title>
```

**Detail Section (requires band wrapper):**
```xml
<detail>
    <band height="94" splitType="Stretch">
        <element kind="...">...</element>
    </band>
</detail>
```

### 4. Element Structure - Flattened with `kind` Attribute

All report elements must use `<element kind="...">` wrapper with ALL attributes directly on the element tag.

**WRONG (Standard XSD format):**
```xml
<staticText>
    <reportElement key="text-1" x="10" y="10" width="100" height="20" uuid="..."/>
    <textElement textAlignment="Center">
        <font size="14" isBold="true"/>
    </textElement>
    <text><![CDATA[Hello]]></text>
</staticText>
```

**CORRECT (JacksonReportLoader format):**
```xml
<element kind="staticText" key="text-1" x="10" y="10" width="100" height="20" uuid="..." hTextAlign="Center" fontSize="14" bold="true">
    <text><![CDATA[Hello]]></text>
</element>
```

#### Element Kind Values:
- `kind="staticText"` - for static text
- `kind="textField"` - for dynamic text fields
- `kind="line"` - for lines
- `kind="rectangle"` - for rectangles
- `kind="ellipse"` - for ellipses
- `kind="image"` - for images
- `kind="subreport"` - for subreports
- `kind="chart"` - for charts
- `kind="frame"` - for frames

#### Element Attributes (ALL go directly on `<element>` tag):

**Position & Size:**
- `x`, `y`, `width`, `height`
- `key` - element identifier
- `uuid` - unique identifier

**Appearance:**
- `mode` - Opaque/Transparent
- `forecolor`, `backcolor` - colors

**Text Alignment (for text elements):**
- `hTextAlign` - Left/Center/Right/Justified
- `vTextAlign` - Top/Middle/Bottom

**Font Properties (for text elements):**
- `fontName` - font family
- `fontSize` - font size
- `bold` - true/false
- `italic` - true/false
- `underline` - true/false
- `strikeThrough` - true/false
- `pdfFontName` - PDF font name
- `pdfEncoding` - PDF encoding
- `pdfEmbedded` - true/false

**TextField Specific:**
- `blankWhenNull` - true/false
- `pattern` - format pattern
- `evaluationTime` - Now/Report/Page/etc.

**Layout:**
- `positionType` - Float/FixRelativeToTop/etc.
- `stretchType` - NoStretch/RelativeToTallestObject/etc.
- `printRepeatedValues` - true/false
- `removeLineWhenBlank` - true/false
- `printInFirstWholeBand` - true/false
- `printWhenDetailOverflows` - true/false

**Child Elements (kept inside `<element>`):**
- `<text>` - for staticText content
- `<expression>` - for textField expressions AND image paths (NOT `<textFieldExpression>` or `<imageExpression>`)
- `<box>` - for borders (with nested `<topPen>`, `<leftPen>`, etc.)
- `<paragraph>` - for paragraph formatting (if needed)
- `<printWhenExpression>` - conditional printing

**DO NOT USE nested elements:**
- ❌ `<reportElement>` - attributes go directly on `<element>`
- ❌ `<textElement>` - attributes go directly on `<element>`
- ❌ `<font>` - attributes go directly on `<element>`
- ❌ `<graphicElement>` - attributes go directly on `<element>`

**Note:** Lines don't need `<pen>` or `<graphicElement>` wrappers for simple cases. Use `pen` attribute directly on element if needed.

### 5. Import Statements
```xml
<import value="net.sf.jasperreports.engine.*"/>
<import value="java.util.*"/>
<import value="net.sf.jasperreports.engine.data.*"/>
```

## Complete Example

```xml
<?xml version="1.0" encoding="UTF-8"?>
<jasperReport name="Report" pageWidth="842" pageHeight="1190" columnWidth="782" leftMargin="30" rightMargin="30" topMargin="20" bottomMargin="20" uuid="...">
    <property name="ireport.encoding" value="UTF-8"/>
    <import value="net.sf.jasperreports.engine.*"/>
    <import value="java.util.*"/>
    
    <style name="HEADER" hTextAlign="Center" vTextAlign="Middle" fontName="Arial" fontSize="12" bold="true"/>
    
    <parameter name="REPORT_PATH" class="java.lang.String" forPrompting="false"/>
    
    <title height="80" splitType="Stretch">
        <element kind="staticText" key="title-1" x="0" y="0" width="782" height="30" uuid="..." hTextAlign="Center" fontSize="16" bold="true">
            <text><![CDATA[Report Title]]></text>
        </element>
        <element kind="image" key="logo" x="10" y="10" width="100" height="30" uuid="...">
            <expression><![CDATA[$P{REPORT_PATH} + "logo.gif"]]></expression>
        </element>
        <element kind="textField" key="date" x="600" y="10" width="180" height="20" uuid="..." blankWhenNull="false">
            <expression><![CDATA[new Date()]]></expression>
        </element>
    </title>
    
    <pageHeader height="30" splitType="Stretch">
        <element kind="line" key="line-1" x="0" y="25" width="782" height="1" uuid="..."/>
    </pageHeader>
    
    <columnHeader height="20" splitType="Stretch"/>
    
    <detail>
        <band height="20" splitType="Stretch"/>
    </detail>
    
    <columnFooter height="20" splitType="Stretch">
        <element kind="line" key="line-2" x="0" y="0" width="782" height="1" uuid="...">
            <graphicElement fill="Solid"/>
        </element>
    </columnFooter>
    
    <pageFooter height="20" splitType="Stretch">
        <element kind="textField" key="pageNum" x="700" y="5" width="80" height="15" uuid="..." blankWhenNull="false" hTextAlign="Right">
            <expression><![CDATA["Page " + $V{PAGE_NUMBER}]]></expression>
        </element>
    </pageFooter>
    
    <summary height="50" splitType="Stretch"/>
</jasperReport>
```

## Migration Steps for Other Reports

1. **Remove namespace declarations** from `<jasperReport>` tag
2. **Change attribute names**:
   - `hAlign` → `hTextAlign`
   - `vAlign` → `vTextAlign`
   - `isBold` → `bold`
   - `isItalic` → `italic`
   - `isUnderline` → `underline`
   - `isStrikeThrough` → `strikeThrough`
   - `isForPrompting` → `forPrompting`
   - `isBlankWhenNull` → `blankWhenNull`
3. **Flatten band structure** - remove `<band>` wrappers from most sections, put attributes directly on section tags (EXCEPT `<detail>` which keeps its `<band>` wrapper)
4. **Wrap all elements** with `<element kind="...">` tags
5. **Flatten element structure completely**:
   - Move ALL attributes from `<reportElement>`, `<textElement>`, `<font>`, `<graphicElement>` directly to `<element>` tag
   - Remove `<reportElement>`, `<textElement>`, `<font>`, `<graphicElement>` tags completely
   - Keep only content tags: `<text>`, `<textFieldExpression>`, `<imageExpression>`, `<box>`, `<paragraph>`, `<printWhenExpression>`
6. **Convert textAlignment to hTextAlign**:
   - `textAlignment="Center"` → `hTextAlign="Center"`
   - `textAlignment="Left"` → `hTextAlign="Left"`
   - `textAlignment="Right"` → `hTextAlign="Right"`
7. **Convert font size attribute**:
   - `<font size="14"/>` → `fontSize="14"` on element tag

## Compatibility Notes

### Why This Format?
- DynamicJasper uses `JacksonReportLoader` which parses XML using Jackson's XML parser
- This loader expects a flatter, more attribute-based structure
- The standard XSD format with namespaces is NOT compatible with JacksonReportLoader

### Version Information
- JasperReports: 7.0.3
- JBoss EAP: 8.1 (Jakarta EE)
- DynamicJasper: (version in use)

## Testing Recommendations

1. **Validate XML structure** - ensure no nested `<band>` or `<reportElement>` tags
2. **Check all attribute names** - use JacksonReportLoader naming conventions
3. **Test report generation** with actual data
4. **Verify PDF/Excel exports** work correctly

## Additional Resources

- JasperReports 7 Documentation: https://jasperreports.sourceforge.net/
- DynamicJasper Documentation: http://dynamicjasper.com/
