# Voice Agent Backend Setup - Complete Guide

**Time Required:** 30 minutes
**Prerequisites:** n8n Cloud account, ElevenLabs account

---

## ✅ What's Already Done

- ✅ Voice agent UI deployed to GitHub Pages
- ✅ Main dashboard updated with voice agent card
- ✅ All documentation created (30,000+ words)
- ✅ Workflow JSON files ready in `n8n-workflows/` directory

---

## 🚀 Quick Setup (3 Steps)

### Step 1: Import Workflows to n8n Cloud (15 min)

#### 1.1 Import Master Orchestrator

1. **Go to:** https://mmrech-md.app.n8n.cloud/workflows
2. **Click:** "Add workflow" button (top right)
3. **Select:** "Import from File..." or "Import from URL..."
4. **Choose file:** `n8n-workflows/orchestrator-master-workflow.json`
5. **Review:** The workflow should show:
   - Webhook node (path: `orchestrator`)
   - Parse Request node
   - Route to Tool (Switch node with 6 outputs)
   - 4 Gemini nodes (Constitution Explorer, Federalist Papers, Scenario Generator, War Games)
   - 4 Format Response nodes
   - Handle Unknown Tool node
   - Respond to Agent node
6. **Click:** "Save" button
7. **Activate:** Toggle the "Active" switch (top right) to ON
8. **Copy URL:** The production webhook URL will be:
   ```
   https://mmrech-md.app.n8n.cloud/webhook/orchestrator
   ```

#### 1.2 Import Voice-Enabled Q&A (Optional - for reference)

1. **Import:** `n8n-workflows/voice-enabled-qa-workflow.json`
2. **Activate:** Toggle to ON
3. **Webhook URL:** `https://mmrech-md.app.n8n.cloud/webhook/voice-qa`

#### 1.3 Import Audio Federalist Papers (Optional - for reference)

1. **Import:** `n8n-workflows/audio-federalist-papers-workflow.json`
2. **Activate:** Toggle to ON
3. **Webhook URL:** `https://mmrech-md.app.n8n.cloud/webhook/federalist-audio`

---

### Step 2: Create Signed URL Workflow (5 min)

This workflow generates temporary WebSocket URLs for the voice agent to connect to ElevenLabs.

#### 2.1 Create New Workflow

1. **Go to:** https://mmrech-md.app.n8n.cloud/workflows
2. **Click:** "Add workflow" → "Blank"
3. **Name it:** "Get Agent Signed URL"

#### 2.2 Add Webhook Trigger

1. **Click:** "+" button to add node
2. **Search:** "Webhook"
3. **Configure:**
   - HTTP Method: `GET`
   - Path: `get-agent-url`
   - Response Mode: `Response Node`
4. **Click:** "Save"

#### 2.3 Add HTTP Request Node

