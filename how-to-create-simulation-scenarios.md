# 🎬 How to Create Your Own Simulation Scenarios

**Three Powerful Approaches: LLM, Conversation, and Programmatic**

---

## Quick Answer

**Yes! Use LLMs (like Gemini) to generate simulation scenarios.**

I just created a tool for you: **`scenario-generator.html`**

It uses your Gemini API to generate rich, detailed scenarios including:
- Stakeholder analysis
- Value conflicts
- Simulation parameters
- Success metrics
- Risk factors
- Sample Python code

---

## 🎯 Three Approaches to Scenario Creation

### 1. 🤖 LLM-Powered Generation (RECOMMENDED)

**What:** Use AI to create comprehensive scenarios from simple prompts

**Tool:** `scenario-generator.html` (just created for you!)

**How it works:**

```
You describe → AI generates:
  ├── Background context
  ├── Stakeholder analysis
  ├── Constitutional values in conflict
  ├── Simulation parameters (what to vary)
  ├── Success metrics (how to measure)
  ├── Risk factors & uncertainties
  └── Sample implementation code
```

**Example Flow:**

```
INPUT:
"A society where AI judges make all judicial decisions"

GEMINI GENERATES:
---
SCENARIO: AI Judicial System

STAKEHOLDERS:
- Citizens seeking justice (want fairness, speed)
- Human judges (job displacement concerns)
- Legal professionals (adaptation needs)
- Government (efficiency vs legitimacy)
- Tech companies (AI development)

VALUE CONFLICTS:
1. Efficiency vs. Human Judgment
2. Consistency vs. Contextual Understanding
3. Objectivity vs. Empathy
4. Innovation vs. Tradition

SIMULATION PARAMETERS:
- ai_adoption_rate: 0.0 to 1.0 (% of cases handled by AI)
- accuracy_rate: 0.85 to 0.99 (AI decision quality)
- public_trust: 0.0 to 1.0 (citizen confidence)
- human_oversight: 0.0 to 1.0 (review percentage)
- case_complexity: 1 to 10 (simple to complex cases)

SUCCESS METRICS:
- Case resolution time (days)
- Appeal rate (%)
- Public satisfaction (0-10)
- Cost per case ($)
- Perceived fairness (0-10)

SAMPLE CODE:
class Citizen(Agent):
    def __init__(self):
        self.trust_in_ai_judges = random.uniform(0.3, 0.7)
        self.case_history = []

    def file_case(self, ai_system):
        outcome = ai_system.decide(self.case)
        self.update_trust(outcome.perceived_fairness)
---
```

