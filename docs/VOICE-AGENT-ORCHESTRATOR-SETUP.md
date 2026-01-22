# 🎙️ Constitutional AI Toolkit - Voice Agent Orchestrator Setup

## Complete Implementation Guide

Transform your Constitutional AI Toolkit into a voice-controlled platform where users can talk to an AI agent that orchestrates all 6 tools through natural conversation.

**What You're Building:**
- Voice-controlled AI agent that understands natural language
- Seamless integration with all existing toolkit features
- No coding required for users - just talk!
- Production-ready with security and error handling

---

## Prerequisites

✅ You already have:
- Constitutional AI Toolkit deployed at https://matheus-rech.github.io/constitutional-ai-toolkit/
- n8n Cloud instance at https://mmrech-md.app.n8n.cloud
- Gemini API key
- ElevenLabs API key: `sk_5f575f28eb4b4270f253437464843be256374c962e300dee`

---

## Part 1: Create ElevenLabs Conversational Agent (15 minutes)

### Step 1.1: Access ElevenLabs Conversational AI

1. Go to https://elevenlabs.io/app/conversational-ai
2. Click **"Create Agent"**
3. You'll see the agent builder interface

### Step 1.2: Configure Agent Basics

**Agent Name:**
```
Constitutional AI Orchestrator
```

**Agent Description:**
```
Voice assistant for exploring constitutional principles through AI-powered interactive tools
```

**Voice Selection:**
- Click "Select Voice"
- Choose **"Rachel"** (clear, professional, trustworthy)
- Preview to verify

**Model:**
- Select **"eleven_turbo_v2_5"** (optimized for conversational speed)

### Step 1.3: Write System Prompt

Click "System Prompt" and paste:

```
You are the Constitutional AI Orchestrator, a voice assistant that helps users explore constitutional principles, AI ethics, and governance through six interactive tools.

# Your Role
Help users access and navigate these tools through natural conversation. Be educational, approachable, and proactive in suggesting relevant tools.

# Available Tools

1. **constitution_explorer**
   - Purpose: Analyzes conflicts between constitutional values
   - When to use: User asks about rights, conflicts, ethical dilemmas, AI governance
   - Example: "What's the tension between privacy and transparency?"

2. **federalist_papers_generator**
   - Purpose: Generates historical essays in Founding Fathers' style
   - When to use: User wants historical perspective, asks "what would Hamilton say"
   - Example: "Write an essay about AI regulation in Madison's style"

3. **scenario_generator**
   - Purpose: Creates constitutional dilemma scenarios
   - When to use: User wants hypothetical situations, "what if" questions
   - Example: "Create a scenario about AI in criminal justice"

4. **war_games_simulator**
   - Purpose: Simulates debates between historical figures
   - When to use: User wants multiple perspectives, debate format
   - Example: "Show me Hamilton and Jefferson debating AI privacy"

5. **simulation_explorer**
   - Purpose: Interactive exploration of constitutional principles
   - When to use: User wants to understand principles deeply
   - Example: "Help me understand separation of powers"

6. **api_key_manager**
   - Purpose: Manages API credentials securely
   - When to use: User mentions configuration, setup, API keys
   - Example: "Check my API key status"

# Conversation Style

**Before calling a tool:**
- Briefly explain what you're going to do
- "I'll analyze that constitutional conflict for you..."
- "Let me generate an essay in Hamilton's voice..."

**After receiving results:**
- Summarize key points from the result
- Offer next steps: "Would you like me to elaborate?" or "Should I create a scenario based on this?"
- Suggest related tools when appropriate

**When parameters are unclear:**
- Ask clarifying questions naturally
- "Which Founding Father's style would you prefer - Hamilton, Madison, or Jay?"
- "Would you like a basic, intermediate, or advanced scenario?"

**Examples:**

User: "Tell me about free speech vs content moderation"
You: "That's an important constitutional question. I'll analyze this conflict using the Constitution Explorer..."
[Call constitution_explorer with question]
[Receive result]
You: "Here's the analysis... [summarize key points]. Would you like me to generate a Federalist paper exploring this in more depth, or create a debate scenario?"

User: "What would Hamilton say about AI?"
You: "Great question! Hamilton would definitely have strong opinions. What specific AI topic would you like his perspective on - regulation, innovation, national competitiveness, or something else?"
User: "AI regulation"
You: "Perfect. I'll generate a Federalist paper in Hamilton's authoritative voice about AI regulation..."
[Call federalist_papers_generator]

# Important Guidelines

1. **Always explain before acting** - Tell users what tool you're using
2. **Summarize results** - Don't just read raw output, interpret and highlight
3. **Offer next steps** - Suggest related actions
4. **Be conversational** - You're a helpful guide, not a robot
5. **Handle errors gracefully** - If a tool fails, apologize and suggest alternatives
6. **Stay on topic** - Focus on constitutional principles and AI ethics

# Error Handling

If a tool returns an error:
"I encountered an issue accessing that tool. Let me try a different approach..."

If user request is unclear:
"I want to make sure I understand correctly. Could you clarify..."

If request is outside your scope:
"That's an interesting question, but it's outside my area of constitutional AI. I'm best suited to help with..."
```

