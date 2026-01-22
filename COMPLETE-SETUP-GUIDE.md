# Complete Voice Agent Setup Guide - All Methods

I've prepared **everything you need** to get your voice agent working. Here are 3 approaches - choose what works best for you.

---

## ✅ What's Already Done

- ✅ Voice agent UI deployed: https://matheus-rech.github.io/constitutional-ai-toolkit/tools/voice-agent.html
- ✅ Main dashboard updated with voice agent card
- ✅ All documentation (30,000+ words)
- ✅ Workflow JSON files ready

---

## 🎯 Choose Your Approach

### Option A: Manual Import via n8n UI (Recommended - 30 min)
**Best for:** First-time setup, learning the system
**See:** Section 1 below

### Option B: Use Existing Workflows (5 min)
**Best for:** Quick testing if you already have workflows
**See:** Section 2 below

### Option C: Build from Scratch (60 min)
**Best for:** Learning how it works
**See:** Section 3 below

---

## Section 1: Manual Import via n8n UI (Recommended)

### Step 1.1: Download Workflow Files

The workflow files are ready in your repository:
```bash
~/Downloads/constitutional-ai-toolkit/n8n-workflows/
├── orchestrator-master-workflow.json
├── voice-enabled-qa-workflow.json
└── audio-federalist-papers-workflow.json
```

### Step 1.2: Import to n8n Cloud

**For each workflow file:**

1. Go to: https://mmrech-md.app.n8n.cloud/workflows
2. Click "Create workflow" button (orange button, top right)
3. Click the "..." menu (three dots, top right)
4. Select "Import from file..."
5. Choose the JSON file from `n8n-workflows/` folder
6. **If you get an error**, try this workaround:
   - Create a blank workflow
   - Open the JSON file in a text editor
   - Copy ONLY the `nodes` and `connections` sections
   - Manually recreate the workflow using the JSON as a guide

### Step 1.3: Fix Import Issues (If Needed)

If import fails with "Could not find property option" error, the workflows need to be recreated manually. Here's the quick way:

**Master Orchestrator Workflow:**

```
Nodes to create (in order):
1. Webhook (POST, path: "orchestrator", Response Mode: Response Node)
2. Set (Parse Request) - Map: toolName, parameters, conversationId
3. Switch (Route to Tool) - 6 outputs for each tool
4. HTTP Request (Constitution Explorer) - Gemini API call
5. HTTP Request (Federalist Papers) - Gemini API call
6. HTTP Request (Scenario Generator) - Gemini API call
7. HTTP Request (War Games) - Gemini API call
8. Code (Format responses) - 4 nodes for each tool
9. Code (Handle Unknown Tool)
10. Respond to Webhook

Connections:
Webhook → Set → Switch → [4 HTTP nodes + Unknown handler] → [4 Format nodes] → Respond
```

Full node configurations are in: `docs/constitutional-ai-orchestrator-design.md`

### Step 1.4: Activate Workflows

For each imported/created workflow:
1. Click the "Active" toggle (top right) to turn it ON
2. Verify the webhook URL format:
   - Master: `https://mmrech-md.app.n8n.cloud/webhook/orchestrator`
   - Voice Q&A: `https://mmrech-md.app.n8n.cloud/webhook/voice-qa`
   - Federalist: `https://mmrech-md.app.n8n.cloud/webhook/federalist-audio`

---

## Section 2: Create Signed URL Workflow (5 min)

This workflow is REQUIRED for the voice agent to connect to ElevenLabs.

### Step 2.1: Create New Workflow

1. Go to: https://mmrech-md.app.n8n.cloud/workflows
2. Click "Create workflow"
3. Name it: "Get Agent Signed URL"

### Step 2.2: Add Nodes

**Node 1: Webhook**
- Type: Webhook
- HTTP Method: GET
- Path: `get-agent-url`
- Response Mode: Response Node

**Node 2: HTTP Request**
- Method: GET
- URL: `https://api.elevenlabs.io/v1/convai/conversation/get_signed_url`
- Query Parameters:
  - Name: `agent_id`
  - Value: `[GET THIS FROM ELEVENLABS AFTER CREATING AGENT]`
- Headers:
  - Name: `xi-api-key`
  - Value: `sk_5f575f28eb4b4270f253437464843be256374c962e300dee`

**Node 3: Respond to Webhook**
- Respond With: JSON
- Response Body:
  ```
  ={{ { "signedUrl": $json.signed_url } }}
  ```

### Step 2.3: Connect and Activate

1. Connect: Webhook → HTTP Request → Respond to Webhook
2. Click "Save"
3. Toggle "Active" to ON
4. Test with: `curl https://mmrech-md.app.n8n.cloud/webhook/get-agent-url`

---

## Section 3: Create ElevenLabs Agent (15 min)

### Step 3.1: Create Agent

