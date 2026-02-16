#!/bin/bash
# Plugin Template Generator for Claude Code Marketplace
# Creates new plugins with best practices built-in

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
DEFAULT_AUTHOR="ramirlm"
DEFAULT_EMAIL="ramir@example.com"
DEFAULT_LICENSE="MIT"
DEFAULT_VERSION="1.0.0"

# Function to print colored output
print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Function to show usage
show_usage() {
    cat << EOF
🚀 Claude Code Plugin Template Generator

USAGE:
    ./create-plugin.sh [OPTIONS]

MODES:
    Interactive Mode (default):
        ./create-plugin.sh

    Non-Interactive Mode:
        ./create-plugin.sh --name "plugin-name" --type agent --category automation

OPTIONS:
    --name NAME           Plugin name (e.g., "git-workflow-agent")
    --type TYPE           Plugin type: agent | skill | dev-command
    --category CATEGORY   Category: coding | productivity | testing | security | automation
    --description DESC    Short description
    --dependencies DEPS   Comma-separated dependencies
    --license LICENSE     License: MIT | Apache-2.0 | GPL-3.0 (default: MIT)
    --author AUTHOR       Author name (default: ramirlm)
    --email EMAIL         Author email (default: ramir@example.com)
    --template TEMPLATE   Template type: blank | agent | skill | command | test-agent
    --help                Show this help message

EXAMPLES:
    # Interactive mode
    ./create-plugin.sh

    # Create a testing agent
    ./create-plugin.sh --name "api-test-agent" --type agent --category testing

    # Create a skill with custom author
    ./create-plugin.sh --name "code-review-skill" --type skill --author "johndoe"

GENERATED STRUCTURE:
    For agents:
        plugin-name/
        ├── .claude-plugin/
        │   └── plugin.json
        ├── README.md
        ├── CHANGELOG.md
        └── agents/
            └── agent-name.md

    For skills:
        plugin-name/
        ├── .claude-plugin/
        │   └── plugin.json
        ├── README.md
        └── skills/
            └── skill-name/
                └── SKILL.md

    For dev-commands:
        plugin-name/
        ├── .claude-plugin/
        │   └── plugin.json
        ├── README.md
        └── commands/
            └── command-name.md

EOF
}

# Function to validate plugin name
validate_plugin_name() {
    local name=$1
    if [[ ! $name =~ ^[a-z0-9-]+$ ]]; then
        print_error "Plugin name must contain only lowercase letters, numbers, and hyphens"
        return 1
    fi
    if [ -d "$name" ]; then
        print_error "Directory '$name' already exists"
        return 1
    fi
    return 0
}

# Function to convert plugin name to title
name_to_title() {
    echo "$1" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2));}1'
}

# Function to get plugin keywords based on category
get_keywords() {
    local category=$1
    local type=$2
    local base_keywords="$type"
    
    case $category in
        coding)
            echo "$base_keywords, development, code, programming"
            ;;
        productivity)
            echo "$base_keywords, efficiency, workflow, automation"
            ;;
        testing)
            echo "$base_keywords, qa, quality, automation, testing"
            ;;
        security)
            echo "$base_keywords, security, audit, vulnerability, compliance"
            ;;
        automation)
            echo "$base_keywords, automation, workflow, ci-cd"
            ;;
        *)
            echo "$base_keywords"
            ;;
    esac
}

# Parse command line arguments
INTERACTIVE=true
PLUGIN_NAME=""
PLUGIN_TYPE=""
PLUGIN_CATEGORY=""
PLUGIN_DESCRIPTION=""
PLUGIN_DEPENDENCIES=""
PLUGIN_LICENSE="$DEFAULT_LICENSE"
PLUGIN_AUTHOR="$DEFAULT_AUTHOR"
PLUGIN_EMAIL="$DEFAULT_EMAIL"
PLUGIN_TEMPLATE="blank"