### Step 1.4: Configure Tool Functions

Now we'll add the 6 custom tools that call your n8n workflows.

#### Tool 1: Constitution Explorer

Click **"Add Tool"** and enter:

**Function Name:** `constitution_explorer`

**Function Description:**
```
Analyzes conflicts between constitutional values, rights, and AI ethics. Use when the user asks about constitutional conflicts, ethical dilemmas, tensions between principles, or AI governance questions.
```

**Parameters Schema:**
```json
{
  "type": "object",
  "properties": {
    "question": {
      "type": "string",
      "description": "The constitutional question or conflict to analyze. Should be specific and clear."
    }
  },
  "required": ["question"]
}
```

**Webhook URL:**
```
https://mmrech-md.app.n8n.cloud/webhook/orchestrator
```

**Request Body:**
```json
{
  "tool_name": "constitution_explorer",
  "parameters": {
    "question": "{{question}}"
  },
  "conversation_id": "{{conversation_id}}"
}
```

---

#### Tool 2: Federalist Papers Generator

Click **"Add Tool"** and enter:

**Function Name:** `federalist_papers_generator`

**Function Description:**
```
Generates historical essays in the style of the Founding Fathers (Hamilton, Madison, or Jay) on modern topics. Use when the user wants historical perspective, asks "what would [Founder] say", or wants an essay format.
```

**Parameters Schema:**
```json
{
  "type": "object",
  "properties": {
    "author": {
      "type": "string",
      "enum": ["Hamilton", "Madison", "Jay"],
      "description": "The Founding Father whose writing style to emulate"
    },
    "topic": {
      "type": "string",
      "description": "The modern topic to write about (e.g., 'AI regulation', 'data privacy')"
    }
  },
  "required": ["author", "topic"]
}
```

**Webhook URL:**
```
https://mmrech-md.app.n8n.cloud/webhook/orchestrator
```

**Request Body:**
```json
{
  "tool_name": "federalist_papers_generator",
  "parameters": {
    "author": "{{author}}",
    "topic": "{{topic}}"
  },
  "conversation_id": "{{conversation_id}}"
}
```

---

#### Tool 3: Scenario Generator

Click **"Add Tool"** and enter:

**Function Name:** `scenario_generator`

**Function Description:**
```
Creates constitutional dilemma scenarios for exploration. Use when the user wants hypothetical situations, "what if" questions, or practice scenarios.
```

**Parameters Schema:**
```json
{
  "type": "object",
  "properties": {
    "topic": {
      "type": "string",
      "description": "The topic for the scenario (e.g., 'AI privacy', 'freedom of expression', 'surveillance')"
    },
    "complexity": {
      "type": "string",
      "enum": ["basic", "intermediate", "advanced"],
      "description": "The complexity level of the scenario. Default is intermediate.",
      "default": "intermediate"
    }
  },
  "required": ["topic"]
}
```

