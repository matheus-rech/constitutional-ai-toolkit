# ⚖️ Constitutional AI Toolkit

> Explore, Simulate, and Analyze Constitutional AI Systems

A comprehensive suite of interactive tools for understanding constitutional AI governance through simulation, analysis, and historical perspectives.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Powered by Gemini](https://img.shields.io/badge/Powered%20by-Google%20Gemini-blue)](https://ai.google.dev/)

## 🎯 What is This?

The Constitutional AI Toolkit is an educational platform that helps you explore how AI systems can be governed through constitutional principles. It combines:

- **Interactive Learning Tools** - Hands-on demos of simulation methodologies
- **Scenario Generation** - AI-powered creation of governance scenarios
- **Strategic Analysis** - War games testing constitutional resilience
- **Historical Perspectives** - 18th-century wisdom applied to modern challenges

## 🚀 Quick Start

### 1. Get a Gemini API Key

Visit [Google AI Studio](https://aistudio.google.com/app/apikey) and create a free API key.

### 2. Configure Your Key

1. Open the toolkit (see deployment options below)
2. Click "API Key Manager"
3. Enter your Gemini API key
4. Click "Save" and "Test Connection"

### 3. Start Exploring

All tools are now enabled! Start with the **Constitution Explorer** for an introduction.

## 🛠️ Tools Included

### 🔍 Constitution Explorer
**Level:** Beginner
**Purpose:** Interactive analysis of constitutional conflicts

Analyze potential conflicts between constitutional AI principles using real-time AI assistance. Includes:
- Conflict Simulator
- Q&A Assistant
- Ethical dilemma analysis

**Best For:** Understanding core concepts

---

### 🧪 Simulation Explorer
**Level:** Intermediate
**Purpose:** Learn simulation methodologies

Interactive demonstrations of:
- Agent-Based Models (ABM)
- Monte Carlo simulations
- System Dynamics
- Multi-Agent Reinforcement Learning

**Best For:** Learning how simulations work

---

### 🎬 Scenario Generator
**Level:** Intermediate
**Purpose:** Create custom simulation scenarios

Generate comprehensive scenarios including:
- Stakeholder analysis
- Value conflicts
- Simulation parameters
- Success metrics
- Sample Python code

**Best For:** Building your own simulations

---

### ⚔️ War Games Simulator
**Level:** Advanced
**Purpose:** Test constitutional principles under pressure

Generate strategic conflict scenarios:
- Cyber warfare
- AI arms race
- Information warfare
- Biotech competition
- Resource crises
- Constitutional emergencies

**Best For:** Stress-testing governance frameworks

---

### 📜 AI Federalist Papers
**Level:** Intermediate
**Purpose:** Historical constitutional analysis

Generate authentic 18th-century essays by:
- Alexander Hamilton (energy, commerce, innovation)
- James Madison (balance, checks, anti-faction)
- John Jay (security, foreign policy, unity)

**Best For:** Connecting historical wisdom to modern challenges

---

### 🔐 API Key Manager
**Level:** Setup
**Purpose:** Secure API configuration

Manage your Gemini API key with:
- Local-only storage (browser localStorage)
- Connection testing
- Key masking for security

**Best For:** Initial setup and key management

## 📦 Deployment Options

### Option 1: GitHub Pages (Recommended)

```bash
# 1. Create repository
mkdir constitutional-ai-toolkit
cd constitutional-ai-toolkit

# 2. Copy all files
cp /path/to/toolkit/* .

# 3. Initialize and push
git init
git add .
git commit -m "Initial commit"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/constitutional-ai-toolkit.git
git push -u origin main

# 4. Enable GitHub Pages
# Go to Settings → Pages → Source: main branch
```

**Live URL:** `https://YOUR_USERNAME.github.io/constitutional-ai-toolkit/`

### Option 2: Vercel

```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel

# Production deployment
vercel --prod
```

### Option 3: Netlify

1. Visit [netlify.com](https://netlify.com)
2. Drag and drop the toolkit folder
3. Done!

### Option 4: Local Server

```bash
# Python
python -m http.server 8000

# Node.js
npx serve

# Visit http://localhost:8000
```

## 🔧 Automated Deployment with n8n

We provide an n8n workflow for automated deployment:

```bash
# 1. Import workflow to your n8n instance
# File: constitutional-ai-toolkit-deployer.json

# 2. Activate the workflow

# 3. Deploy via API
curl -X POST https://your-n8n-instance/webhook/deploy-toolkit \
  -H "Content-Type: application/json" \
  -d '{
    "repository": "https://github.com/YOUR_USERNAME/constitutional-ai-toolkit",
    "github_token": "YOUR_GITHUB_TOKEN",
    "platform": "github"
  }'
```

Supported platforms:
- `github` - GitHub Pages
- `vercel` - Vercel deployment
- `netlify` - Netlify deployment

## 🛡️ Security & Privacy

### API Key Security

✅ **What We Do:**
- Store API keys locally in browser (localStorage)
- Never transmit keys to any server except Google's Gemini API
- Use masked display for stored keys
- Provide connection testing

❌ **What We Don't Do:**
- Never store keys on servers
- Never log or track API keys
- Never share keys with third parties
- No analytics or tracking of your usage

### Data Privacy

All processing happens client-side in your browser:
- No user data collection
- No tracking cookies
- No server-side storage
- 100% privacy-preserving

### Best Practices

1. **Keep API keys private** - Never commit keys to git
2. **Use environment variables** for production
3. **Rotate keys regularly** if shared
4. **Monitor usage** on Google AI Studio dashboard

## 📚 Documentation

Comprehensive guides included:

- **README.md** (this file) - Getting started
- **constitutional-value-discovery-summary.md** - Deep dive into value discovery methods
- **how-to-create-simulation-scenarios.md** - Scenario creation guide
- **war-games-and-historical-simulations-guide.md** - War games methodology

## 🎓 Learning Path

### Beginner (Week 1)

1. **Day 1:** Constitution Explorer - Understand core conflicts
2. **Day 2:** Simulation Explorer - Learn ABM basics
3. **Day 3:** API Key Manager - Secure setup
4. **Day 4:** Q&A with Constitution Explorer
5. **Day 5:** Read value discovery guide

### Intermediate (Week 2)

1. **Day 1:** Scenario Generator - Create first scenario
2. **Day 2:** Monte Carlo demo in Simulation Explorer
3. **Day 3:** Generate Federalist Paper on AI rights
4. **Day 4:** War Games - Cyber conflict scenario
5. **Day 5:** Compare different simulation approaches

### Advanced (Week 3)

1. **Day 1:** Custom scenario + Python implementation
2. **Day 2:** War game tournament (3+ scenarios)
3. **Day 3:** Test Federalist principles in war games
4. **Day 4:** Multi-agent ensemble simulation
5. **Day 5:** Present findings and insights

## 🤝 Contributing

Contributions welcome! Areas where you can help:

- Additional scenario templates
- New simulation methodologies
- Historical constitutional analysis
- Bug fixes and improvements
- Documentation enhancements

### Development Setup

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/constitutional-ai-toolkit.git
cd constitutional-ai-toolkit

# No build step needed - pure HTML/CSS/JS
# Just open index.html in browser

# Or use local server
python -m http.server 8000
```

### Contribution Guidelines

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 💡 Use Cases

### Education

- **Classroom Tool** - Teach AI governance concepts
- **Workshop Material** - Interactive group exercises
- **Research Training** - Learn simulation methodologies
- **Policy Education** - Understand constitutional frameworks

### Research

- **Scenario Exploration** - Generate research scenarios
- **Methodology Learning** - Understand different simulation types
- **Historical Analysis** - Apply classical thinking to modern problems
- **Strategic Planning** - War games for policy testing

### Policy Development

- **Risk Assessment** - Test policies under adversarial conditions
- **Stakeholder Analysis** - Identify value conflicts
- **Framework Design** - Develop constitutional principles
- **Public Engagement** - Communicate complex ideas

## 🔬 Technical Architecture

### Frontend Only

- **No Backend Required** - Pure client-side application
- **Static Hosting** - Works on any static file host
- **API Integration** - Direct calls to Gemini API from browser

### Technology Stack

- **HTML5** - Semantic markup
- **CSS3** - Modern styling with gradients and animations
- **Vanilla JavaScript** - No framework dependencies
- **Google Gemini 2.0 Flash** - AI-powered generation

### Browser Compatibility

Tested on:
- Chrome 90+
- Firefox 88+
- Safari 14+
- Edge 90+

## 📊 Example Workflows

### Workflow 1: Policy Impact Analysis

```
1. Open Scenario Generator
2. Generate "UBI Implementation" scenario
3. Review stakeholder conflicts
4. Open Simulation Explorer
5. Model with ABM demo
6. Analyze emergent patterns
```

### Workflow 2: Constitutional Stress Test

```
1. Open AI Federalist Papers
2. Generate Madison's view on "AI Faction Dangers"
3. Open War Games Simulator
4. Generate "AI Arms Race" scenario
5. Test Madison's principles under pressure
6. Document insights
```

### Workflow 3: Historical Learning

```
1. Open AI Federalist Papers
2. Generate Hamilton on "AI Commerce"
3. Generate Madison on same topic
4. Generate Jay on same topic
5. Compare frameworks
6. Apply to modern policy
```

## 🐛 Troubleshooting

### API Key Not Working

**Problem:** "Invalid API key" error
**Solution:**
1. Verify key starts with "AIza"
2. Check key is enabled on Google AI Studio
3. Ensure API is activated for your project
4. Test connection in API Key Manager

### Tools Not Loading

**Problem:** Blank page or errors
**Solution:**
1. Check browser console for errors
2. Verify all files are present
3. Use HTTPS (not HTTP) for GitHub Pages
4. Clear browser cache and reload

### CORS Errors

**Problem:** "CORS policy" errors
**Solution:**
1. Use a local server (not file://)
2. Deploy to proper hosting (GitHub Pages, Vercel, Netlify)
3. Gemini API supports CORS from browsers

## 📄 License

MIT License - See LICENSE file for details

## 🙏 Acknowledgments

- **Anthropic** - For Constitutional AI concepts
- **Google** - For Gemini API access
- **Open Source Community** - For inspiration and tools

## 📞 Support

- **Issues:** [GitHub Issues](https://github.com/YOUR_USERNAME/constitutional-ai-toolkit/issues)
- **Discussions:** [GitHub Discussions](https://github.com/YOUR_USERNAME/constitutional-ai-toolkit/discussions)
- **Documentation:** See included markdown guides

## 🗺️ Roadmap

### v1.1 (Planned)
- [ ] Export scenarios to JSON
- [ ] Import existing scenarios
- [ ] Share scenarios via URL
- [ ] Additional simulation types

### v1.2 (Planned)
- [ ] Collaborative scenario building
- [ ] Real-time simulation runs in browser
- [ ] Visualization enhancements
- [ ] Mobile optimization

### v2.0 (Future)
- [ ] Python ABM integration
- [ ] Advanced analytics dashboard
- [ ] Multi-language support
- [ ] Offline mode

---

**Built with ❤️ for understanding constitutional AI governance**

Version 1.0.0 | Last Updated: 2026-01-21