while [[ $# -gt 0 ]]; do
    case $1 in
        --name)
            PLUGIN_NAME="$2"
            INTERACTIVE=false
            shift 2
            ;;
        --type)
            PLUGIN_TYPE="$2"
            INTERACTIVE=false
            shift 2
            ;;
        --category)
            PLUGIN_CATEGORY="$2"
            INTERACTIVE=false
            shift 2
            ;;
        --description)
            PLUGIN_DESCRIPTION="$2"
            INTERACTIVE=false
            shift 2
            ;;
        --dependencies)
            PLUGIN_DEPENDENCIES="$2"
            INTERACTIVE=false
            shift 2
            ;;
        --license)
            PLUGIN_LICENSE="$2"
            INTERACTIVE=false
            shift 2
            ;;
        --author)
            PLUGIN_AUTHOR="$2"
            INTERACTIVE=false
            shift 2
            ;;
        --email)
            PLUGIN_EMAIL="$2"
            INTERACTIVE=false
            shift 2
            ;;
        --template)
            PLUGIN_TEMPLATE="$2"
            INTERACTIVE=false
            shift 2
            ;;
        --help|-h)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            show_usage
            exit 1
            ;;
    esac
done

echo ""
echo "🚀 Claude Code Plugin Template Generator"
echo "========================================="
echo ""

# Interactive mode
if [ "$INTERACTIVE" = true ]; then
    print_info "Starting interactive mode..."
    echo ""
    
    # Get plugin name
    while true; do
        read -p "Plugin name (e.g., 'git-workflow-agent'): " PLUGIN_NAME
        if validate_plugin_name "$PLUGIN_NAME"; then
            break
        fi
    done
    
    # Get plugin type
    echo ""
    echo "Plugin types:"
    echo "  1) agent       - Autonomous agent"
    echo "  2) skill       - Step-by-step skill"
    echo "  3) dev-command - Development command"
    read -p "Select type (1-3): " type_choice
    case $type_choice in
        1) PLUGIN_TYPE="agent" ;;
        2) PLUGIN_TYPE="skill" ;;
        3) PLUGIN_TYPE="dev-command" ;;
        *) PLUGIN_TYPE="agent" ;;
    esac
    
    # Get category
    echo ""
    echo "Categories:"
    echo "  1) coding       - Code development"
    echo "  2) productivity - Productivity tools"
    echo "  3) testing      - Testing frameworks"
    echo "  4) security     - Security tools"
    echo "  5) automation   - Automation workflows"
    read -p "Select category (1-5): " cat_choice
    case $cat_choice in
        1) PLUGIN_CATEGORY="coding" ;;
        2) PLUGIN_CATEGORY="productivity" ;;
        3) PLUGIN_CATEGORY="testing" ;;
        4) PLUGIN_CATEGORY="security" ;;
        5) PLUGIN_CATEGORY="automation" ;;
        *) PLUGIN_CATEGORY="automation" ;;
    esac
    
    # Get description
    echo ""
    read -p "Short description: " PLUGIN_DESCRIPTION
    
    # Warn if description contains special characters that might cause issues
    if [[ "$PLUGIN_DESCRIPTION" == *"/"* ]] || [[ "$PLUGIN_DESCRIPTION" == *"\\"* ]]; then
        print_warning "Description contains special characters (/ or \\). This may cause template processing issues."
        read -p "Continue anyway? (y/n): " continue_desc
        if [[ ! $continue_desc =~ ^[Yy]$ ]]; then
            print_info "Please enter a different description"
            read -p "Short description: " PLUGIN_DESCRIPTION
        fi
    fi
    
    # Get dependencies
    echo ""
    read -p "Dependencies (comma-separated, optional): " PLUGIN_DEPENDENCIES
    
    # Get license
    echo ""
    echo "Common licenses:"
    echo "  1) MIT (default)"
    echo "  2) Apache-2.0"
    echo "  3) GPL-3.0"
    read -p "Select license (1-3, default: 1): " license_choice
    case $license_choice in
        2) PLUGIN_LICENSE="Apache-2.0" ;;
        3) PLUGIN_LICENSE="GPL-3.0" ;;
        *) PLUGIN_LICENSE="MIT" ;;
    esac
    
    # Get author
    echo ""
    read -p "Author name (default: $DEFAULT_AUTHOR): " author_input
    PLUGIN_AUTHOR="${author_input:-$DEFAULT_AUTHOR}"
    
    # Get email
    echo ""
    read -p "Author email (default: $DEFAULT_EMAIL): " email_input
    PLUGIN_EMAIL="${email_input:-$DEFAULT_EMAIL}"
    
    # Get template
    echo ""
    echo "Templates:"
    echo "  1) blank      - Minimal structure"
    echo "  2) agent      - Full agent setup"
    echo "  3) skill      - Skill with examples"
    echo "  4) command    - Command with args"
    echo "  5) test-agent - Testing framework"
    read -p "Select template (1-5, default: 1): " template_choice
    case $template_choice in
        2) PLUGIN_TEMPLATE="agent" ;;
        3) PLUGIN_TEMPLATE="skill" ;;
        4) PLUGIN_TEMPLATE="command" ;;
        5) PLUGIN_TEMPLATE="test-agent" ;;
        *) PLUGIN_TEMPLATE="blank" ;;
    esac