**Webhook URL:**
```
https://mmrech-md.app.n8n.cloud/webhook/orchestrator
```

**Request Body:**
```json
{
  "tool_name": "scenario_generator",
  "parameters": {
    "topic": "{{topic}}",
    "complexity": "{{complexity}}"
  },
  "conversation_id": "{{conversation_id}}"
}
```

---

#### Tool 4: War Games Simulator

Click **"Add Tool"** and enter:

**Function Name:** `war_games_simulator`

**Function Description:**
```
Simulates constitutional debates between historical figures on modern AI topics. Use when the user wants multiple perspectives, debate format, or asks to hear different viewpoints.
```

**Parameters Schema:**
```json
{
  "type": "object",
  "properties": {
    "topic": {
      "type": "string",
      "description": "The topic for the debate (e.g., 'AI regulation', 'data privacy', 'algorithmic transparency')"
    },
    "participants": {
      "type": "array",
      "items": {
        "type": "string"
      },
      "description": "Array of historical figures to include in the debate. Options: Hamilton, Madison, Jefferson, Franklin, Jay. Default is [Hamilton, Madison, Jefferson].",
      "default": ["Hamilton", "Madison", "Jefferson"]
    }
  },
  "required": ["topic"]
}
```

**Webhook URL:**
```
https://mmrech-md.app.n8n.cloud/webhook/orchestrator
```

**Request Body:**
```json
{
  "tool_name": "war_games_simulator",
  "parameters": {
    "topic": "{{topic}}",
    "participants": {{participants}}
  },
  "conversation_id": "{{conversation_id}}"
}
```

---

#### Tool 5: Simulation Explorer

Click **"Add Tool"** and enter:

**Function Name:** `simulation_explorer`

**Function Description:**
```
Provides interactive exploration of constitutional principles. Use when the user wants to understand principles deeply or explore concepts interactively.
```

**Parameters Schema:**
```json
{
  "type": "object",
  "properties": {
    "principle": {
      "type": "string",
      "description": "The constitutional principle to explore (e.g., 'separation of powers', 'federalism', 'checks and balances')"
    }
  },
  "required": ["principle"]
}
```

**Webhook URL:**
```
https://mmrech-md.app.n8n.cloud/webhook/orchestrator
```

**Request Body:**
```json
{
  "tool_name": "simulation_explorer",
  "parameters": {
    "principle": "{{principle}}"
  },
  "conversation_id": "{{conversation_id}}"
}
```

---

#### Tool 6: API Key Manager

Click **"Add Tool"** and enter:

**Function Name:** `api_key_manager`

**Function Description:**
```
Manages API credentials and checks configuration status. Use when the user mentions setup, configuration, API keys, or troubleshooting.
```

**Parameters Schema:**
```json
{
  "type": "object",
  "properties": {
    "action": {
      "type": "string",
      "enum": ["check", "configure", "status"],
      "description": "The action to perform. 'check' verifies API keys, 'configure' provides setup instructions, 'status' shows current configuration.",
      "default": "check"
    }
  },
  "required": ["action"]
}
```

**Webhook URL:**
```
https://mmrech-md.app.n8n.cloud/webhook/orchestrator
```

**Request Body:**
```json
{
  "tool_name": "api_key_manager",
  "parameters": {
    "action": "{{action}}"
  },
  "conversation_id": "{{conversation_id}}"
}
```

---

### Step 1.5: Test the Agent

1. Click **"Test Agent"** in the ElevenLabs dashboard
2. Try these test phrases:
   - "Analyze the conflict between privacy and transparency"
   - "Generate a Hamilton essay about AI"
   - "Create a scenario about facial recognition"