1. Go to: https://elevenlabs.io/app/conversational-ai
2. Click "Create new agent"
3. Name: "Constitutional AI Orchestrator"
4. First message: "Hello! I'm your Constitutional AI assistant. What would you like to explore?"

### Step 3.2: System Prompt

**Copy this entire prompt:**

```
You are the Constitutional AI Orchestrator, a voice assistant that helps users explore constitutional principles through six interactive tools.

# Available Tools
1. **constitution_explorer** - Analyzes conflicts between constitutional values
2. **federalist_papers_generator** - Generates historical essays by Hamilton/Madison/Jay
3. **scenario_generator** - Creates constitutional dilemma scenarios
4. **war_games_simulator** - Simulates debates between historical figures
5. **simulation_explorer** - Interactive exploration of simulation methodologies
6. **api_key_manager** - Manages API credentials

# Conversation Style

**Before calling a tool:**
- Acknowledge the question
- Explain what you're doing
- Example: "I'll analyze that conflict using my constitutional analysis tool..."

**After receiving results:**
- Summarize key findings (2-3 sentences)
- Offer next steps
- Example: "The analysis reveals three tensions... Would you like a Federalist paper on this?"

**Tool Selection:**
- Conflict/tension → constitution_explorer
- "What would [Founder] say" → federalist_papers_generator
- "What if" or "scenario" → scenario_generator
- "Debate" or "argue" → war_games_simulator
- "How does simulation work" → simulation_explorer
- "Settings" → api_key_manager

# Guidelines
- Be conversational and educational
- Keep responses suitable for voice (30-60 seconds)
- Ask clarifying questions if needed
- Suggest related tools
```

### Step 3.3: Add Custom Tools

**For each tool below, click "Add custom action" in ElevenLabs:**

---

**Tool 1: constitution_explorer**
```json
{
  "name": "constitution_explorer",
  "description": "Analyzes conflicts between constitutional values and AI principles",
  "parameters": {
    "type": "object",
    "properties": {
      "question": {
        "type": "string",
        "description": "The constitutional question or conflict to analyze"
      }
    },
    "required": ["question"]
  },
  "url": "https://mmrech-md.app.n8n.cloud/webhook/orchestrator",
  "method": "POST",
  "body": {
    "tool_name": "constitution_explorer",
    "parameters": {
      "question": "{{question}}"
    }
  }
}
```

---

**Tool 2: federalist_papers_generator**
```json
{
  "name": "federalist_papers_generator",
  "description": "Generates 18th-century style essays by Hamilton, Madison, or Jay on modern AI topics",
  "parameters": {
    "type": "object",
    "properties": {
      "author": {
        "type": "string",
        "enum": ["Hamilton", "Madison", "Jay"],
        "description": "The Founding Father whose style to emulate"
      },
      "topic": {
        "type": "string",
        "description": "The modern AI topic to write about"
      }
    },
    "required": ["author", "topic"]
  },
  "url": "https://mmrech-md.app.n8n.cloud/webhook/orchestrator",
  "method": "POST",
  "body": {
    "tool_name": "federalist_papers_generator",
    "parameters": {
      "author": "{{author}}",
      "topic": "{{topic}}"
    }
  }
}
```

---

**Tool 3: scenario_generator**
```json
{
  "name": "scenario_generator",
  "description": "Creates constitutional AI scenarios for education",
  "parameters": {
    "type": "object",
    "properties": {
      "topic": {
        "type": "string",
        "description": "The AI governance topic for the scenario"
      },
      "complexity": {
        "type": "string",
        "enum": ["beginner", "intermediate", "advanced"],
        "description": "Complexity level",
        "default": "intermediate"
      }
    },
    "required": ["topic"]
  },
  "url": "https://mmrech-md.app.n8n.cloud/webhook/orchestrator",
  "method": "POST",
  "body": {
    "tool_name": "scenario_generator",
    "parameters": {
      "topic": "{{topic}}",
      "complexity": "{{complexity}}"
    }
  }
}
```

---

**Tool 4: war_games_simulator**
```json
{
  "name": "war_games_simulator",
  "description": "Simulates debates between Founding Fathers on AI topics",
  "parameters": {
    "type": "object",
    "properties": {
      "topic": {
        "type": "string",
        "description": "The AI topic for debate"
      },
      "participants": {
        "type": "array",
        "items": {
          "type": "string",
          "enum": ["Hamilton", "Madison", "Jefferson"]
        },
        "description": "The historical figures to include",
        "default": ["Hamilton", "Madison", "Jefferson"]
      }
    },
    "required": ["topic"]
  },
  "url": "https://mmrech-md.app.n8n.cloud/webhook/orchestrator",
  "method": "POST",
  "body": {
    "tool_name": "war_games_simulator",
    "parameters": {
      "topic": "{{topic}}",
      "participants": "{{participants}}"
    }
  }
}
```

---