else
    # Non-interactive mode validation
    if [ -z "$PLUGIN_NAME" ] || [ -z "$PLUGIN_TYPE" ]; then
        print_error "Required parameters missing: --name and --type are required"
        show_usage
        exit 1
    fi
    
    if ! validate_plugin_name "$PLUGIN_NAME"; then
        exit 1
    fi
    
    # Set defaults for optional parameters
    if [ -z "$PLUGIN_CATEGORY" ]; then
        PLUGIN_CATEGORY="automation"
    fi
    
    if [ -z "$PLUGIN_DESCRIPTION" ]; then
        PLUGIN_DESCRIPTION="A new $(name_to_title "$PLUGIN_TYPE") plugin for Claude Code"
    fi
fi

# Summary
echo ""
echo "📋 Plugin Configuration:"
echo "  Name:         $PLUGIN_NAME"
echo "  Type:         $PLUGIN_TYPE"
echo "  Category:     $PLUGIN_CATEGORY"
echo "  Description:  $PLUGIN_DESCRIPTION"
echo "  Dependencies: ${PLUGIN_DEPENDENCIES:-none}"
echo "  License:      $PLUGIN_LICENSE"
echo "  Author:       $PLUGIN_AUTHOR"
echo "  Email:        $PLUGIN_EMAIL"
echo "  Template:     $PLUGIN_TEMPLATE"
echo ""

if [ "$INTERACTIVE" = true ]; then
    read -p "Create plugin with these settings? (y/n): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        print_warning "Plugin creation cancelled"
        exit 0
    fi
fi

# Create plugin directory structure
print_info "Creating plugin directory structure..."

mkdir -p "$PLUGIN_NAME/.claude-plugin"

# Create appropriate subdirectories based on type
case $PLUGIN_TYPE in
    agent)
        mkdir -p "$PLUGIN_NAME/agents"
        mkdir -p "$PLUGIN_NAME/examples"
        ;;
    skill)
        mkdir -p "$PLUGIN_NAME/skills"
        mkdir -p "$PLUGIN_NAME/examples"
        ;;
    dev-command)
        mkdir -p "$PLUGIN_NAME/commands"
        ;;
esac

print_success "Directory structure created"

# Generate plugin.json
print_info "Generating plugin.json..."

# Get keywords
KEYWORDS_RAW=$(get_keywords "$PLUGIN_CATEGORY" "$PLUGIN_TYPE")
# Convert to JSON array format
KEYWORDS=$(echo "$KEYWORDS_RAW" | sed 's/, /", "/g' | sed 's/^/"/' | sed 's/$/"/')

cat > "$PLUGIN_NAME/.claude-plugin/plugin.json" << EOF
{
  "name": "$PLUGIN_NAME",
  "version": "$DEFAULT_VERSION",
  "description": "$PLUGIN_DESCRIPTION",
  "author": {
    "name": "$PLUGIN_AUTHOR"
  },
  "keywords": [$KEYWORDS],
  "license": "$PLUGIN_LICENSE"
}
EOF

print_success "plugin.json created"

# Generate README.md
print_info "Generating README.md..."

PLUGIN_TITLE=$(name_to_title "$PLUGIN_NAME")