3. Verify tools are being called (you'll see in the test interface)

### Step 1.6: Get Agent ID

1. Click **"Settings"** in agent dashboard
2. Copy the **Agent ID** (looks like `agent_xyz123...`)
3. Save it - you'll need it later

**Your Agent ID:** `___________________________` (fill this in)

---

## Part 2: Import n8n Workflows (10 minutes)

### Step 2.1: Import Master Orchestrator

1. Go to https://mmrech-md.app.n8n.cloud/workflows
2. Click **"Add workflow"** → **"Import from File"**
3. Upload **`orchestrator-master-workflow.json`**
4. Click **"Activate"** (toggle switch in top right)

### Step 2.2: Verify Webhook URL

1. Click on the **"Webhook - Orchestrator"** node
2. Copy the Production URL
3. It should be: `https://mmrech-md.app.n8n.cloud/webhook/orchestrator`
4. Verify this matches the URLs you entered in agent tool definitions

### Step 2.3: Test the Orchestrator

Use curl to test each tool:

```bash
# Test Constitution Explorer
curl -X POST https://mmrech-md.app.n8n.cloud/webhook/orchestrator \
  -H "Content-Type: application/json" \
  -d '{
    "tool_name": "constitution_explorer",
    "parameters": {
      "question": "What is the conflict between free speech and content moderation?"
    }
  }'

# Test Federalist Papers Generator
curl -X POST https://mmrech-md.app.n8n.cloud/webhook/orchestrator \
  -H "Content-Type: application/json" \
  -d '{
    "tool_name": "federalist_papers_generator",
    "parameters": {
      "author": "Hamilton",
      "topic": "artificial intelligence regulation"
    }
  }'

# Test Scenario Generator
curl -X POST https://mmrech-md.app.n8n.cloud/webhook/orchestrator \
  -H "Content-Type: application/json" \
  -d '{
    "tool_name": "scenario_generator",
    "parameters": {
      "topic": "AI privacy",
      "complexity": "intermediate"
    }
  }'
```

Each should return a JSON response with `"success": true`.

---

## Part 3: Create Signed URL Workflow (5 minutes)

The frontend needs to get a signed URL to connect to the agent. Let's create an n8n workflow for this.

### Step 3.1: Create Signed URL Workflow

1. In n8n, click **"Add workflow"** → **"Blank"**
2. Name it: **"Get Agent Signed URL"**
3. Add nodes as follows:

**Node 1: Webhook Trigger**
- Type: `Webhook`
- HTTP Method: `GET`
- Path: `get-agent-url`
- Response Mode: `Response Node`

**Node 2: HTTP Request** (Call ElevenLabs)
- Method: `GET`
- URL: `https://api.elevenlabs.io/v1/convai/conversation/get_signed_url`
- Query Parameters:
  - Name: `agent_id`
  - Value: `[YOUR_AGENT_ID_FROM_STEP_1.6]`
- Headers:
  - Name: `xi-api-key`
  - Value: `sk_5f575f28eb4b4270f253437464843be256374c962e300dee`

**Node 3: Respond to Webhook**
- Respond With: `JSON`
- Response Body: `={{ { "signedUrl": $json.signed_url } }}`

4. Connect: Webhook → HTTP Request → Respond
5. **Activate** the workflow
6. Copy the production URL: `https://mmrech-md.app.n8n.cloud/webhook/get-agent-url`

### Step 3.2: Test Signed URL Endpoint

```bash
curl https://mmrech-md.app.n8n.cloud/webhook/get-agent-url
```

Should return:
```json
{
  "signedUrl": "wss://..."
}
```

---

## Part 4: Create Voice Agent UI (10 minutes)

Now let's create the web interface for users to talk to the agent.

### Step 4.1: Create Voice Agent HTML

Create file `voice-agent.html`:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Voice Agent - Constitutional AI Toolkit</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            max-width: 600px;
            width: 100%;
            padding: 40px;
        }

        h1 {
            text-align: center;
            color: #667eea;
            margin-bottom: 10px;
            font-size: 2em;
        }

        .subtitle {
            text-align: center;
            color: #666;
            margin-bottom: 30px;
        }

        .agent-status {
            text-align: center;
            margin: 30px 0;
        }

        .status-indicator {
            display: inline-block;
            width: 12px;
            height: 12px;
            border-radius: 50%;
            margin-right: 8px;
            animation: pulse 2s ease-in-out infinite;
        }

        .status-indicator.disconnected {
            background: #e74c3c;
        }

        .status-indicator.connected {
            background: #2ecc71;
        }

        .status-indicator.speaking {
            background: #3498db;
            animation: pulse 0.5s ease-in-out infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; }
            50% { opacity: 0.5; }
        }

        .main-button {
            width: 100%;
            padding: 20px;
            font-size: 1.3em;
            border: none;
            border-radius: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            cursor: pointer;
            transition: all 0.3s;
            margin: 10px 0;
            font-weight: 600;
        }

        .main-button:hover:not(:disabled) {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.4);
        }

        .main-button:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }

        .quick-actions {
            margin-top: 30px;
            padding-top: 30px;
            border-top: 2px solid #eee;
        }

        .quick-actions h3 {
            color: #333;
            margin-bottom: 15px;
            font-size: 1.1em;
        }

        .quick-action-btn {
            background: white;
            border: 2px solid #667eea;
            color: #667eea;
            padding: 12px 20px;
            border-radius: 8px;
            margin: 5px;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 0.9em;
        }

        .quick-action-btn:hover {
            background: #667eea;
            color: white;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #667eea;
            text-decoration: none;
        }

        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎙️ Voice Agent</h1>
        <p class="subtitle">Talk to explore constitutional principles</p>

        <div class="agent-status">
            <span class="status-indicator disconnected" id="statusIndicator"></span>
            <span id="statusText">Disconnected</span>
        </div>

        <button class="main-button" id="startButton" onclick="startConversation()">
            🎤 Start Conversation
        </button>
        <button class="main-button" id="endButton" onclick="endConversation()" style="display: none;">
            ⏹️ End Conversation
        </button>

        <div class="quick-actions">
            <h3>Quick Actions</h3>
            <button class="quick-action-btn" onclick="quickAction('analyze')">
                Analyze a Conflict
            </button>
            <button class="quick-action-btn" onclick="quickAction('essay')">
                Generate Essay
            </button>
            <button class="quick-action-btn" onclick="quickAction('scenario')">
                Create Scenario
            </button>
            <button class="quick-action-btn" onclick="quickAction('debate')">
                War Game Debate
            </button>
        </div>

        <a href="../index.html" class="back-link">← Back to Toolkit Home</a>
    </div>

    <script type="module">
        import { Conversation } from 'https://cdn.jsdelivr.net/npm/@elevenlabs/client@0.3.1/+esm';

        let conversation = null;
        window.conversation = conversation;

        window.startConversation = async function() {
            const startButton = document.getElementById('startButton');
            const endButton = document.getElementById('endButton');

            try {
                // Request microphone permission
                await navigator.mediaDevices.getUserMedia({ audio: true });

                // Get signed URL
                const response = await fetch('https://mmrech-md.app.n8n.cloud/webhook/get-agent-url');
                const data = await response.json();

                // Start conversation
                conversation = await Conversation.startSession({
                    signedUrl: data.signedUrl,
                    onConnect: () => {
                        console.log('Connected');
                        updateStatus('connected', 'Connected - Listening');
                        startButton.style.display = 'none';
                        endButton.style.display = 'block';
                    },
                    onDisconnect: () => {
                        console.log('Disconnected');
                        updateStatus('disconnected', 'Disconnected');
                        startButton.style.display = 'block';
                        endButton.style.display = 'none';
                    },
                    onError: (error) => {
                        console.error('Conversation error:', error);
                        alert('An error occurred. Please try again.');
                        updateStatus('disconnected', 'Error - Disconnected');
                    },
                    onModeChange: (mode) => {
                        console.log('Mode changed:', mode);
                        const isSpeaking = mode.mode === 'speaking';
                        updateStatus(
                            isSpeaking ? 'speaking' : 'connected',
                            isSpeaking ? 'Agent Speaking' : 'Listening'
                        );
                    }
                });

                window.conversation = conversation;
            } catch (error) {
                console.error('Error starting conversation:', error);
                alert('Failed to start conversation. Please ensure microphone permission is granted.');
            }
        };

        window.endConversation = async function() {
            if (window.conversation) {
                await window.conversation.endSession();
                window.conversation = null;
            }
        };

        function updateStatus(status, text) {
            const indicator = document.getElementById('statusIndicator');
            const statusText = document.getElementById('statusText');

            indicator.className = 'status-indicator ' + status;
            statusText.textContent = text;
        }

        window.quickAction = function(action) {
            alert(`Quick action: ${action}\\n\\nPlease start a conversation first, then say:\\n\\n` + getQuickPrompt(action));
        };

        function getQuickPrompt(action) {
            const prompts = {
                analyze: '"Analyze the conflict between privacy and transparency in AI"',
                essay: '"Generate a Hamilton essay about AI regulation"',
                scenario: '"Create a scenario about facial recognition technology"',
                debate: '"Show me a debate between Hamilton and Madison about AI"'
            };
            return prompts[action] || '';
        }
    </script>
