# Constitutional AI Toolkit - Voice Agent Orchestrator

## Architecture Design

Based on ElevenLabs showcase projects (Time Travel Machine, TutorAI, MCP Voice Agents)

---

## Overview

Create a conversational AI agent that orchestrates all Constitutional AI Toolkit features through natural voice conversation. Users can launch any tool, customize parameters, and chain operations - all by talking to the agent.

**Example Conversations:**
- "Generate a Federalist paper about AI privacy in Hamilton's style"
- "Analyze the conflict between freedom of speech and content moderation"
- "Create a war game scenario about AI regulation"
- "Read me the last Federalist paper you generated"

---

## Architecture Pattern: Agent + n8n Hybrid

### Why This Approach?

**Pros:**
- ✅ Natural conversation with ElevenLabs Conversational AI
- ✅ Existing n8n workflows remain unchanged
- ✅ Agent handles intent understanding + parameter extraction
- ✅ Secure (API keys stay on n8n server-side)
- ✅ Scalable (add new tools as n8n workflows)

**Architecture:**
```
User Voice Input
    ↓
[ElevenLabs Agent] - Understands intent, extracts parameters
    ↓
[Custom Tools/Functions] - Each tool = webhook to n8n workflow
    ↓
n8n Workflows - Execute actual logic (Gemini AI, audio generation)
    ↓
[ElevenLabs Agent] - Receives result, converts to speech
    ↓
User Voice Output
```

---

## Component 1: ElevenLabs Conversational Agent

### Agent Configuration

**Name:** "Constitutional AI Orchestrator"

**System Prompt:**
```
You are the Constitutional AI Orchestrator, a voice assistant that helps users explore constitutional principles through AI-powered tools.

You have access to six interactive tools:

1. CONSTITUTION EXPLORER
   - Analyzes conflicts between constitutional values
   - Use when: User asks about constitutional conflicts, AI ethics, rights analysis
   - Parameters: question (string)

2. FEDERALIST PAPERS GENERATOR
   - Generates historical essays in Founding Fathers' style
   - Use when: User wants an essay, wants historical perspective
   - Parameters: author (Hamilton|Madison|Jay), topic (string)

3. SCENARIO GENERATOR
   - Creates constitutional dilemma scenarios
   - Use when: User wants hypothetical situations, ethical dilemmas
   - Parameters: topic (string), complexity (basic|intermediate|advanced)

4. WAR GAMES SIMULATOR
   - Simulates constitutional debates between historical figures
   - Use when: User wants debates, multiple perspectives
   - Parameters: topic (string), participants (array of names)

5. SIMULATION EXPLORER
   - Interactive simulations of constitutional principles
   - Use when: User wants to explore principles interactively
   - Parameters: principle (string)

6. API KEY MANAGER
   - Manages API credentials securely
   - Use when: User wants to configure keys, check status
   - Parameters: action (check|configure)

Your conversational style:
- Educational but approachable
- Ask clarifying questions when parameters are unclear
- Suggest related tools when appropriate
- Always explain what you're doing before calling a tool
- After results, offer to elaborate or try another tool

Example flow:
User: "I want to learn about free speech vs content moderation"
You: "Great question! I can help with that using the Constitution Explorer, which analyzes conflicts between constitutional values. Let me analyze this conflict for you..."
[Call constitution_explorer tool]
[Receive result]
You: "Here's the analysis... [result]. Would you like me to generate a Federalist paper exploring this topic in more depth?"
```

**Voice:** Rachel (clear, professional, trustworthy)

**Model:** eleven_turbo_v2_5 (fast, suitable for conversation)

**Tools/Functions:**
Each tool maps to an n8n webhook endpoint.

---

## Component 2: n8n Workflows

### Master Orchestrator Workflow

**Purpose:** Single entry point for all tools

**Workflow Structure:**
```
Webhook Trigger (/webhook/orchestrator)
    ↓
Parse Request (extract tool_name, parameters)
    ↓
Switch Node (route based on tool_name)
    ├─→ Constitution Explorer Sub-Workflow
    ├─→ Federalist Papers Sub-Workflow
    ├─→ Scenario Generator Sub-Workflow
    ├─→ War Games Sub-Workflow
    ├─→ Simulation Explorer Sub-Workflow
    └─→ API Key Manager Sub-Workflow
    ↓
Format Response (standard JSON structure)
    ↓
Respond to Webhook
```

**Input Format:**
```json
{
  "tool_name": "constitution_explorer",
  "parameters": {
    "question": "What are the conflicts between AI transparency and privacy?"
  }
}
```