cat > "$PLUGIN_NAME/README.md" << 'EOF_README'
# PLUGIN_TITLE_PLACEHOLDER

PLUGIN_DESCRIPTION_PLACEHOLDER

## Features

- 🚀 Feature 1
- ✨ Feature 2
- 🔧 Feature 3

## Installation

```bash
# Copy plugin to Claude plugins directory
cp -r PLUGIN_NAME_PLACEHOLDER ~/.claude/plugins/

# Enable the plugin
cc --enable-plugin PLUGIN_NAME_PLACEHOLDER
```

## Prerequisites

- **Claude Code**: Latest version
- **Dependencies**: PLUGIN_DEPENDENCIES_PLACEHOLDER

## Usage

USAGE_CONTENT_PLACEHOLDER

## Examples

EXAMPLES_CONTENT_PLACEHOLDER

## Configuration

CONFIGURATION_CONTENT_PLACEHOLDER

## File Structure

```
PLUGIN_NAME_PLACEHOLDER/
├── .claude-plugin/
│   └── plugin.json
├── README.md
STRUCTURE_CONTENT_PLACEHOLDER
```

## Troubleshooting

### Common Issues

1. **Plugin not loading**
   - Verify plugin is in `~/.claude/plugins/`
   - Check plugin.json is valid JSON
   - Restart Claude Code

2. **Dependencies missing**
   - Install required dependencies
   - Check version compatibility

## Best Practices

BEST_PRACTICES_PLACEHOLDER

## License

PLUGIN_LICENSE_PLACEHOLDER

## Author

PLUGIN_AUTHOR_PLACEHOLDER
EOF_README

# Replace placeholders (note: avoid special characters in description for best results)
sed -i.bak "s/PLUGIN_TITLE_PLACEHOLDER/$PLUGIN_TITLE/g" "$PLUGIN_NAME/README.md" 2>/dev/null || true
sed -i.bak "s/PLUGIN_DESCRIPTION_PLACEHOLDER/$PLUGIN_DESCRIPTION/g" "$PLUGIN_NAME/README.md" 2>/dev/null || true
sed -i.bak "s/PLUGIN_NAME_PLACEHOLDER/$PLUGIN_NAME/g" "$PLUGIN_NAME/README.md" 2>/dev/null || true
sed -i.bak "s/PLUGIN_DEPENDENCIES_PLACEHOLDER/${PLUGIN_DEPENDENCIES:-None}/g" "$PLUGIN_NAME/README.md" 2>/dev/null || true
sed -i.bak "s/PLUGIN_LICENSE_PLACEHOLDER/$PLUGIN_LICENSE/g" "$PLUGIN_NAME/README.md" 2>/dev/null || true
sed -i.bak "s/PLUGIN_AUTHOR_PLACEHOLDER/$PLUGIN_AUTHOR/g" "$PLUGIN_NAME/README.md" 2>/dev/null || true

