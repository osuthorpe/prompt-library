# POML Prompt Library

A comprehensive, shareable prompt library using Microsoft's Prompt Optimization Markup Language (POML) format.

## Overview

This repository contains a collection of production-ready AI prompts formatted in POML for easy maintenance, sharing, and integration with various AI platforms including Azure AI Studio, Semantic Kernel, LangChain, and Prompt Flow.

## Structure

```
prompt-library/
├── poml/                   # POML-formatted prompt library
│   ├── prompts/           # Individual prompt definitions
│   ├── templates/         # Reusable prompt templates
│   ├── functions/         # Shared processing functions
│   ├── chains/            # Multi-step workflow chains
│   ├── configs/           # Configuration files
│   └── poml.config.json   # Main library configuration
└── legacy/                # Original prompt library (deprecated)
```

## Features

- **Standardized Format**: All prompts use POML format for consistency
- **Modular Design**: Reusable functions and templates
- **Chain Workflows**: Complex multi-step prompt chains
- **Easy Sharing**: Export/import in multiple formats
- **Platform Compatible**: Works with major AI frameworks
- **Version Controlled**: Each prompt includes versioning

## Available Prompts

### Release Notes & Documentation
- `categorize_release_notes.poml` - Categorize release notes into sections
- `create_single_sentence_release_note.poml` - Generate concise release notes

### Content Creation
- `ghost_writer.poml` - Transform research papers into articles
- `idea_explainer.poml` - Explain complex ideas in plain English
- `paraphraser.poml` - Advanced text paraphrasing with diversity control

### Research & Analysis
- `paper_research_assistant.poml` - Analyze and replicate research papers
- `meeting_summary.poml` - Extract action items from meeting transcripts

## Quick Start

### Using a Single Prompt

```python
from poml import PromptLoader

# Load a prompt
loader = PromptLoader("poml/prompts/idea_explainer.poml")

# Execute with parameters
result = loader.execute({
    "idea_title": "Quantum Computing",
    "idea_description": "Using quantum mechanics for computation..."
})
```

### Using Workflow Chains

```python
from poml import ChainExecutor

# Load research workflow
executor = ChainExecutor("poml/chains/research_workflow.poml")

# Run complete analysis pipeline
results = executor.run({
    "paper_url": "https://arxiv.org/...",
    "output_format": "full"
})
```

### Using Functions

```python
from poml import FunctionLibrary

# Load text processing functions
lib = FunctionLibrary("poml/functions/text_processing.poml")

# Use specific function
summary = lib.summarizeText(text, target_length=100, style="executive")
```

## POML Format

Each POML file follows this structure:

```yaml
---
name: Prompt Name
description: What this prompt does
version: 1.0.0
author: Author Name
tags: [tag1, tag2]
model:
  provider: openai
  name: gpt-4
  temperature: 0.7
---

# Main Prompt Content

## Input Parameters
@param param1 type required "description"

## Instructions
[Prompt instructions here]

## Output Format
[Expected output format]
```

## Integration

### Azure AI Studio
```python
from azure.ai.studio import PromptFlow
flow = PromptFlow.from_poml("poml/prompts/meeting_summary.poml")
```

### Semantic Kernel
```python
from semantic_kernel import Kernel
kernel = Kernel()
kernel.import_poml_directory("poml/prompts/")
```

### LangChain
```python
from langchain import POMLPromptTemplate
template = POMLPromptTemplate.from_file("poml/prompts/ghost_writer.poml")
```

## Configuration

The main configuration file `poml/poml.config.json` contains:
- Library metadata
- Default model settings
- Category definitions
- Validation rules
- Export/import settings

## Contributing

1. Use the base template at `poml/templates/base_prompt.poml`
2. Follow POML formatting standards
3. Include comprehensive examples
4. Add appropriate tags and categories
5. Test with multiple model providers

## Migration from Legacy

The original YAML-based prompts are preserved in the `legacy/` folder. To convert legacy prompts to POML:

```python
from poml import LegacyConverter
converter = LegacyConverter()
converter.convert_yaml_to_poml("legacy/prompts/old_prompt.yaml", "poml/prompts/")
```

## License

MIT License - See LICENSE file for details

## Support

For questions or issues:
- Open an issue on GitHub
- Check documentation in each POML file
- Refer to examples in templates folder

## Roadmap

- [ ] Add more workflow chains
- [ ] Implement prompt testing framework
- [ ] Create web-based prompt editor
- [ ] Add prompt performance metrics
- [ ] Build prompt recommendation system