# Final Setup Steps - Voice Agent Orchestrator

## ✅ What's Already Done

- ✅ Voice agent UI deployed: https://matheus-rech.github.io/constitutional-ai-toolkit/tools/voice-agent.html
- ✅ ElevenLabs MCP server configured in Claude Desktop (`~/.claude/claude_desktop_config.json`)
- ✅ Master Orchestrator workflow created in n8n with Webhook trigger configured
  - Workflow ID: `t7738vjG939yT6pK`
  - Webhook URL: `https://mmrech-md.app.n8n.cloud/webhook/orchestrator`
  - HTTP Method: POST
  - Response Mode: Using 'Respond to Webhook' Node

---

## 🔄 Next: Restart Claude Desktop

**IMPORTANT**: You must restart Claude Desktop for the ElevenLabs MCP server to become available.

After restart, you'll be able to use ElevenLabs MCP tools to programmatically create the agent with all 6 tools.

---

## 📋 Remaining Tasks

### Task 1: Complete Master Orchestrator Workflow (15-20 min)

The webhook is created. Now add these nodes:

#### 1. Add "Set" Node (Parse Request)
- Click the "+" below Webhook
- Search for "Set" node
- Configure to extract:
  - `tool_name` from `{{ $json.body.tool_name }}`
  - `parameters` from `{{ $json.body.parameters }}`
  - `conversationId` from `{{ $json.body.conversationId }}`

#### 2. Add "Switch" Node (Route to Tools)
- Click "+" after Set
- Search for "Switch" node
- Mode: "Rules"
- Add 6 routing rules:
  1. `{{ $json.tool_name }}` equals `constitution_explorer`
  2. `{{ $json.tool_name }}` equals `federalist_papers_generator`
  3. `{{ $json.tool_name }}` equals `scenario_generator`
  4. `{{ $json.tool_name }}` equals `war_games_simulator`
  5. `{{ $json.tool_name }}` equals `simulation_explorer`
  6. `{{ $json.tool_name }}` equals `api_key_manager`
  7. Default/Fallback

#### 3. Add HTTP Request Nodes (6 tools)

For EACH tool output from Switch, add an HTTP Request node:

**Configuration for all HTTP nodes:**
- Method: POST
- URL: `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash-exp:generateContent?key=YOUR_GEMINI_API_KEY`
- Headers:
  - `Content-Type`: `application/json`
- Body (JSON):
```json
{
  "contents": [{
    "parts": [{
      "text": "{{ $json.parameters.question || $json.parameters.topic || $json.parameters.query }}"
    }]
  }],
  "generationConfig": {
    "temperature": 0.7,
    "maxOutputTokens": 2048
  }
}
```

**Note**: You'll need your Gemini API key from https://makersuite.google.com/app/apikey

#### 4. Add "Code" Nodes (Format Responses)

After each HTTP Request, add a Code node with:

```javascript
// Extract the AI response
const response = items[0].json.candidates[0].content.parts[0].text;

return [{
  json: {
    success: true,
    tool_name: "constitution_explorer", // Change per tool
    response: response,
    conversationId: items[0].json.conversationId
  }
}];
```

#### 5. Add "Respond to Webhook" Node

At the end of all branches:
- Search for "Respond to Webhook"
- Response Code: 200
- Response Body: `{{ $json }}`

#### 6. Connect Unknown Tool Handler

From Switch "Fallback" output:
- Add Code node:
```javascript
return [{
  json: {
    success: false,
    error: "Unknown tool requested",
    tool_name: items[0].json.tool_name
  }
}];
```
- Connect to Respond to Webhook

#### 7. Activate Workflow

Click the "Inactive" toggle at top to activate the workflow.

---

### Task 2: Create Signed URL Workflow (5 min)

1. **Create New Workflow**
   - Click "Create workflow"
   - Name: "Get Agent Signed URL"

2. **Add Webhook Node**
   - HTTP Method: GET
   - Path: `get-agent-url`
   - Response Mode: Using 'Respond to Webhook' Node

3. **Add HTTP Request Node**
   - Method: GET
   - URL: `https://api.elevenlabs.io/v1/convai/conversation/get_signed_url`
   - Query Parameters:
     - Name: `agent_id`
     - Value: `[YOU'LL GET THIS FROM ELEVENLABS AFTER CREATING AGENT]`
   - Headers:
     - Name: `xi-api-key`
     - Value: `sk_5f575f28eb4b4270f253437464843be256374c962e300dee`

4. **Add Code Node** (Format Response)
```javascript
return [{
  json: {
    signedUrl: items[0].json.signed_url
  }
}];
```

5. **Add Respond to Webhook Node**
   - Connect from Code node
   - Response Code: 200
   - Response Body: `{{ $json }}`

6. **Activate Workflow**

---

### Task 3: Create ElevenLabs Agent (After Claude Restart) (10 min)

**After you restart Claude Desktop**, the ElevenLabs MCP will be available. Then use Claude to:

1. **Create Agent Using MCP Tools**

Claude will be able to use tools like:
- `elevenlabs_create_agent`
- `elevenlabs_add_tool`
- etc.

2. **System Prompt** (copy this):

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

3. **Tool Definitions** (All 6 tools - copy each JSON):

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

4. **Get Agent ID**
   - After creating agent, copy the Agent ID from URL
   - Update the "Get Agent Signed URL" workflow with this ID

---

## 🧪 Testing

### Test 1: Master Orchestrator
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

**Expected**: JSON response with analysis

### Test 2: Signed URL
```bash
curl https://mmrech-md.app.n8n.cloud/webhook/get-agent-url
```

**Expected**: JSON with `signedUrl` field

### Test 3: Voice Agent
1. Go to: https://matheus-rech.github.io/constitutional-ai-toolkit/tools/voice-agent.html
2. Click "🎤 Start Conversation"
3. Say: "What's the conflict between privacy and transparency?"
4. **Expected**: Agent responds with analysis!

---

## 📊 Progress Tracking

- [x] Voice agent UI deployed
- [x] ElevenLabs MCP configured
- [x] Master Orchestrator webhook created
- [ ] Master Orchestrator nodes completed (Switch, HTTP, Code, Respond)
- [ ] Signed URL workflow created
- [ ] ElevenLabs agent created with 6 tools
- [ ] End-to-end testing completed

---

## 💡 Key Information

**n8n Production Webhook URLs:**
- Master Orchestrator: `https://mmrech-md.app.n8n.cloud/webhook/orchestrator`
- Signed URL: `https://mmrech-md.app.n8n.cloud/webhook/get-agent-url`

**ElevenLabs API Key:**
`sk_5f575f28eb4b4270f253437464843be256374c962e300dee`

**Voice Agent UI:**
`https://matheus-rech.github.io/constitutional-ai-toolkit/tools/voice-agent.html`

---

## 🎯 Estimated Time Remaining

- Complete Master Orchestrator: ~15 minutes
- Create Signed URL workflow: ~5 minutes
- Create ElevenLabs agent (with MCP): ~10 minutes
- Testing: ~10 minutes

**Total: ~40 minutes**

---

## 🔗 Resources

- [ElevenLabs Conversational AI](https://elevenlabs.io/app/conversational-ai)
- [ElevenLabs Documentation](https://elevenlabs.io/docs)
- [n8n Webhook Documentation](https://docs.n8n.io/integrations/builtin/core-nodes/n8n-nodes-base.webhook/)
- [Gemini API Key](https://makersuite.google.com/app/apikey)

---

**After restarting Claude Desktop, you can ask Claude to help create the ElevenLabs agent programmatically using the MCP tools! This will be much faster than manual creation.**