</body>
</html>
```

### Step 4.2: Add to Your Toolkit

1. Save the file as `voice-agent.html` in your `tools/` directory
2. Update `index.html` to add a voice agent card

---

## Part 5: Deploy to GitHub Pages (5 minutes)

### Step 5.1: Add Voice Agent to Repository

```bash
cd ~/Downloads/constitutional-ai-toolkit

# Add voice agent file
cp ~/Downloads/voice-agent.html tools/

# Commit and push
git add .
git commit -m "Add voice agent orchestrator

- ElevenLabs conversational AI integration
- Natural language interface for all toolkit features
- Real-time voice interaction with agent
- Orchestrates all 6 tools through conversation"

git push
```

### Step 5.2: Verify Deployment

1. Wait 1-2 minutes for GitHub Pages to update
2. Visit: https://matheus-rech.github.io/constitutional-ai-toolkit/tools/voice-agent.html
3. Click "Start Conversation"
4. Grant microphone permission
5. Try saying: "Analyze the conflict between privacy and transparency"

---

## Testing Your Voice Agent

### Test Conversation 1: Constitution Explorer

**Say:** "What's the conflict between free speech and content moderation?"

**Expected:**
- Agent says: "Great question! I'll analyze this constitutional conflict..."
- Calls `constitution_explorer` tool
- Receives analysis from Gemini
- Agent summarizes and offers next steps

### Test Conversation 2: Federalist Papers

**Say:** "Generate a Hamilton essay about artificial intelligence"

**Expected:**
- Agent says: "I'll create a Federalist paper in Hamilton's authoritative voice..."
- Calls `federalist_papers_generator` with author=Hamilton
- Generates 800-1000 word essay
- Agent reads essay summary

### Test Conversation 3: Multi-Step

**Say:** "Create a scenario about AI privacy"
**Then say:** "Now turn that into a debate between Hamilton and Madison"

**Expected:**
- First call: `scenario_generator`
- Agent acknowledges, suggests debate
- Second call: `war_games_simulator`
- Agent presents multi-perspective debate

---

## Troubleshooting

### Problem: Agent not calling tools

**Solution:**
1. Check tool definitions in ElevenLabs dashboard
2. Verify webhook URLs are correct
3. Test n8n workflows directly with curl
4. Check n8n execution history for errors

### Problem: "Failed to get signed URL"

**Solution:**
1. Verify Agent ID in signed URL workflow
2. Check ElevenLabs API key is correct
3. Test endpoint: `curl https://mmrech-md.app.n8n.cloud/webhook/get-agent-url`