**Output Format:**
```json
{
  "success": true,
  "tool": "constitution_explorer",
  "result": {
    "responseText": "Analysis of constitutional conflicts...",
    "audioUrl": "data:audio/mpeg;base64,...",
    "citations": ["Article IV", "Amendment I"]
  }
}
```

---

### Sub-Workflows

#### 1. Constitution Explorer Workflow

**Endpoint:** `/webhook/constitution-explorer`

**Flow:**
```
Webhook Trigger
    ↓
Extract Question
    ↓
Gemini AI Analysis (conflict analysis prompt)
    ↓
Format Response (structure analysis)
    ↓
ElevenLabs TTS (optional - if audio requested)
    ↓
Respond with JSON
```

**Gemini Prompt:**
```
You are an expert in Constitutional AI and governance. Analyze this question and provide a clear, educational response focusing on constitutional principles and ethical considerations.

Question: {{question}}

Provide a structured response with:
1. Core constitutional values involved
2. Potential conflicts
3. Key considerations
4. Suggested framework for resolution

Keep the response conversational and suitable for voice narration (about 200-300 words).
```

---

#### 2. Federalist Papers Generator Workflow

**Endpoint:** `/webhook/federalist-papers-generator`

**Flow:**
```
Webhook Trigger
    ↓
Extract Author + Topic
    ↓
Gemini Generate Essay (18th-century style)
    ↓
Format for Narration (add dramatic pauses)
    ↓
ElevenLabs TTS (author-appropriate voice)
    ├─→ Hamilton → Adam (deep, authoritative)
    ├─→ Madison → Arnold (refined, analytical)
    └─→ Jay → Josh (diplomatic, measured)
    ↓
Respond with Essay Text + Audio
```

**Voice Mapping:**
```javascript
const voiceMap = {
  "Hamilton": "Adam",
  "Madison": "Arnold",
  "Jay": "Josh"
};
```

---

#### 3. Scenario Generator Workflow

**Endpoint:** `/webhook/scenario-generator`

**Flow:**
```
Webhook Trigger
    ↓
Extract Topic + Complexity
    ↓
Gemini Generate Scenario
    ↓
ElevenLabs TTS (dramatic narration)
    ↓
Respond with Scenario + Audio
```

---

#### 4. War Games Simulator Workflow

**Endpoint:** `/webhook/war-games-simulator`

**Flow:**
```
Webhook Trigger
    ↓
Extract Topic + Participants
    ↓
Gemini Generate Debate (multiple perspectives)
    ↓
Split into Character Parts
    ↓
ElevenLabs TTS (multiple voices)
    ├─→ Hamilton → Adam
    ├─→ Madison → Arnold
    ├─→ Jefferson → Josh
    ├─→ Franklin → Antoni
    └─→ Narrator → Rachel
    ↓
Combine Audio Chunks (or return array)
    ↓
Respond with Debate Script + Audio
```

---

## Component 3: Web Interface

### Voice Agent UI

**File:** `tools/voice-agent.html`

**Features:**
- Large "Talk to Agent" button
- Real-time connection status
- Speaking/listening indicators
- Transcript display (optional)
- Quick action buttons for common tasks

**UI Layout:**
```
┌─────────────────────────────────┐
│  Constitutional AI Orchestrator  │
│                                  │
│  ┌───────────────────────────┐  │
│  │   🎤 Talk to Agent        │  │  ← Big button
│  │   Status: Connected       │  │
│  └───────────────────────────┘  │
│                                  │
│  ┌───────────────────────────┐  │
│  │ 🔊 Agent Speaking...      │  │  ← Status
│  └───────────────────────────┘  │
│                                  │
│  Quick Actions:                  │
│  [Generate Essay] [Analyze]     │
│  [Create Scenario] [War Game]   │
│                                  │
│  Recent:                         │
│  • Federalist #X about AI...    │
│  • Constitutional conflict...   │
└─────────────────────────────────┘
```

**Implementation:**
```javascript
import { Conversation } from '@elevenlabs/client';

let conversation = null;

async function startAgent() {
    // Get signed URL from backend
    const signedUrl = await getSignedUrl();

    // Start conversation
    conversation = await Conversation.startSession({
        signedUrl: signedUrl,
        onConnect: () => updateStatus('Connected'),
        onDisconnect: () => updateStatus('Disconnected'),
        onModeChange: (mode) => updateSpeakingStatus(mode)
    });
}

async function getSignedUrl() {
    const response = await fetch('/api/agent-signed-url');
    const data = await response.json();
    return data.signedUrl;
}
```

