# n8n Workflows - GitHub Backup Guide

## Overview

Your n8n workflows run on **n8n Cloud** (https://mmrech-md.app.n8n.cloud) and should be backed up to **GitHub** for version control, disaster recovery, and collaboration.

---

## Workflow Locations

### Production (n8n Cloud)
- **URL:** https://mmrech-md.app.n8n.cloud/workflows
- **Storage:** Cloud-hosted, managed by n8n
- **Purpose:** Live execution environment

### Backup (GitHub)
- **Repository:** https://github.com/matheus-rech/constitutional-ai-toolkit
- **Directory:** `n8n-workflows/`
- **Purpose:** Version control, backup, documentation

---

## Workflow Files to Back Up

### 1. Master Orchestrator
- **File:** `orchestrator-master-workflow.json`
- **Status:** ✅ Already created (in Downloads)
- **Purpose:** Routes tool requests to appropriate sub-workflows

### 2. Voice-Enabled Q&A
- **File:** `voice-enabled-qa-workflow.json`
- **Status:** ✅ Already created (in Downloads)
- **Purpose:** Voice input + AI analysis + voice output

### 3. Audio Federalist Papers
- **File:** `audio-federalist-papers-workflow.json`
- **Status:** ✅ Already created (in Downloads)
- **Purpose:** Generate historical essays with audio narration

### 4. Agent Signed URL
- **File:** `agent-signed-url-workflow.json`
- **Status:** 📝 Need to export from n8n
- **Purpose:** Generate signed URLs for agent connections

---

## Backup Process

### Step 1: Create Workflows Directory

```bash
cd ~/Downloads/constitutional-ai-toolkit
mkdir -p n8n-workflows
```

### Step 2: Copy Existing Workflow Files

```bash
# Copy the workflows we already created
cp ~/Downloads/orchestrator-master-workflow.json n8n-workflows/
cp ~/Downloads/voice-enabled-qa-workflow.json n8n-workflows/
cp ~/Downloads/audio-federalist-papers-workflow.json n8n-workflows/
```

### Step 3: Export Agent Signed URL Workflow

1. Go to https://mmrech-md.app.n8n.cloud/workflows
2. Open the "Get Agent Signed URL" workflow
3. Click the **"..."** menu (top right)
4. Select **"Download"**
5. Save as `agent-signed-url-workflow.json`
6. Move to repository:

```bash
mv ~/Downloads/agent-signed-url-workflow.json ~/Downloads/constitutional-ai-toolkit/n8n-workflows/
```

### Step 4: Create Workflow README

```bash
cat > ~/Downloads/constitutional-ai-toolkit/n8n-workflows/README.md << 'EOF'
# n8n Workflows for Constitutional AI Toolkit

## Overview

These workflows power the voice agent orchestrator and voice-enabled features of the Constitutional AI Toolkit.

**Production Instance:** https://mmrech-md.app.n8n.cloud

---

## Workflows

### 1. Master Orchestrator (`orchestrator-master-workflow.json`)
**Webhook:** `/webhook/orchestrator`

Routes incoming tool requests from the ElevenLabs agent to the appropriate sub-workflow.

**Tools Supported:**
- constitution_explorer
- federalist_papers_generator
- scenario_generator
- war_games_simulator
- simulation_explorer
- api_key_manager

**Flow:**
```
Webhook → Parse Request → Route to Tool → Gemini AI → Format Response → Respond
```

---

### 2. Voice-Enabled Q&A (`voice-enabled-qa-workflow.json`)
**Webhook:** `/webhook/voice-qa`

Handles voice input, transcription, AI analysis, and text-to-speech output.

**Flow:**
```
Webhook → Check Input Type → [If audio] Speech-to-Text → Gemini AI → Text-to-Speech → Respond
```

**Voice:** Rachel (clear, professional)

---

### 3. Audio Federalist Papers (`audio-federalist-papers-workflow.json`)
**Webhook:** `/webhook/federalist-audio`

Generates historical essays in Founding Fathers' style with audio narration.

**Flow:**
```
Webhook → Generate Essay (Gemini) → Format for Narration → Text-to-Speech (author-specific voice) → Respond
```

**Voices:**
- Hamilton → Adam (deep, authoritative)
- Madison → Arnold (refined, analytical)
- Jay → Josh (diplomatic, measured)

---

### 4. Agent Signed URL (`agent-signed-url-workflow.json`)
**Webhook:** `/webhook/get-agent-url`

Generates signed URLs for ElevenLabs agent connections.

**Flow:**
```
Webhook → HTTP Request (ElevenLabs API) → Respond with Signed URL
```

---

## Import Instructions

### To n8n Cloud

1. Go to https://mmrech-md.app.n8n.cloud/workflows
2. Click **"Add workflow"** → **"Import from File"**
3. Select the JSON file
4. Click **"Activate"** (toggle switch)
5. Verify webhook URL matches documentation

### From GitHub Clone

```bash
git clone https://github.com/matheus-rech/constitutional-ai-toolkit.git
cd constitutional-ai-toolkit/n8n-workflows/

# Import each workflow to n8n Cloud UI
```

---

## Configuration

### API Keys (n8n Credentials)

These must be configured in n8n Cloud:

1. **ElevenLabs API**
   - Name: `ElevenLabs API`
   - API Key: `sk_5f575f28eb4b4270f253437464843be256374c962e300dee`

2. **Gemini API** (embedded in workflows)
   - API Key: `AIzaSyAWWsNIdJBNIYeKEXFfsKGa5OKs7l7os40`

### Environment Variables

None required - all configuration is in workflow JSON.

---

## Testing

### Test Orchestrator

```bash
curl -X POST https://mmrech-md.app.n8n.cloud/webhook/orchestrator \
  -H "Content-Type: application/json" \
  -d '{
    "tool_name": "constitution_explorer",
    "parameters": {
      "question": "What is the conflict between privacy and transparency?"
    }
  }'