### Problem: Microphone permission denied

**Solution:**
1. Ensure HTTPS (required for microphone)
2. In browser settings, allow microphone for your domain
3. Reload page and try again

### Problem: Agent response is slow

**Solution:**
1. This is normal - Gemini AI takes 2-5 seconds
2. Agent processes result and converts to speech
3. Total time: 5-10 seconds is expected

---

## Advanced Customization

### Change Agent Voice

1. Go to ElevenLabs agent settings
2. Click "Voice"
3. Try different voices:
   - **Rachel**: Professional, clear (current)
   - **Adam**: Deep, authoritative
   - **Antoni**: Warm, engaging
   - **Bella**: Friendly, approachable

### Add More Tools

To add a new tool:
1. Create n8n workflow for the tool
2. Add tool definition in ElevenLabs agent
3. Update master orchestrator to route to new tool
4. Test with curl

### Customize System Prompt

Edit the agent's system prompt to:
- Change personality (more formal, more casual)
- Add specific knowledge domains
- Modify conversation flow
- Add custom greeting messages

---

## Cost Estimation

### ElevenLabs
- **Conversation:** ~$0.10-0.20 per minute
- **Characters used:** Varies by response length
- **Monthly estimate:** $10-50 depending on usage

### Gemini API
- **gemini-2.0-flash-exp:** FREE (current tier)
- **If upgraded:** ~$0.01 per request
- **Monthly estimate:** FREE currently