# Add type-specific content to README
case $PLUGIN_TYPE in
    agent)
        sed -i.bak 's/USAGE_CONTENT_PLACEHOLDER/The agent triggers automatically when you mention relevant keywords:\n\n```\n"Run the task"\n"Execute the workflow"\n```/g' "$PLUGIN_NAME/README.md"
        sed -i.bak 's/EXAMPLES_CONTENT_PLACEHOLDER/### Example 1: Basic Usage\n```\nUser: "Perform the task"\nAgent: *Executes task autonomously*\n```/g' "$PLUGIN_NAME/README.md"
        sed -i.bak 's/CONFIGURATION_CONTENT_PLACEHOLDER/Configure agent behavior in `agents\/agent-name.md`/g' "$PLUGIN_NAME/README.md"
        sed -i.bak 's/STRUCTURE_CONTENT_PLACEHOLDER/└── agents\/\n    └── agent-name.md/g' "$PLUGIN_NAME/README.md"
        sed -i.bak 's/BEST_PRACTICES_PLACEHOLDER/- Keep agent instructions clear and concise\n- Test with various scenarios\n- Document expected behavior/g' "$PLUGIN_NAME/README.md"
        ;;
    skill)
        sed -i.bak 's/USAGE_CONTENT_PLACEHOLDER/Use the skill by invoking it in your workflow:\n\n```\n\/skill skill-name\n```/g' "$PLUGIN_NAME/README.md"
        sed -i.bak 's/EXAMPLES_CONTENT_PLACEHOLDER/### Example: Using the skill\n```\n\/skill skill-name\n```/g' "$PLUGIN_NAME/README.md"
        sed -i.bak 's/CONFIGURATION_CONTENT_PLACEHOLDER/Configure skill steps in `skills\/skill-name\/SKILL.md`/g' "$PLUGIN_NAME/README.md"
        sed -i.bak 's/STRUCTURE_CONTENT_PLACEHOLDER/└── skills\/\n    └── skill-name\/\n        └── SKILL.md/g' "$PLUGIN_NAME/README.md"
        sed -i.bak 's/BEST_PRACTICES_PLACEHOLDER/- Break down complex tasks into steps\n- Provide clear examples\n- Include validation/g' "$PLUGIN_NAME/README.md"
        ;;
    dev-command)
        sed -i.bak 's/USAGE_CONTENT_PLACEHOLDER/Use the command in your development workflow:\n\n```bash\n\/command-name [args]\n```/g' "$PLUGIN_NAME/README.md"
        sed -i.bak 's/EXAMPLES_CONTENT_PLACEHOLDER/### Example: Running the command\n```bash\n\/command-name --option value\n```/g' "$PLUGIN_NAME/README.md"
        sed -i.bak 's/CONFIGURATION_CONTENT_PLACEHOLDER/Configure command behavior in `commands\/command-name.md`/g' "$PLUGIN_NAME/README.md"
        sed -i.bak 's/STRUCTURE_CONTENT_PLACEHOLDER/└── commands\/\n    └── command-name.md/g' "$PLUGIN_NAME/README.md"
        sed -i.bak 's/BEST_PRACTICES_PLACEHOLDER/- Document all command options\n- Handle errors gracefully\n- Provide helpful feedback/g' "$PLUGIN_NAME/README.md"
        ;;
esac

rm -f "$PLUGIN_NAME/README.md.bak"

print_success "README.md created"

# Generate CHANGELOG.md
print_info "Generating CHANGELOG.md..."

cat > "$PLUGIN_NAME/CHANGELOG.md" << EOF
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [$DEFAULT_VERSION] - $(date +%Y-%m-%d)

### Added
- Initial release
- Basic plugin structure
- Core functionality
EOF

print_success "CHANGELOG.md created"

# Generate type-specific files
case $PLUGIN_TYPE in
    agent)
        print_info "Generating agent template..."
        
        AGENT_FILE="$PLUGIN_NAME/agents/$(echo "$PLUGIN_NAME" | sed 's/-agent$//')-runner.md"
        cat > "$AGENT_FILE" << 'EOF_AGENT'
# AGENT_NAME_PLACEHOLDER

AGENT_DESCRIPTION_PLACEHOLDER

## Capabilities

- **Capability 1**: Description
- **Capability 2**: Description
- **Capability 3**: Description

## Activation

This agent activates when:
- User mentions specific keywords
- Specific conditions are met
- Manual invocation

## Workflow

1. **Step 1**: Description
2. **Step 2**: Description
3. **Step 3**: Description
4. **Step 4**: Description

## Configuration

Configure agent behavior using environment variables or configuration files.

## Error Handling

The agent handles errors gracefully:
- Validates inputs
- Provides clear error messages
- Suggests fixes when possible

## Examples

### Example 1: Basic Usage
```
User: "Execute task"
Agent: [Performs autonomous task execution]
```

### Example 2: Advanced Usage
```
User: "Execute complex workflow"
Agent: [Handles multi-step workflow]
```

## Best Practices

- Clear naming conventions
- Proper error handling
- Comprehensive logging
- Regular testing
EOF_AGENT

        AGENT_TITLE=$(name_to_title "$(echo "$PLUGIN_NAME" | sed 's/-agent$//')")
        sed -i.bak "s/AGENT_NAME_PLACEHOLDER/$AGENT_TITLE Agent/g" "$AGENT_FILE"
        sed -i.bak "s/AGENT_DESCRIPTION_PLACEHOLDER/$PLUGIN_DESCRIPTION/g" "$AGENT_FILE"
        rm -f "$AGENT_FILE.bak"
        
        print_success "Agent template created: $AGENT_FILE"
        
        # Create example file
        cat > "$PLUGIN_NAME/examples/sample-usage.md" << EOF