---

## Component 4: Backend API (Optional - for signed URLs)

### Option A: Node.js Express

```javascript
// backend/server.js
const express = require('express');
const app = express();

app.get('/api/agent-signed-url', async (req, res) => {
    const response = await fetch(
        `https://api.elevenlabs.io/v1/convai/conversation/get_signed_url?agent_id=${process.env.AGENT_ID}`,
        {
            method: 'GET',
            headers: { 'xi-api-key': process.env.ELEVENLABS_API_KEY }
        }
    );

    const data = await response.json();
    res.json({ signedUrl: data.signed_url });
});

app.listen(3000);
```

### Option B: n8n Workflow

**Simpler approach - use n8n to generate signed URLs:**

```
Webhook Trigger (/webhook/get-agent-url)
    ↓
HTTP Request to ElevenLabs
    URL: https://api.elevenlabs.io/v1/convai/conversation/get_signed_url
    Method: GET
    Query: agent_id={{AGENT_ID}}
    Headers: xi-api-key: {{ELEVENLABS_API_KEY}}
    ↓
Respond with signed_url
```

---

## Component 5: ElevenLabs Agent Tool Definitions

### Tool 1: Constitution Explorer

```json
{
  "name": "constitution_explorer",
  "description": "Analyzes conflicts between constitutional values and AI ethics. Use when the user asks about constitutional conflicts, rights analysis, or ethical dilemmas.",
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
  "webhook_url": "https://mmrech-md.app.n8n.cloud/webhook/constitution-explorer"
}
```

### Tool 2: Federalist Papers Generator

```json
{
  "name": "federalist_papers_generator",
  "description": "Generates historical essays in the style of the Founding Fathers (Hamilton, Madison, or Jay). Use when the user wants an essay or historical perspective on a topic.",
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
        "description": "The modern topic to write about"
      }
    },
    "required": ["author", "topic"]
  },
  "webhook_url": "https://mmrech-md.app.n8n.cloud/webhook/federalist-papers-generator"
}
```

### Tool 3: Scenario Generator

```json
{
  "name": "scenario_generator",
  "description": "Creates constitutional dilemma scenarios for exploration. Use when the user wants hypothetical situations or ethical dilemmas.",
  "parameters": {
    "type": "object",
    "properties": {
      "topic": {
        "type": "string",
        "description": "The topic for the scenario (e.g., 'AI privacy', 'freedom of expression')"
      },
      "complexity": {
        "type": "string",
        "enum": ["basic", "intermediate", "advanced"],
        "description": "The complexity level of the scenario",
        "default": "intermediate"
      }
    },
    "required": ["topic"]
  },
  "webhook_url": "https://mmrech-md.app.n8n.cloud/webhook/scenario-generator"
}
```

---

## Implementation Steps

### Phase 1: ElevenLabs Agent Setup

1. **Create Agent in ElevenLabs Dashboard**
   - Go to https://elevenlabs.io/app/conversational-ai
   - Click "Create Agent"
   - Name: "Constitutional AI Orchestrator"
   - System Prompt: [Use prompt from above]
   - Voice: Rachel
   - Model: eleven_turbo_v2_5

2. **Add Custom Tools**
   - For each tool, click "Add Tool"
   - Enter tool definition JSON
   - Configure webhook URL (will be n8n endpoints)

3. **Test Agent**
   - Use "Test Agent" feature in dashboard
   - Verify tools are called correctly

4. **Get Agent ID**
   - Copy Agent ID from agent settings
   - Save for later use

---

### Phase 2: n8n Workflow Creation

1. **Import Existing Workflows** (already created)
   - voice-enabled-qa-workflow.json
   - audio-federalist-papers-workflow.json

2. **Create Master Orchestrator**
   - Import orchestrator-workflow.json
   - Configure routing logic
   - Test with sample payloads

3. **Test Each Sub-Workflow**
   - Send test requests via Postman/curl
   - Verify responses
   - Check audio generation

---

### Phase 3: Web Interface

1. **Create Voice Agent UI**
   - Add to `tools/voice-agent.html`
   - Implement ElevenLabs Conversation SDK
   - Add status indicators

2. **Update Main Dashboard**
   - Add "🎤 Voice Agent" card to index.html
   - Make it prominent (featured position)

3. **Create Quick Actions**
   - Pre-configured buttons for common tasks
   - "Generate Hamilton essay about [topic]"
   - "Analyze [conflict]"

---

### Phase 4: Testing & Refinement

1. **Test Conversation Flow**
   - Try all 6 tools
   - Test parameter extraction
   - Verify audio quality

2. **Test Error Handling**
   - What if tool fails?
   - What if parameters are invalid?
   - Network errors?

3. **Optimize Prompts**
   - Refine agent system prompt
   - Improve tool descriptions
   - Add more examples

---

## Deployment

### Deploy to GitHub Pages

```bash
cd ~/Downloads/constitutional-ai-toolkit

