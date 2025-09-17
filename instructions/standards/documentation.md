# Documentation Standards

## Machine-Readable Documentation Principles

### Semantic Structure Requirements

Structure all documentation with clear hierarchical relationships. Use consistent heading levels to establish information architecture. Maintain logical parent-child relationships between sections.

### Metadata Integration

When creating documentation files, include structured metadata using YAML front matter when the format supports it. Place metadata at the beginning of files to declare:

- Document type and purpose
- Version information
- Dependencies and relationships
- Status and lifecycle stage

### Information Architecture

Organize documentation following these priorities:

1. Purpose statement first
2. Critical information immediately visible
3. Progressive detail through hierarchy
4. Related information grouped together
5. Clear separation between concepts

### Clarity and Parsability

Write documentation for both human and machine consumption:

- Use consistent terminology throughout
- Define terms before using them
- Avoid ambiguous references
- Maintain single source of truth for each concept
- Eliminate redundant information

### Structural Patterns

Apply these patterns consistently:

- Use definition lists for term explanations
- Apply consistent formatting for similar content types
- Separate examples from explanations
- Distinguish between required and optional information
- Mark deprecated content explicitly

### API and Interface Documentation

When documenting interfaces:

- List all parameters with types
- Specify required vs optional parameters
- Document return values and types
- Include error conditions and handling
- Provide usage patterns without implementation details

### Cross-Reference Management

Maintain documentation coherence through:

- Explicit links between related concepts
- Consistent naming for referenced items
- Clear dependency declarations
- Version-aware references
- Avoidance of circular dependencies

### Documentation Maintenance

Ensure documentation remains accurate:

- Update documentation with code changes
- Remove obsolete information immediately
- Mark uncertain information explicitly
- Maintain changelog for significant updates
- Verify all examples remain valid

### Format-Specific Rules

#### Markdown Documents

- Use consistent heading hierarchy
- Apply semantic line breaks
- Utilize reference-style links for repeated URLs
- Maintain consistent list formatting

#### Configuration Files

- Include inline documentation for complex settings
- Group related configuration together
- Document default values
- Explain validation rules

#### README Files

- Start with project purpose
- List prerequisites explicitly
- Provide minimal quick start
- Link to detailed documentation
- Maintain accuracy over completeness

### Quality Criteria

Documentation meets standards when:

- Information can be extracted programmatically
- Structure supports automated processing
- Content remains unambiguous
- Updates require minimal cascading changes
- Machine parsing produces consistent results