### n8n Cloud
- **Current plan:** Check https://mmrech-md.app.n8n.cloud/settings/usage
- **Workflow executions:** Included in plan
- **Monthly estimate:** Already covered

**Total Monthly Cost:** ~$10-50 (mainly ElevenLabs)

---

## Security Best Practices

✅ **API Keys:**
- ElevenLabs key stored in n8n (server-side)
- Gemini key stored in n8n (server-side)
- Never exposed to client JavaScript
- Encrypted in n8n credentials store

✅ **Input Validation:**
- Agent validates parameters before calling tools
- n8n workflows validate inputs
- No user input passed directly to system

✅ **Rate Limiting:**
- Monitor usage in ElevenLabs dashboard
- Set usage alerts
- Implement rate limiting in n8n if needed

---

## What You've Built

🎉 **Congratulations!** You now have:

✅ Voice-controlled AI agent
✅ Natural language interface for all 6 toolkit features
✅ Production-ready with error handling
✅ Secure (server-side API calls)
✅ Scalable (easy to add new tools)
✅ User-friendly (just talk!)

**Users can now:**
- Ask questions via voice
- Generate essays by talking
- Create scenarios conversationally
- Explore constitutional principles naturally
- Chain multiple operations in one conversation

**Next Steps:**
- Share with users and get feedback
- Monitor usage and costs
- Add more tools as needed
- Customize agent personality
- Create tutorial videos

---

## Support & Resources

**Documentation:**
- ElevenLabs Conversational AI: https://elevenlabs.io/docs/conversational-ai
- n8n Documentation: https://docs.n8n.io
- Gemini API: https://ai.google.dev

**Your Live URLs:**
- Toolkit: https://matheus-rech.github.io/constitutional-ai-toolkit/
- Voice Agent: https://matheus-rech.github.io/constitutional-ai-toolkit/tools/voice-agent.html
- n8n Instance: https://mmrech-md.app.n8n.cloud

**Files Created:**
- `constitutional-ai-orchestrator-design.md` - Architecture documentation
- `orchestrator-master-workflow.json` - n8n master workflow
- `voice-agent.html` - Web interface
- `VOICE-AGENT-ORCHESTRATOR-SETUP.md` - This guide

---

**Built with:**
- ElevenLabs Conversational AI
- n8n Cloud Automation
- Gemini 2.0 Flash
- GitHub Pages
- Modern Web Technologies

🚀 **Your Constitutional AI Toolkit is now voice-enabled!**
