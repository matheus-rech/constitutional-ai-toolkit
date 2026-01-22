#!/bin/bash

# Voice Agent Orchestrator - n8n Workflow Import Script
# This script imports all workflows to n8n Cloud using the API

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
N8N_URL="https://mmrech-md.app.n8n.cloud"
WORKFLOW_DIR="n8n-workflows"

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Voice Agent Orchestrator - n8n Workflow Import Script${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

# Check if n8n API key is set
if [ -z "$N8N_API_KEY" ]; then
    echo -e "${RED}❌ Error: N8N_API_KEY environment variable not set${NC}"
    echo ""
    echo "To get your API key:"
    echo "1. Go to: ${N8N_URL}/settings/api"
    echo "2. Click 'Create API Key'"
    echo "3. Copy the key"
    echo "4. Export it:"
    echo ""
    echo -e "${YELLOW}   export N8N_API_KEY='your-api-key-here'${NC}"
    echo ""
    echo "Then run this script again:"
    echo -e "${YELLOW}   ./import-workflows.sh${NC}"
    echo ""
    exit 1
fi

echo -e "${GREEN}✓ N8N_API_KEY found${NC}"
echo ""

# Function to import a workflow
import_workflow() {
    local file=$1
    local name=$(basename "$file" .json)

    echo -e "${YELLOW}📦 Importing: $name${NC}"

    if [ ! -f "$file" ]; then
        echo -e "${RED}   ❌ File not found: $file${NC}"
        return 1
    fi

    # Read workflow JSON
    workflow_json=$(cat "$file")

    # Import workflow using n8n API
    response=$(curl -s -w "\n%{http_code}" -X POST \
        "${N8N_URL}/api/v1/workflows" \
        -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
        -H "Content-Type: application/json" \
        -d "$workflow_json")

    http_code=$(echo "$response" | tail -n1)
    body=$(echo "$response" | sed '$d')

    if [ "$http_code" -eq 200 ] || [ "$http_code" -eq 201 ]; then
        workflow_id=$(echo "$body" | grep -o '"id":"[^"]*' | cut -d'"' -f4)
        echo -e "${GREEN}   ✓ Imported successfully (ID: $workflow_id)${NC}"

        # Activate the workflow
        echo -e "${YELLOW}   🔄 Activating workflow...${NC}"
        activate_response=$(curl -s -w "\n%{http_code}" -X PATCH \
            "${N8N_URL}/api/v1/workflows/${workflow_id}" \
            -H "X-N8N-API-KEY: ${N8N_API_KEY}" \
            -H "Content-Type: application/json" \
            -d '{"active": true}')

        activate_code=$(echo "$activate_response" | tail -n1)
        if [ "$activate_code" -eq 200 ]; then
            echo -e "${GREEN}   ✓ Activated${NC}"
        else
            echo -e "${RED}   ❌ Failed to activate (HTTP $activate_code)${NC}"
        fi

        return 0
    else
        echo -e "${RED}   ❌ Import failed (HTTP $http_code)${NC}"
        echo -e "${RED}   Response: $body${NC}"
        return 1
    fi
}

# Import all workflows
echo -e "${BLUE}Importing workflows from: $WORKFLOW_DIR${NC}"
echo ""

success_count=0
fail_count=0

# 1. Master Orchestrator
if import_workflow "$WORKFLOW_DIR/orchestrator-master-workflow.json"; then
    ((success_count++))
else
    ((fail_count++))
fi
echo ""

# 2. Voice-Enabled Q&A
if import_workflow "$WORKFLOW_DIR/voice-enabled-qa-workflow.json"; then
    ((success_count++))
else
    ((fail_count++))
fi
echo ""

# 3. Audio Federalist Papers
if import_workflow "$WORKFLOW_DIR/audio-federalist-papers-workflow.json"; then
    ((success_count++))
else
    ((fail_count++))
fi
echo ""

# Summary
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${BLUE}  Import Summary${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "  ${GREEN}✓ Successful: $success_count${NC}"
echo -e "  ${RED}✗ Failed: $fail_count${NC}"
echo ""

if [ $success_count -eq 3 ]; then
    echo -e "${GREEN}🎉 All workflows imported successfully!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Create the Signed URL workflow (see SETUP-BACKEND.md Step 2)"
    echo "2. Set up ElevenLabs agent (see SETUP-BACKEND.md Step 3)"
    echo "3. Test the workflows with curl commands"
    echo ""
    echo "Webhook URLs:"
    echo -e "  ${YELLOW}Master Orchestrator:${NC} ${N8N_URL}/webhook/orchestrator"
    echo -e "  ${YELLOW}Voice Q&A:${NC} ${N8N_URL}/webhook/voice-qa"
    echo -e "  ${YELLOW}Federalist Papers:${NC} ${N8N_URL}/webhook/federalist-audio"
else
    echo -e "${RED}⚠️  Some workflows failed to import${NC}"
    echo ""
    echo "Troubleshooting:"
    echo "1. Verify your API key is correct"
    echo "2. Check you have permission to create workflows"
    echo "3. Try importing manually through the n8n UI"
    echo "4. See SETUP-BACKEND.md for manual import instructions"
fi

echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