# Add voice agent
cp ~/Downloads/voice-agent.html tools/

# Update index.html to include voice agent card

# Commit and push
git add .
git commit -m "Add voice agent orchestrator"
git push
```

### Configure n8n Webhooks

1. Activate all workflows in n8n
2. Copy webhook URLs
3. Update agent tool definitions with production URLs

---

## Security Considerations

### API Keys
- ✅ ElevenLabs API key stored in n8n credentials (encrypted)
- ✅ Gemini API key stored in n8n credentials (encrypted)
- ✅ Never exposed to client-side JavaScript
- ✅ All API calls happen server-side via n8n

### Rate Limiting
- Implement rate limiting on n8n webhooks
- Monitor usage in ElevenLabs dashboard
- Set usage alerts

### Input Validation
- Agent validates parameters before calling tools
- n8n workflows validate inputs
- Sanitize all user-provided text

---

## Cost Optimization

### ElevenLabs
- Use eleven_turbo_v2_5 (faster, cheaper than multilingual)
- Cache common responses
- Implement conversation timeout

### Gemini
- Use gemini-2.0-flash-exp (free tier)
- Keep responses concise (200-300 words)
- Cache common queries

### n8n
- Use n8n cloud (existing instance)
- Monitor execution time
- Optimize workflow logic

---

## Future Enhancements

### Multi-Turn Conversations
- Agent remembers conversation context
- Can reference previous results
- "Tell me more about that" functionality

### Conversation History
- Store conversation transcripts
- Allow users to review past interactions
- Download conversation history

### Advanced Routing
- Chain multiple tools in sequence
- "Generate an essay, then create a scenario about it"
- Agent orchestrates multi-step workflows

### Custom Voices
- Allow users to clone their own voice
- Use custom voices for Founding Fathers
- Historical accuracy in narration

### Mobile App
- React Native app using same agent
- Push notifications for long-running tasks
- Offline mode for cached content

---

## Testing Scenarios

### Scenario 1: Simple Question
```
User: "What's the conflict between AI transparency and privacy?"
Agent: "Great question! I'll analyze this constitutional conflict..."
→ Calls constitution_explorer
→ Returns analysis with audio
Agent: "Here's the analysis... Would you like more detail?"
```

### Scenario 2: Essay Generation
```
User: "Generate a Federalist paper about AI regulation in Hamilton's style"
Agent: "I'll create a Federalist paper in Hamilton's authoritative voice..."
→ Calls federalist_papers_generator(author="Hamilton", topic="AI regulation")
→ Returns essay with Adam's voice
Agent: "The essay is ready. Would you like me to read it again or create a scenario based on this topic?"
```

### Scenario 3: Multi-Step
```
User: "Create a war game about free speech"
Agent: "I'll create a constitutional debate scenario..."
→ Calls war_games_simulator
→ Returns multi-voice debate
Agent: "The debate is complete. Would you like to explore any of these perspectives further?"
```

---

## Monitoring & Analytics

### Key Metrics
- Conversation duration (average)
- Tools called per conversation
- Most popular tools
- Error rate by tool
- User satisfaction (implicit - conversation length)

### Dashboards
- ElevenLabs usage dashboard
- n8n execution analytics
- Custom analytics (optional)

---

## Documentation

### User Guide
- "How to use the Voice Agent"
- Example conversations
- Tips for best results

### Developer Guide
- How to add new tools
- Workflow modification guide
- Troubleshooting common issues

---

## Summary

This architecture provides:
- ✅ Natural voice conversation
- ✅ Access to all 6 toolkit features
- ✅ Secure (server-side API calls)
- ✅ Scalable (add tools easily)
- ✅ Cost-effective (leverages existing infrastructure)
- ✅ User-friendly (just talk!)

**Next Steps:**
1. Create ElevenLabs agent
2. Build n8n master orchestrator
3. Create voice agent UI
4. Test end-to-end
5. Deploy to production