# Example Usage

## Basic Usage

\`\`\`
User: "Run the $PLUGIN_NAME"
Agent: *Executes task autonomously*
\`\`\`

## Advanced Usage

\`\`\`
User: "Execute complex workflow with $PLUGIN_NAME"
Agent: *Handles multi-step workflow*
\`\`\`
EOF
        print_success "Example file created"
        ;;
        
    skill)
        print_info "Generating skill template..."
        
        SKILL_NAME=$(echo "$PLUGIN_NAME" | sed 's/-skill$//')
        mkdir -p "$PLUGIN_NAME/skills/$SKILL_NAME"
        
        SKILL_FILE="$PLUGIN_NAME/skills/$SKILL_NAME/SKILL.md"
        cat > "$SKILL_FILE" << 'EOF_SKILL'
# SKILL_NAME_PLACEHOLDER

SKILL_DESCRIPTION_PLACEHOLDER

## Overview

This skill provides step-by-step guidance for TASK_PLACEHOLDER.

## Prerequisites

- Prerequisite 1
- Prerequisite 2

## Steps

### Step 1: Preparation
Description of first step.

```bash
# Example command
command --option
```

### Step 2: Execution
Description of second step.

### Step 3: Validation
Description of validation step.

### Step 4: Completion
Final step and verification.

## Examples

### Example 1: Basic Usage
```
Input: Basic scenario
Output: Expected result
```

### Example 2: Advanced Usage
```
Input: Complex scenario
Output: Expected result
```

## Troubleshooting

### Issue 1
**Problem**: Description
**Solution**: Steps to resolve

### Issue 2
**Problem**: Description
**Solution**: Steps to resolve

## Best Practices

- Best practice 1
- Best practice 2
- Best practice 3
EOF_SKILL

        SKILL_TITLE=$(name_to_title "$SKILL_NAME")
        sed -i.bak "s/SKILL_NAME_PLACEHOLDER/$SKILL_TITLE/g" "$SKILL_FILE"
        sed -i.bak "s/SKILL_DESCRIPTION_PLACEHOLDER/$PLUGIN_DESCRIPTION/g" "$SKILL_FILE"
        sed -i.bak "s/TASK_PLACEHOLDER/your task/g" "$SKILL_FILE"
        rm -f "$SKILL_FILE.bak"
        
        print_success "Skill template created: $SKILL_FILE"
        
        # Create example file
        cat > "$PLUGIN_NAME/examples/skill-example.md" << EOF
# Skill Example

## Using the $SKILL_TITLE Skill

\`\`\`
/skill $SKILL_NAME
\`\`\`

## Expected Outcome

The skill will guide you through the process step by step.
EOF
        print_success "Example file created"
        ;;
        
    dev-command)
        print_info "Generating dev-command template..."
        
        COMMAND_NAME=$(echo "$PLUGIN_NAME" | sed 's/-command$//')
        COMMAND_FILE="$PLUGIN_NAME/commands/$COMMAND_NAME.md"
        
        cat > "$COMMAND_FILE" << 'EOF_COMMAND'
# COMMAND_NAME_PLACEHOLDER

COMMAND_DESCRIPTION_PLACEHOLDER

## Usage

```bash
/COMMAND_SLUG_PLACEHOLDER [options] [arguments]
```

## Options

- `--option1`: Description of option 1
- `--option2`: Description of option 2
- `--help`: Show help message

## Arguments

- `arg1`: Description of argument 1
- `arg2`: Description of argument 2 (optional)

## Examples

### Example 1: Basic Usage
```bash
/COMMAND_SLUG_PLACEHOLDER arg1
```

### Example 2: With Options
```bash
/COMMAND_SLUG_PLACEHOLDER --option1 value arg1 arg2
```

### Example 3: Advanced Usage
```bash
/COMMAND_SLUG_PLACEHOLDER --option1 --option2 arg1
```

## Output

The command outputs:
- Status information
- Results
- Any errors or warnings

## Error Handling

Common errors and solutions:
- **Error 1**: Description and solution
- **Error 2**: Description and solution

## Notes

- Note about usage
- Best practices
- Limitations
EOF_COMMAND

        COMMAND_TITLE=$(name_to_title "$COMMAND_NAME")
        sed -i.bak "s/COMMAND_NAME_PLACEHOLDER/$COMMAND_TITLE Command/g" "$COMMAND_FILE"
        sed -i.bak "s/COMMAND_DESCRIPTION_PLACEHOLDER/$PLUGIN_DESCRIPTION/g" "$COMMAND_FILE"
        sed -i.bak "s/COMMAND_SLUG_PLACEHOLDER/$COMMAND_NAME/g" "$COMMAND_FILE"
        rm -f "$COMMAND_FILE.bak"
        
        print_success "Dev-command template created: $COMMAND_FILE"
        ;;
esac

# Update marketplace.json
print_info "Updating marketplace.json..."

# Check if marketplace.json exists
if [ ! -f "marketplace.json" ]; then
    print_warning "marketplace.json not found in current directory"
    print_info "Skipping marketplace update (run this script from repository root)"
else
    # Check if python3 is available
    if ! command -v python3 &> /dev/null; then
        print_warning "python3 not found, skipping marketplace.json update"
        print_info "You can manually add the plugin entry to marketplace.json later"
    else
        # Get repo name from marketplace.json or use default
        REPO_NAME=$(grep -o '"repo": "[^"]*"' marketplace.json | head -1 | cut -d'"' -f4 | cut -d'/' -f2)
        REPO_OWNER=$(grep -o '"repo": "[^"]*"' marketplace.json | head -1 | cut -d'"' -f4 | cut -d'/' -f1)
        
        if [ -z "$REPO_NAME" ]; then
            REPO_NAME="ramir-cc-marketplace"
            REPO_OWNER="ramirlm"
        fi
        
        # Backup marketplace.json
        cp marketplace.json marketplace.json.backup
        
        # Add new plugin to marketplace.json using Python
        python3 << PYTHON_SCRIPT
import json
import sys

try:
    with open('marketplace.json', 'r') as f:
        data = json.load(f)
    
    new_plugin = {
        "name": "$PLUGIN_NAME",
        "source": {
            "source": "github",
            "repo": "$REPO_OWNER/$REPO_NAME",
            "path": "$PLUGIN_NAME"
        },
        "description": "$PLUGIN_DESCRIPTION",
        "version": "$DEFAULT_VERSION",
        "author": {
            "name": "$PLUGIN_AUTHOR",
            "email": "$PLUGIN_EMAIL"
        },
        "license": "$PLUGIN_LICENSE"
    }
    
    data['plugins'].append(new_plugin)
    
    with open('marketplace.json', 'w') as f:
        json.dump(data, f, indent=2)
    
    print("✅ marketplace.json updated")
except Exception as e:
    print(f"⚠️  Could not update marketplace.json: {e}")
    sys.exit(0)
PYTHON_SCRIPT
        
        print_success "marketplace.json updated"
    fi
fi

echo ""
print_success "Plugin '$PLUGIN_NAME' created successfully!"
echo ""

print_info "Next steps:"
echo "  1. Review generated files in '$PLUGIN_NAME/'"
echo "  2. Customize templates to match your needs"
echo "  3. Add your implementation"
echo "  4. Test the plugin:"
echo "     cp -r $PLUGIN_NAME ~/.claude/plugins/"
echo "     cc --enable-plugin $PLUGIN_NAME"
echo "  5. Commit to repository:"
echo "     git add $PLUGIN_NAME marketplace.json"
echo "     git commit -m 'Add $PLUGIN_NAME plugin'"
echo ""

print_info "Generated files:"
tree -L 3 "$PLUGIN_NAME" 2>/dev/null || find "$PLUGIN_NAME" -type f

echo ""
print_success "Happy coding! 🚀"