```

### Test Voice Q&A

```bash
curl -X POST https://mmrech-md.app.n8n.cloud/webhook/voice-qa \
  -H "Content-Type: application/json" \
  -d '{
    "hasAudio": false,
    "text": "What are the key principles of constitutional AI?"
  }'
```

### Test Federalist Audio

```bash
curl -X POST https://mmrech-md.app.n8n.cloud/webhook/federalist-audio \
  -H "Content-Type: application/json" \
  -d '{
    "author": "Hamilton",
    "topic": "AI governance"
  }'
```

### Test Signed URL

```bash
curl https://mmrech-md.app.n8n.cloud/webhook/get-agent-url
```

---

## Troubleshooting

### Workflow Not Found

- Verify workflow is activated in n8n Cloud
- Check webhook path matches exactly (case-sensitive)

### API Key Errors

- Check ElevenLabs API key is configured in n8n credentials
- Verify Gemini API key in workflow nodes

### Execution Errors

- View execution history in n8n Cloud
- Check node error messages
- Verify input JSON structure

---

## Backup Strategy

### Automatic Backup

After any workflow changes:

1. Export workflow from n8n Cloud (Download)
2. Save to `n8n-workflows/` directory
3. Commit to Git
4. Push to GitHub

### Manual Backup Schedule

- **After changes:** Immediate export and commit
- **Weekly:** Verify all workflows are backed up
- **Before major updates:** Create git tag for version

### Disaster Recovery

If n8n Cloud data is lost:

1. Clone repository
2. Import all JSON files from `n8n-workflows/`
3. Configure API keys in n8n credentials
4. Activate all workflows
5. Test webhook endpoints

---

## Version Control

### Commit Message Format

```bash
# When adding new workflow
git commit -m "feat: Add [workflow name]"

# When modifying workflow
git commit -m "update: Improve [workflow name] - [what changed]"

# When fixing workflow
git commit -m "fix: Resolve [issue] in [workflow name]"
```

### Example

```bash
git add n8n-workflows/orchestrator-master-workflow.json
git commit -m "update: Improve orchestrator - Add error handling for unknown tools"
git push
```

---

## Monitoring

### n8n Cloud Dashboard

- **Executions:** https://mmrech-md.app.n8n.cloud/executions
- **Usage:** https://mmrech-md.app.n8n.cloud/settings/usage
- **Workflows:** https://mmrech-md.app.n8n.cloud/workflows

### Key Metrics to Monitor

- Total executions per day
- Failed executions
- Average execution time
- Workflow activation status

---

## Future Workflows

When adding new tools to the voice agent:

1. Create sub-workflow JSON
2. Save to `n8n-workflows/[tool-name]-workflow.json`
3. Update master orchestrator to route to new tool
4. Add tool definition to ElevenLabs agent
5. Test end-to-end
6. Commit and push to GitHub

---

**Last Updated:** 2026-01-21

**Maintainer:** Matheus Rech

**Repository:** https://github.com/matheus-rech/constitutional-ai-toolkit
EOF
```

### Step 5: Create .gitignore for Workflows

```bash
cat > ~/Downloads/constitutional-ai-toolkit/n8n-workflows/.gitignore << 'EOF'
# n8n workflow backups only - no local execution data
*.bak
*.tmp
.DS_Store
EOF
```