1. **Click:** "+" after Webhook node
2. **Search:** "HTTP Request"
3. **Configure:**
   - Method: `GET`
   - URL: `https://api.elevenlabs.io/v1/convai/conversation/get_signed_url`
   - **Query Parameters:**
     - Name: `agent_id`
     - Value: `YOUR_AGENT_ID` (you'll get this in Step 3)
   - **Headers:**
     - Name: `xi-api-key`
     - Value: `sk_5f575f28eb4b4270f253437464843be256374c962e300dee`
4. **Click:** "Save"

#### 2.4 Add Respond to Webhook Node

1. **Click:** "+" after HTTP Request node
2. **Search:** "Respond to Webhook"
3. **Configure:**
   - Respond With: `JSON`
   - Response Body:
     ```
     ={{ { "signedUrl": $json.signed_url } }}
     ```
4. **Click:** "Save"

#### 2.5 Connect and Activate

1. **Connect:** Webhook → HTTP Request → Respond to Webhook
2. **Save:** Click "Save" button
3. **Activate:** Toggle "Active" to ON
4. **Copy URL:** `https://mmrech-md.app.n8n.cloud/webhook/get-agent-url`

---

### Step 3: Create ElevenLabs Agent (10 min)

#### 3.1 Create New Agent

1. **Go to:** https://elevenlabs.io/app/conversational-ai
2. **Click:** "Create new agent" button
3. **Name:** "Constitutional AI Orchestrator"
4. **First message:** "Hello! I'm your Constitutional AI assistant. I can help you explore constitutional principles, generate historical essays, create scenarios, and simulate debates. What would you like to explore today?"

#### 3.2 Configure System Prompt

**System Prompt (copy this exactly):**

```
You are the Constitutional AI Orchestrator, a voice assistant that helps users explore constitutional principles, governance dilemmas, and AI ethics through six interactive tools.

# Your Role
You are a knowledgeable guide who helps users access and understand constitutional AI concepts through natural conversation. You explain what you're doing, provide context, and offer helpful next steps.

# Available Tools
You have access to six powerful tools:

1. **constitution_explorer** - Analyzes conflicts between constitutional values and AI principles
   - Use when: User asks about tensions, conflicts, or trade-offs (privacy vs transparency, freedom vs safety, etc.)
   - Example questions: "What's the conflict between X and Y?" or "Analyze the tension in..."

2. **federalist_papers_generator** - Generates historical essays by Hamilton, Madison, or Jay on modern AI topics
   - Use when: User wants historical perspectives or asks "What would Hamilton/Madison/Jay say about..."
   - Authors available: Hamilton (bold, energetic), Madison (analytical), Jay (diplomatic)

3. **scenario_generator** - Creates constitutional dilemma scenarios for education
   - Use when: User wants to explore a "what if" situation or practice decision-making
   - Creates: Realistic scenarios with stakeholders, questions, and decision points

4. **war_games_simulator** - Simulates debates between historical figures on AI topics
   - Use when: User wants to see different perspectives clash or asks for a "debate"
   - Participants: Hamilton, Madison, Jefferson, and others

5. **simulation_explorer** - Interactive exploration of simulation methodologies
   - Use when: User asks about how simulations work or wants to understand modeling

6. **api_key_manager** - Manages API credentials
   - Use when: User mentions configuration, settings, or API keys

# Conversation Style

**Before calling a tool:**
- Acknowledge the user's question
- Briefly explain what you're about to do
- Example: "Great question! I'll analyze that conflict between privacy and transparency using my constitutional analysis tool..."

**After receiving results:**
- Summarize the key findings in 2-3 sentences
- Highlight the most important insight
- Offer next steps or related explorations
- Example: "The analysis reveals three core tensions... The key insight is that... Would you like me to generate a Federalist paper exploring this further?"

**General guidelines:**
- Be conversational and educational
- Use analogies when helpful
- Ask clarifying questions if the user's request is ambiguous
- Suggest related tools or follow-up questions
- Keep responses concise for voice interaction (aim for 30-60 seconds of speech)

# Tool Selection Logic

- Conflict/tension/trade-off words → constitution_explorer
- "What would [Founder] say" or "historical perspective" → federalist_papers_generator
- "What if" or "scenario" or "dilemma" → scenario_generator
- "Debate" or "argue" or "different perspectives" → war_games_simulator
- "How does simulation work" → simulation_explorer
- "Settings" or "configure" → api_key_manager

# Example Conversations

User: "What's the conflict between AI transparency and privacy?"
You: "Excellent question! I'll analyze that fundamental tension between transparency and privacy in AI systems..."
[Call constitution_explorer]
You: "The analysis shows three key conflicts: First, transparency requirements can expose personal data patterns. Second, privacy protections can hide algorithmic bias. Third, there's a trade-off between explainability and data minimization. Would you like me to create a scenario exploring this, or generate a Federalist paper from Hamilton's perspective on AI transparency?"

User: "What would Hamilton say about AI regulation?"
You: "Great! I'll generate a Federalist paper in Hamilton's authoritative voice about AI governance..."
[Call federalist_papers_generator with author: "Hamilton", topic: "AI regulation"]
You: "Hamilton argues for strong federal oversight of AI systems, drawing parallels to his views on federal banking. He emphasizes the need for energetic government action to prevent AI-driven concentration of power. Would you like me to show you Madison's counter-argument in a debate format?"

# Remember
- You are helpful, educational, and conversational
- Always explain before and after tool calls
- Offer logical next steps
- Keep responses suitable for voice narration
- Be enthusiastic about constitutional principles!
```

#### 3.3 Configure Voice Settings

1. **Voice:** Rachel (or your preferred voice)
2. **Language:** English
3. **Model:** Conversational

#### 3.4 Add Custom Tools (6 tools)

**Important:** For each tool, you'll need to:
1. Click "Add custom action" or "Add tool"
2. Enter the tool definition
3. Use the n8n webhook URL: `https://mmrech-md.app.n8n.cloud/webhook/orchestrator`

---

**Tool 1: constitution_explorer**

```json
{
  "type": "custom",
  "name": "constitution_explorer",
  "description": "Analyzes conflicts between constitutional values, AI principles, and ethical considerations. Returns structured analysis with core values, potential conflicts, key considerations, and framework for resolution.",
  "parameters": {
    "type": "object",
    "properties": {
      "question": {
        "type": "string",
        "description": "The constitutional question, conflict, or ethical dilemma to analyze. Example: 'What is the conflict between privacy and transparency in AI?'"
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
  "type": "custom",
  "name": "federalist_papers_generator",
  "description": "Generates 18th-century style constitutional essays by Hamilton, Madison, or Jay (as PUBLIUS) on modern AI governance topics. Returns 800-1000 word historically accurate essay with period-appropriate language and rhetorical style.",
  "parameters": {
    "type": "object",
    "properties": {
      "author": {
        "type": "string",
        "enum": ["Hamilton", "Madison", "Jay"],
        "description": "The Founding Father whose writing style to emulate. Hamilton: bold and energetic, pro-strong-governance. Madison: analytical and cautious, balance-focused. Jay: diplomatic and measured, federalist."
      },
      "topic": {
        "type": "string",
        "description": "The modern AI governance topic to write about. Example: 'artificial intelligence regulation' or 'algorithmic transparency'"
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
  "type": "custom",
  "name": "scenario_generator",
  "description": "Creates compelling constitutional AI scenarios for education. Generates realistic situations with stakeholders, constitutional questions, decision points, and potential consequences. Suitable for teaching and discussion.",
  "parameters": {
    "type": "object",
    "properties": {
      "topic": {
        "type": "string",
        "description": "The AI governance topic for the scenario. Example: 'facial recognition in public spaces' or 'algorithmic hiring decisions'"
      },
      "complexity": {
        "type": "string",
        "enum": ["beginner", "intermediate", "advanced"],
        "description": "The complexity level of the scenario. Beginner: simple choices. Intermediate: multiple stakeholders. Advanced: complex trade-offs.",
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
  "type": "custom",
  "name": "war_games_simulator",
  "description": "Simulates structured debates between historical Founding Fathers on modern AI topics. Creates opening statements, rebuttals, and closing arguments in each participant's distinctive rhetorical style.",
  "parameters": {
    "type": "object",
    "properties": {
      "topic": {
        "type": "string",
        "description": "The AI governance topic for debate. Example: 'AI regulation' or 'algorithmic accountability'"
      },
      "participants": {
        "type": "array",
        "items": {
          "type": "string",
          "enum": ["Hamilton", "Madison", "Jefferson"]
        },
        "description": "The historical figures to include in the debate. Default: Hamilton, Madison, Jefferson",
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
  "type": "custom",
  "name": "simulation_explorer",
  "description": "Interactive exploration of simulation methodologies including Agent-Based Models, Monte Carlo, System Dynamics. Educational tool for understanding how simulations work.",
  "parameters": {
    "type": "object",
    "properties": {
      "query": {
        "type": "string",
        "description": "The simulation methodology question. Example: 'How does Agent-Based Modeling work?' or 'Explain Monte Carlo simulation'"
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
  "type": "custom",
  "name": "api_key_manager",
  "description": "Manages API credentials and configuration settings. Helps users configure their Gemini API keys securely in the browser.",
  "parameters": {
    "type": "object",
    "properties": {
      "action": {
        "type": "string",
        "enum": ["check_status", "get_instructions"],
        "description": "The action to perform. check_status: verify if API key is configured. get_instructions: get setup instructions.",
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

#### 3.5 Save and Get Agent ID

1. **Click:** "Save" or "Publish" button
2. **Copy Agent ID:** Look for the agent ID in the URL or settings:
   - URL format: `https://elevenlabs.io/app/conversational-ai/agents/[AGENT_ID]`
   - Or check the agent settings page
3. **Important:** Save this Agent ID - you'll need it for the signed URL workflow!

#### 3.6 Update Signed URL Workflow with Agent ID

1. **Go back to n8n:** https://mmrech-md.app.n8n.cloud/workflows
2. **Open:** "Get Agent Signed URL" workflow
3. **Edit HTTP Request node:**
   - Find the `agent_id` query parameter
   - Replace `YOUR_AGENT_ID` with your actual Agent ID
4. **Save** the workflow

---

## 🧪 Testing Your Setup

### Test 1: Test Master Orchestrator Workflow

```bash
# Test Constitution Explorer
curl -X POST https://mmrech-md.app.n8n.cloud/webhook/orchestrator \
  -H "Content-Type: application/json" \
  -d '{
    "tool_name": "constitution_explorer",
    "parameters": {
      "question": "What is the conflict between privacy and transparency in AI?"
    }
  }'
```

**Expected response:**
```json
{
  "success": true,
  "tool": "constitution_explorer",
  "result": {
    "responseText": "The analysis reveals several key tensions..."
  }
}
```

### Test 2: Test Federalist Papers

```bash
curl -X POST https://mmrech-md.app.n8n.cloud/webhook/orchestrator \
  -H "Content-Type: application/json" \
  -d '{
    "tool_name": "federalist_papers_generator",
    "parameters": {
      "author": "Hamilton",
      "topic": "AI regulation"
    }
  }'
```

### Test 3: Test Signed URL Endpoint

```bash
curl https://mmrech-md.app.n8n.cloud/webhook/get-agent-url
```

**Expected response:**
```json
{
  "signedUrl": "wss://api.elevenlabs.io/v1/convai/conversation?signed_url=..."
}
```

### Test 4: Test End-to-End Voice Conversation

1. **Go to:** https://matheus-rech.github.io/constitutional-ai-toolkit/tools/voice-agent.html
2. **Click:** "🎤 Start Conversation"
3. **Grant:** Microphone permission
4. **Wait:** For "Connected - Listening" status
5. **Say:** "What's the conflict between privacy and transparency?"
6. **Listen:** Agent should respond with analysis!

---

## 🎉 Success Criteria

Your setup is complete when:

- ✅ All 3 workflows imported and activated in n8n
- ✅ Signed URL workflow created and returns valid WebSocket URL
- ✅ ElevenLabs agent created with 6 custom tools
- ✅ All curl tests return successful responses
- ✅ Voice agent UI connects and responds to questions

---

## 🐛 Troubleshooting

### Problem: "Webhook not found" error

**Solution:**
- Verify workflow is **activated** (toggle should be ON)
- Check webhook path matches exactly (case-sensitive)
- Ensure you're using production URL: `https://mmrech-md.app.n8n.cloud/webhook/...`

### Problem: "Invalid API key" from ElevenLabs

**Solution:**
- Verify ElevenLabs API key in signed URL workflow HTTP Request node
- Check header is exactly: `xi-api-key` (lowercase)

### Problem: "Invalid agent_id" error

**Solution:**
- Copy the Agent ID from ElevenLabs dashboard
- Update the signed URL workflow with correct Agent ID
- Save and reactivate the workflow

### Problem: Voice agent connects but doesn't respond

**Solution:**
- Check browser console for errors
- Verify signed URL workflow returns valid WebSocket URL
- Test master orchestrator with curl to ensure it's working
- Check ElevenLabs agent has all 6 tools configured correctly

### Problem: Gemini API errors

**Solution:**
- Verify Gemini API key in workflow nodes
- Check API key hasn't expired or hit rate limits
- Ensure API key is: `AIzaSyAWWsNIdJBNIYeKEXFfsKGa5OKs7l7os40`

---

## 📊 Architecture Summary

```
┌─────────────────────────────────────────────────┐
│  User (GitHub Pages)                            │
│  https://matheus-rech.github.io/...             │
│                   ↓                              │
│  1. Request signed URL                          │
│  → https://mmrech-md.app.n8n.cloud/            │
│     webhook/get-agent-url                       │
│                   ↓                              │
│  2. Get WebSocket URL from ElevenLabs API      │
│                   ↓                              │
│  3. Connect to ElevenLabs WebSocket            │
│  → Voice conversation starts                    │
│                   ↓                              │
│  4. User speaks: "Analyze privacy vs transparency"│
│                   ↓                              │
│  5. ElevenLabs agent extracts intent            │
│  → Calls constitution_explorer tool             │
│  → POST to webhook/orchestrator                 │
│                   ↓                              │
│  6. n8n master orchestrator routes request     │
│  → Calls Gemini AI                             │
│  → Formats response                             │
│                   ↓                              │
│  7. Response returns to ElevenLabs             │
│  → Agent speaks result to user                  │
└─────────────────────────────────────────────────┘
```

---

## 🔗 Important URLs

**Live Site:**
- Main Dashboard: https://matheus-rech.github.io/constitutional-ai-toolkit/
- Voice Agent: https://matheus-rech.github.io/constitutional-ai-toolkit/tools/voice-agent.html

**n8n Cloud:**
- Workflows: https://mmrech-md.app.n8n.cloud/workflows
- Executions: https://mmrech-md.app.n8n.cloud/executions

**ElevenLabs:**
- Agents Dashboard: https://elevenlabs.io/app/conversational-ai
- API Documentation: https://elevenlabs.io/docs/conversational-ai

**Gemini API:**
- Console: https://ai.google.dev
- API Key: `AIzaSyAWWsNIdJBNIYeKEXFfsKGa5OKs7l7os40`

---

## 💰 Cost Estimate

**Monthly Operating Costs:**

| Service | Usage | Cost |
|---------|-------|------|
| ElevenLabs | ~100 conversations/month | $10-30 |
| Gemini API | Text generation | FREE (current tier) |
| n8n Cloud | Workflow executions | Included in plan |
| GitHub Pages | Static hosting | FREE |
| **Total** | | **$10-30/month** |

---

**Created:** 2026-01-21
**Author:** Constitutional AI Toolkit Team
**Version:** 1.0
