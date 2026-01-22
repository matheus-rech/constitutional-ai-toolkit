# Quick Import - 5 Minutes to Import All Workflows! 🚀

This is the **fastest way** to get your workflows imported to n8n Cloud.

---

## Step 1: Get Your n8n API Key (2 minutes)

1. **Open n8n Cloud in your browser:**
   ```
   https://mmrech-md.app.n8n.cloud/settings/api
   ```

2. **Click "Create API Key"** button

3. **Copy the API key** (starts with `n8n_api_...`)

4. **Export it in your terminal:**
   ```bash
   export N8N_API_KEY='n8n_api_paste_your_key_here'
   ```

---

## Step 2: Run the Import Script (3 minutes)

```bash
cd ~/Downloads/constitutional-ai-toolkit
./import-workflows.sh
```

**That's it!** The script will:
- ✅ Import all 3 workflows to n8n Cloud
- ✅ Activate them automatically
- ✅ Show you the webhook URLs
- ✅ Give you next steps

---

## Expected Output

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Voice Agent Orchestrator - n8n Workflow Import Script
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

✓ N8N_API_KEY found

Importing workflows from: n8n-workflows

📦 Importing: orchestrator-master-workflow
   ✓ Imported successfully (ID: abc123)
   🔄 Activating workflow...
   ✓ Activated

📦 Importing: voice-enabled-qa-workflow
   ✓ Imported successfully (ID: def456)
   🔄 Activating workflow...
   ✓ Activated

📦 Importing: audio-federalist-papers-workflow
   ✓ Imported successfully (ID: ghi789)
   🔄 Activating workflow...
   ✓ Activated

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Import Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  ✓ Successful: 3
  ✗ Failed: 0

🎉 All workflows imported successfully!

Next steps:
1. Create the Signed URL workflow (see SETUP-BACKEND.md Step 2)
2. Set up ElevenLabs agent (see SETUP-BACKEND.md Step 3)
3. Test the workflows with curl commands

Webhook URLs:
  Master Orchestrator: https://mmrech-md.app.n8n.cloud/webhook/orchestrator
  Voice Q&A: https://mmrech-md.app.n8n.cloud/webhook/voice-qa
  Federalist Papers: https://mmrech-md.app.n8n.cloud/webhook/federalist-audio

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## What Just Happened?

The script just:

1. **Connected to your n8n Cloud instance** using the API key
2. **Imported 3 workflow JSON files:**
   - Master Orchestrator (routes all 6 tools)
   - Voice-Enabled Q&A (voice input/output)
   - Audio Federalist Papers (historical essays with audio)
3. **Activated all workflows** so they're ready to receive requests
4. **Gave you the webhook URLs** you'll need for testing

---

## Next Steps (25 minutes remaining)

Now that workflows are imported, you need to:

### 1. Create Signed URL Workflow (5 min)
- Follow **SETUP-BACKEND.md - Step 2**
- This is a simple 3-node workflow
- Generates temporary WebSocket URLs for voice connections

### 2. Set Up ElevenLabs Agent (10 min)
- Follow **SETUP-BACKEND.md - Step 3**
- Copy/paste the system prompt
- Add all 6 tool definitions (JSON provided)

### 3. Test Everything (10 min)
- Run curl commands from **SETUP-BACKEND.md - Testing**
- Try the voice agent at: https://matheus-rech.github.io/constitutional-ai-toolkit/tools/voice-agent.html

---

## Troubleshooting

### Error: "N8N_API_KEY environment variable not set"

**Solution:**
```bash
# Get API key from: https://mmrech-md.app.n8n.cloud/settings/api
export N8N_API_KEY='your-api-key-here'
./import-workflows.sh
```

### Error: "HTTP 401 Unauthorized"

**Solution:**
- Your API key is invalid or expired
- Get a new one from n8n settings
- Make sure to copy the entire key (starts with `n8n_api_`)

### Error: "HTTP 403 Forbidden"

**Solution:**
- Your API key doesn't have permission to create workflows
- Check your n8n Cloud plan and permissions
- Try creating a workflow manually to test permissions

### Error: "File not found"

**Solution:**
```bash
# Make sure you're in the correct directory
cd ~/Downloads/constitutional-ai-toolkit
ls n8n-workflows/
# You should see the 3 JSON files
./import-workflows.sh
```

---

## Manual Import Alternative

If the script doesn't work, you can import manually:

1. Go to: https://mmrech-md.app.n8n.cloud/workflows
2. Click "Add workflow" → "Import from File"
3. Select each JSON file from `n8n-workflows/` directory
4. Click "Activate" toggle for each workflow

See **SETUP-BACKEND.md** for detailed manual import instructions.

---

## What's Already Done ✅

- ✅ Voice agent UI deployed to GitHub Pages
- ✅ Main dashboard updated
- ✅ All documentation created
- ✅ Workflow JSON files ready
- ✅ **You just imported 3 workflows!** ← You are here

## What's Next ⏳

- ⏳ Create signed URL workflow (5 min)
- ⏳ Set up ElevenLabs agent (10 min)
- ⏳ Test everything (10 min)

---

**Total time to complete setup:** 25 minutes remaining 🎯