**Advantages:**
- ✅ Fast (seconds, not hours)
- ✅ Comprehensive (doesn't miss key factors)
- ✅ Creative (suggests angles you might miss)
- ✅ Consistent structure
- ✅ Includes code templates

**When to use:**
- Quick scenario brainstorming
- First draft of simulation design
- Exploring unfamiliar domains
- Teaching/learning exercises

---

### 2. 💬 Conversational Design (ITERATIVE)

**What:** Have a dialogue with AI to refine scenarios step-by-step

**How it works:**

```
Round 1: You describe broad idea
Round 2: AI asks clarifying questions
Round 3: You provide answers
Round 4: AI generates refined scenario
Round 5: You request modifications
Round 6: AI iterates...
```

**Example Conversation:**

```
YOU:
"I want to simulate introducing UBI in a country"

AI:
"Great! Let me ask some clarifying questions:
1. Which country/region? (affects existing welfare systems)
2. What UBI amount? (as % of median income)
3. What's the funding mechanism? (taxes, printing, dividend?)
4. Time horizon? (pilot vs permanent)
5. What are you trying to discover? (poverty, work, innovation?)
6. Who are the key opposition groups?"

YOU:
"USA, $1000/month, funded by VAT, 10-year simulation.
Want to understand impact on employment and entrepreneurship."

AI:
"Perfect! Here's your scenario:

SCENARIO: USA UBI Implementation (2026-2036)

SETUP:
- Base UBI: $1000/month ($12K/year)
- Funding: 10% VAT on goods/services
- Phase-in: 3 years (start at $500, reach $1000)
- Replace: Some existing welfare programs
- Population: 330M citizens, 260M adults

KEY QUESTIONS:
1. Will people stop working?
2. Will entrepreneurship increase?
3. What happens to wages?
4. Who benefits/loses most?

SIMULATION PARAMETERS:
labor_elasticity: -0.1 to -0.5 (how much work decreases)
entrepreneurship_boost: 0% to 30% (new business formation)
wage_pressure: -10% to +10% (change in low-skill wages)
...

Would you like me to:
A) Add more stakeholder groups
B) Specify regional variations
C) Include political dynamics
D) Generate the code now"

YOU:
"Add political dynamics - how do conservatives and progressives respond?"

[Conversation continues...]
```

**Advantages:**
- ✅ More nuanced (captures your specific needs)
- ✅ Educational (you learn by asking questions)
- ✅ Flexible (easy to pivot direction)
- ✅ Collaborative (AI helps you think)

**When to use:**
- Complex, multi-faceted scenarios
- When you're uncertain about details
- When you want to explore multiple angles
- Research/academic contexts

---

### 3. 🛠️ Programmatic Templates (SYSTEMATIC)

**What:** Create reusable templates that can be parameterized

**How it works:**

```python
# Define a scenario template
class ScenarioTemplate:
    def __init__(self, template_type):
        self.structure = TEMPLATES[template_type]

    def generate(self, **params):
        scenario = self.structure.copy()
        scenario['title'] = params['title']
        scenario['timeframe'] = params['timeframe']
        scenario['population_size'] = params['population']
        # ... fill in other fields
        return scenario

# Use it
template = ScenarioTemplate('policy_intervention')
scenario = template.generate(
    title="Carbon Tax Implementation",
    timeframe=20,
    population=67_000_000,  # UK
    intervention_strength=0.7,
    opposition_level=0.4
)
```

**Example Template Library:**

```python
SCENARIO_TEMPLATES = {
    'policy_intervention': {
        'stakeholders': ['government', 'citizens', 'industry', 'activists'],
        'metrics': ['gdp', 'satisfaction', 'compliance', 'emissions'],
        'parameters': ['intervention_strength', 'enforcement', 'subsidies'],
        'uncertainties': ['public_reaction', 'economic_shock', 'tech_breakthrough']
    },

    'technological_disruption': {
        'stakeholders': ['early_adopters', 'workers', 'companies', 'regulators'],
        'metrics': ['adoption_rate', 'job_displacement', 'productivity', 'safety'],
        'parameters': ['tech_maturity', 'cost_decline', 'regulation_speed'],
        'uncertainties': ['reliability', 'public_trust', 'competing_tech']
    },

    'rights_expansion': {
        'stakeholders': ['rights_recipients', 'traditionalists', 'courts', 'activists'],
        'metrics': ['legal_protection', 'social_acceptance', 'backlash', 'enforcement'],
        'parameters': ['scope', 'enforcement_budget', 'education_campaign'],
        'uncertainties': ['court_rulings', 'cultural_shift', 'opposition_intensity']
    }
}

# Mix and match!
def combine_templates(template1, template2):
    """Create complex scenarios by combining simpler ones"""
    combined = {
        'stakeholders': list(set(template1['stakeholders'] + template2['stakeholders'])),
        'metrics': list(set(template1['metrics'] + template2['metrics'])),
        'parameters': list(set(template1['parameters'] + template2['parameters'])),
    }
    return combined

# Example: UBI + Climate Crisis
scenario = combine_templates(
    SCENARIO_TEMPLATES['policy_intervention'],  # UBI
    SCENARIO_TEMPLATES['technological_disruption']  # Green tech
)
```

**Advantages:**
- ✅ Consistent structure across scenarios
- ✅ Fast generation of variations
- ✅ Easy to A/B test scenario designs
- ✅ Reusable across projects
- ✅ Version controlled

**When to use:**
- Running many scenario variations
- Systematic scenario exploration
- Reproducible research
- Production simulation systems

---

## 🚀 Practical Workflow

### Recommended 3-Step Process:

**Step 1: LLM Generation (5 minutes)**
```
Use scenario-generator.html to create initial draft
↓
Get comprehensive starting point
```

**Step 2: Conversational Refinement (15 minutes)**
```
Use your n8n Constitution Explorer or chat with Claude
↓
Ask clarifying questions
Add nuance and detail
Iterate on specific sections
```

**Step 3: Programmatic Implementation (30+ minutes)**
```
Convert to code template
Add to your scenario library
Run variations
Test and validate
```

---

## 💡 Examples by Scenario Type

### Technology Scenarios

**Prompt for LLM:**
```
"Simulate a society where brain-computer interfaces
become as common as smartphones. What constitutional
values are affected? Include privacy, autonomy, equality,
and identity considerations."
```

**Parameters to vary:**
- Adoption rate (0% → 80%)
- Price (luxury → commodity)
- Capabilities (basic → enhanced cognition)
- Regulation (none → strict)
- Security (vulnerable → secure)

**Metrics:**
- Cognitive inequality (Gini coefficient)
- Privacy violations (incidents/year)
- Mental health (depression rates)
- Productivity (GDP impact)
- Identity confusion (self-reports)

---

### Economic Scenarios

**Prompt for LLM:**
```
"Design a scenario where a country implements a
4-day work week as a constitutional right. Model the
economic, social, and political impacts over 20 years."
```

**Parameters:**
- Weekly hours (32-40)
- Wage adjustment (-20% to 0%)
- Productivity change (-10% to +20%)
- International competitiveness
- Enforcement strength

**Metrics:**
- GDP per capita
- Unemployment rate
- Life satisfaction
- Health outcomes
- Business competitiveness

---

### Rights Scenarios

**Prompt for LLM:**
```
"Explore granting rivers and ecosystems legal personhood
as a constitutional right. Who are stakeholders? What
conflicts arise? How do courts handle this?"
```

**Parameters:**
- Scope (which ecosystems)
- Enforcement mechanism
- Standing (who can sue)
- Remedies (fines, restoration, halt)
- Budget for representation

**Metrics:**
- Ecosystem health indices
- Legal cases filed/year
- Economic impact (projects blocked)
- Public support
- Implementation costs

---

## 🔧 Integration with Your Tools

### Use with n8n Workflows

**Create a Scenario Generation Workflow:**

```
1. Webhook Trigger
   ↓
2. Gemini API Call (scenario generation)
   ↓
3. Parse Response (extract sections)
   ↓
4. Store in Database (scenario library)
   ↓
5. Return Formatted Scenario
```

**n8n Node Structure:**
```json
{
  "nodes": [
    {
      "name": "Scenario Request",
      "type": "webhook",
      "parameters": {
        "path": "generate-scenario"
      }
    },
    {
      "name": "Call Gemini",
      "type": "httpRequest",
      "parameters": {
        "url": "https://generativelanguage.googleapis.com/...",
        "body": {
          "contents": [{
            "parts": [{
              "text": "={{ $json.prompt }}"
            }]
          }]
        }
      }
    },
    {
      "name": "Format Response",
      "type": "code",
      "parameters": {
        "code": "// Parse and structure scenario"
      }
    }
  ]
}
```

### Use in Python ABM

```python
# Load scenario from LLM generation
import json

with open('scenario.json') as f:
    scenario = json.load(f)

# Create ABM from scenario
class ScenarioSimulation:
    def __init__(self, scenario_config):
        self.name = scenario_config['title']
        self.stakeholders = scenario_config['stakeholders']
        self.parameters = scenario_config['parameters']
        self.metrics = scenario_config['metrics']

        # Create agents for each stakeholder type
        self.agents = []
        for stakeholder in self.stakeholders:
            for i in range(stakeholder['count']):
                agent = self.create_agent(stakeholder['type'])
                self.agents.append(agent)

    def run(self, years):
        for year in range(years):
            self.step()
            self.record_metrics()

# Use it
sim = ScenarioSimulation(scenario)
sim.run(years=20)
results = sim.get_results()
```

---

## 📊 Advanced: Multi-Scenario Ensemble

**Generate scenario variations systematically:**

```python
# Base scenario
base = generate_scenario_with_llm("UBI implementation")

# Create variations
variations = []
for ubi_amount in [500, 1000, 1500, 2000]:
    for funding in ['vat', 'wealth_tax', 'carbon_tax']:
        for phase_in in [1, 3, 5]:
            var = create_variation(
                base,
                ubi_amount=ubi_amount,
                funding=funding,
                phase_in_years=phase_in
            )
            variations.append(var)

# Run ensemble
results = []
for scenario in variations:
    result = run_simulation(scenario)
    results.append(result)

# Analyze
analyze_sensitivity(results)  # Which parameters matter most?
find_robust_policies(results)  # Which work across scenarios?
```

---

## 🎓 Learning Exercise

**Try this progression:**

1. **Day 1:** Use `scenario-generator.html` to create 3 scenarios
2. **Day 2:** Pick one scenario, have conversational refinement
3. **Day 3:** Convert to code template
4. **Day 4:** Run ABM simulation
5. **Day 5:** Generate 10 variations, run ensemble

---

## 🎯 Best Practices

### ✅ Do's:

1. **Start broad, refine narrow**
   - Initial LLM prompt: general idea
   - Conversation: add specific details
   - Template: lock in structure

2. **Version control your scenarios**
   ```
   scenarios/
   ├── v1_ubi_basic.json
   ├── v2_ubi_refined.json
   └── v3_ubi_final.json
   ```

3. **Test with simple parameters first**
   - Start with 2-3 parameters
   - Add complexity gradually
   - Validate each step

4. **Document assumptions**
   ```python
   scenario = {
       'title': 'UBI',
       'assumptions': [
           'Rational economic actors',
           'No capital flight',
           'Perfect information'
       ]
   }
   ```

5. **Include uncertainty ranges**
   ```python
   'ubi_amount': {
       'min': 500,
       'baseline': 1000,
       'max': 2000,
       'uncertainty': 'high'
   }
   ```

### ❌ Don'ts:

1. **Don't over-specify initially**
   - Bad: "UBI of exactly $1,247.32 funded by 8.73% VAT"
   - Good: "UBI around $1000-1500 funded by consumption tax"

2. **Don't ignore stakeholder diversity**
   - Bad: "Citizens"
   - Good: "Low-income workers, middle class, wealthy, retirees"

3. **Don't skip validation**
   - Always ask: "Does this make sense?"
   - Test with extreme parameters
   - Compare to historical cases

4. **Don't generate scenarios in isolation**
   - Get feedback from domain experts
   - Test with potential users
   - Iterate based on critique

---

## 📚 Resources

### Tools Created for You:

1. **`scenario-generator.html`** - LLM-powered generator
2. **`constitutional-ai-simulation-explorer.html`** - Interactive learning
3. **`constitutional-value-discovery-summary.md`** - Complete reference

### Next Steps:

1. Open `scenario-generator.html`
2. Try generating a scenario
3. Refine it through conversation (use your Constitution Explorer)
4. Implement in code
5. Share your results!

---

## 💡 Example: Complete Workflow

```
STEP 1: Generate with LLM (5 min)
→ Open scenario-generator.html
→ Prompt: "Society with AI voting advisors"
→ Get comprehensive scenario

STEP 2: Refine via Conversation (15 min)
→ Use Constitution Explorer Q&A
→ Ask: "What if only 10% adopt AI advisors?"
→ Ask: "How do echo chambers form?"
→ Add those insights to scenario

STEP 3: Create Template (30 min)
→ Convert to JSON structure
→ Identify variable parameters
→ Write Python class

STEP 4: Implement ABM (2 hours)
→ Create Citizen agents
→ Add AI advisor logic
→ Model social influence
→ Run simulation

STEP 5: Analyze (1 hour)
→ Vary AI adoption (0% → 100%)
→ Vary AI bias (-1 to +1)
→ Generate outcome plots
→ Identify tipping points

TOTAL: ~4 hours from idea to results!
```

---

## 🎉 You're Ready!

You now have:
- ✅ 3 methods to create scenarios
- ✅ LLM-powered tool ready to use
- ✅ Templates and examples
- ✅ Integration with your n8n setup
- ✅ Best practices guide

**Start creating scenarios today!** 🚀

The `scenario-generator.html` tool is ready in your Downloads folder.
Just describe what you want to simulate, and Gemini will create
a comprehensive scenario with all the details you need.

---

**Created:** 2026-01-21
**Tools:** scenario-generator.html, Constitution Explorer, Gemini API