### Step 6: Commit and Push to GitHub

```bash
cd ~/Downloads/constitutional-ai-toolkit

git add n8n-workflows/
git commit -m "Add n8n workflow backups

- Master orchestrator workflow
- Voice-enabled Q&A workflow
- Audio Federalist Papers workflow
- Agent signed URL workflow
- Comprehensive workflow documentation
- Import and testing instructions"

git push
```

---

## Automated Backup Script (Optional)

Create a script to automate workflow backups:

```bash
cat > ~/Downloads/backup-n8n-workflows.sh << 'EOF'
#!/bin/bash

# Automated n8n Workflow Backup Script

REPO_DIR=~/Downloads/constitutional-ai-toolkit
WORKFLOW_DIR=$REPO_DIR/n8n-workflows
BACKUP_DIR=~/Downloads/n8n-workflow-backups

echo "🔄 Starting n8n workflow backup..."

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Copy workflow JSON files from Downloads to repo
echo "📁 Copying workflow files..."
cp $BACKUP_DIR/*.json $WORKFLOW_DIR/ 2>/dev/null || true

cd $REPO_DIR

# Check if there are changes
if [[ -n $(git status -s n8n-workflows/) ]]; then
    echo "📝 Changes detected, committing..."

    # Add all workflow files
    git add n8n-workflows/

    # Create commit with timestamp
    TIMESTAMP=$(date +"%Y-%m-%d %H:%M:%S")
    git commit -m "backup: Update n8n workflows - $TIMESTAMP"

    # Push to GitHub
    echo "⬆️  Pushing to GitHub..."
    git push

    echo "✅ Backup complete!"
else
    echo "✅ No changes detected, backup up to date."
fi

echo "📊 Current workflows in backup:"
ls -1 $WORKFLOW_DIR/*.json | xargs -n 1 basename
EOF

chmod +x ~/Downloads/backup-n8n-workflows.sh
```

**Usage:**

```bash
# Backup workflows manually
~/Downloads/backup-n8n-workflows.sh

# Schedule with cron (weekly backup every Sunday at 2 AM)
# Run: crontab -e
# Add line:
# 0 2 * * 0 ~/Downloads/backup-n8n-workflows.sh
```

---

## Best Practices

### DO ✅

- Export workflows after every significant change
- Commit with descriptive messages
- Test workflows after importing from backup
- Keep workflow documentation up to date
- Use semantic versioning for major changes

### DON'T ❌

- Edit JSON files manually (use n8n UI)
- Store API keys in workflow JSON (use credentials)
- Delete workflows without backing up first
- Push workflows with test/debugging data
- Forget to activate after import

---

## Recovery Procedure

### If n8n Cloud instance is lost:

1. **Clone repository:**
   ```bash
   git clone https://github.com/matheus-rech/constitutional-ai-toolkit.git
   cd constitutional-ai-toolkit/n8n-workflows/
   ```

2. **Import each workflow:**
   - Go to https://mmrech-md.app.n8n.cloud/workflows
   - For each JSON file, click "Import from File"
   - Activate the workflow

3. **Configure credentials:**
   - Add ElevenLabs API credential
   - Verify Gemini API key in workflows

4. **Test each workflow:**
   - Use curl commands from README
   - Verify webhook URLs
   - Check execution history

5. **Update agent:**
   - Verify tool webhook URLs in ElevenLabs agent
   - Test end-to-end conversation

---

## Workflow Versioning

### Major Version (v1.0, v2.0, etc.)

Create git tag when:
- Breaking changes to webhook structure
- Major feature additions
- Complete architecture refactor

```bash
git tag -a v1.0 -m "Voice agent orchestrator v1.0 - Initial release"
git push origin v1.0
```

### Minor Updates

Regular commits for:
- Bug fixes
- Prompt improvements
- Response formatting
- Error handling

---

## Summary

🎯 **Backup Strategy:**
- **Primary:** n8n Cloud (live execution)
- **Secondary:** GitHub (version control, disaster recovery)
- **Frequency:** After every change
- **Retention:** Full Git history

📦 **Files Backed Up:**
- orchestrator-master-workflow.json
- voice-enabled-qa-workflow.json
- audio-federalist-papers-workflow.json
- agent-signed-url-workflow.json
- README.md (documentation)

🔄 **Sync Process:**
1. Make changes in n8n Cloud
2. Export workflow (Download)
3. Save to repository
4. Git commit and push
5. GitHub becomes source of truth

✅ **Benefits:**
- Disaster recovery
- Version control
- Collaboration
- Documentation
- Audit trail