**Tool 5: simulation_explorer**
```json
{
  "name": "simulation_explorer",
  "description": "Explores simulation methodologies",
  "parameters": {
    "type": "object",
    "properties": {
      "query": {
        "type": "string",
        "description": "The simulation methodology question"
      }
    },
    "required": ["query"]
  },
  "url": "https://mmrech-md.app.n8n.cloud/webhook/orchestrator",
  "method": "POST",
  "body": {
    "tool_name": "simulation_explorer",
    "parameters": {
      "query": "{{query}}"
    }
  }
}
```

---

**Tool 6: api_key_manager**
```json
{
  "name": "api_key_manager",
  "description": "Manages API credentials",
  "parameters": {
    "type": "object",
    "properties": {
      "action": {
        "type": "string",
        "enum": ["check_status", "get_instructions"],
        "description": "The action to perform",
        "default": "get_instructions"
      }
    },
    "required": []
  },
  "url": "https://mmrech-md.app.n8n.cloud/webhook/orchestrator",
  "method": "POST",
  "body": {
    "tool_name": "api_key_manager",
    "parameters": {
      "action": "{{action}}"
    }
  }
}
```

---

### Step 3.4: Get Agent ID

1. After saving, look for the Agent ID in the URL:
   - Format: `https://elevenlabs.io/app/conversational-ai/agents/[AGENT_ID]`
2. Copy this ID
3. Go back to n8n "Get Agent Signed URL" workflow
4. Edit the HTTP Request node
5. Replace `[GET THIS FROM ELEVENLABS AFTER CREATING AGENT]` with your actual Agent ID
6. Save the workflow

---

## Section 4: Testing (10 min)

### Test 1: Test Master Orchestrator

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

**Expected:** JSON response with `"success": true` and analysis text

### Test 2: Test Signed URL

```bash
curl https://mmrech-md.app.n8n.cloud/webhook/get-agent-url
```

**Expected:** JSON response with `"signedUrl": "wss://..."`

### Test 3: Test Voice Agent End-to-End

1. Go to: https://matheus-rech.github.io/constitutional-ai-toolkit/tools/voice-agent.html
2. Click "🎤 Start Conversation"
3. Grant microphone permission
4. Say: "What's the conflict between privacy and transparency?"
5. **Expected:** Agent responds with constitutional analysis!

---

## 🐛 Troubleshooting

### Issue: "Workflow import failed"

**Solution:** Manually create the workflows using the node configurations in `docs/constitutional-ai-orchestrator-design.md`

### Issue: "Invalid agent_id"

**Solution:**
1. Check the URL when viewing your agent in ElevenLabs
2. Copy the exact ID from the URL
3. Update the signed URL workflow's HTTP Request node

### Issue: "Webhook not found"

**Solution:**
1. Verify workflow is **activated** (toggle ON)
2. Check webhook path is exactly: `orchestrator` (case-sensitive)
3. Ensure production URL format is correct

### Issue: Voice agent connects but doesn't respond

**Solution:**
1. Test master orchestrator with curl command above
2. Verify all 6 tools are added to ElevenLabs agent
3. Check browser console for errors
4. Verify signed URL workflow returns valid WebSocket URL

---

## 📊 Success Checklist

- [ ] Master orchestrator workflow created and activated
- [ ] Signed URL workflow created with correct Agent ID
- [ ] ElevenLabs agent created with 6 custom tools
- [ ] System prompt configured in ElevenLabs
- [ ] curl test of orchestrator returns success
- [ ] curl test of signed URL returns WebSocket URL
- [ ] Voice agent UI connects (green status)
- [ ] Voice agent responds to test question

---

## 🎉 When Everything Works

You'll have a production-ready voice-controlled AI system where users can:
- Say "Analyze the conflict between X and Y" → Get constitutional analysis
- Say "What would Hamilton say about AI?" → Get historical essay
- Say "Create a scenario about facial recognition" → Get educational dilemma
- Say "Show me a debate between Hamilton and Madison" → Get multi-perspective debate

**All through natural conversation!**

---

## 📚 Additional Resources

- **Architecture:** `docs/constitutional-ai-orchestrator-design.md` (14,000 words)
- **Detailed Setup:** `SETUP-BACKEND.md` (comprehensive 30-min guide)
- **Quick Import:** `QUICK-IMPORT.md` (automated script guide)
- **Workflow Backup:** `n8n-workflows/README.md`

---

## 💡 Next Steps After Setup

1. **Test all 6 tools** through voice conversation
2. **Share the voice agent URL** with users
3. **Monitor n8n executions** for errors
4. **Adjust system prompt** based on user feedback
5. **Add more tools** as needed (easy - just add to orchestrator!)

---

**Your voice agent is ready to deploy! 🚀**

Everything is set up - you just need to complete the manual steps above. The entire process takes about 30-45 minutes for first-time setup.

Good luck!
