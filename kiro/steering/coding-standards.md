# Coding Standards

## Global
- Encoding: UTF-8, LF line endings, no final newline
- Indent: 4 spaces (no tabs); max line length: 120
- Formatter regions: `@formatter:off` / `@formatter:on`

## Java
- Braces: end-of-line (K&R); `else`/`catch`/`finally` on same line as closing brace
- Annotations (class, method, field): each on its own line
- Import order: `*` → blank → `javax.**` → `java.**` → blank → static (`$*`)
- Star imports threshold: 5 classes, 3 static members; prefer single-class imports otherwise
- Naming: implementation suffix `Impl`, test suffix `Test`
- Blank lines: 1 around classes and methods, 0 around fields
- Indent `case` from `switch`; single-line `if` without braces allowed
- Always add `@Override`; use `else-if` chains (no nested treatment)
- Wrapping: off for most constructs; do not force-wrap long lines
- Javadoc: blank line after description; align `@param`/`@throws` comments

## Kotlin
- Follow `KOTLIN_OFFICIAL` style; opening brace stays end-of-line
- Parameters/arguments: wrap every item; closing paren on new line; `if` closing paren on new line when condition wraps
- Import order: `*` → `java.**` → `javax.**` → `kotlin.**` → aliases (`^`)
- Star imports: 5+ classes, 3+ members
- Trailing commas: off by default; allowed in destructuring, function literals, `when` entries, value/type param lists
- No continuation indent for chained calls, expression bodies, argument lists, elvis, if-conditions, supertype lists
- Wrap: method call chains (normal), elvis expressions (level 1), expression body functions (level 1)

## TypeScript / JavaScript
- Quotes: double; semicolons: always
- Private field prefix: `_`
- Trailing commas: keep as-is
- Imports: sorted by member name; each named import on its own line
- Chained method calls: dot on new line
- Enums, object literals, object types, union types: each item on its own line
- Type braces `{ }` and union `|`: include inner spaces (`{ Foo }`, `A | B`)
- Class decorators: each on its own line
- `//` comments: space after `//`; not forced to first column
- Blank lines: 1 after imports, 1 around classes/functions/methods

## JSON
- Indent: 2 spaces
- Arrays and objects: each item on its own line
- No trailing commas; space after `:`, no space before `:`

## YAML
- Indent: 2 spaces
- Do not align values across properties; sequence values indented under key

## Shell (bash / zsh / sh)
- Indent: 2 spaces, LF endings
- Binary operators: end of line (not start of next line)
- `case` branches: not additionally indented

## HTML
- Attribute wrap: normal (wrap at line limit), align attributes when wrapped
- Quotes: double; no space inside empty tags (`<br/>`)
- Do not indent children of: `html`, `body`, `thead`, `tbody`, `tfoot`

## Markdown
- One space after `#` header symbols and list bullets
- Format tables; wrap long text
- Max 1 blank line around headers, block elements, and between paragraphs
