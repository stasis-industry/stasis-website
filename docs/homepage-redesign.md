# Homepage Redesign — "The Visual Argument"

**Date:** 2026-03-03
**Status:** Approved, pending implementation

---

## Understanding Summary

- **What:** Restructured homepage scroll where the research narrative — not the tech stack — is the spine of the page
- **Why:** The site reads like a tech demo landing page. The copy says "observatory" but the structure says "cool Rust project." The research identity is absent at the page level.
- **Who:** Dual audience — academic researchers (MAPF / robotics / OR) who need scientific credibility, and engineers at multi-robot companies who need operational relevance
- **Core message:** Performance in ideal conditions does not predict resilience under faults. Scheduler strategy, not solver algorithm, determines fault resilience. No existing tool measures this.
- **Visual strategy:** Interactive mini-scenes demonstrate each concept inline. 3D where scale matters, 2D where conceptual clarity matters.
- **Non-goals:** No docs changes. No WIP pages (Blog, About, Simulator). No visual style overhaul — the aesthetic is already correct.

## Assumptions

1. The KineticGrid component stays as-is — no modifications to its Three.js internals
2. Mini-scenes are 2D canvas/SVG — no additional WebGL contexts
3. The snap-scroll architecture switches from `mandatory` to `proximity` to accommodate variable-height sections
4. Mini-scenes are scripted (hardcoded agent positions, predetermined fault ticks), not real simulations
5. Mini-scenes trigger on IntersectionObserver scroll, not user interaction
6. Mobile: mini-scenes stack below text; split-screen thesis scene stacks vertically
7. The design system (tech-editorial) is fully respected — cream/black, Playfair + DM Mono, zero border-radius buttons

---

## Design System Reference

**File:** `/Users/teddyadmin/.claude/skills/tech-editorial-ui/en/SKILL.md`

Key rules enforced:
- Background: `#F5F2EE` (cream) / `#080808` (dark) / `#F0EDE9` (surface). Never `#ffffff`.
- Buttons: `border-radius: 0` (absolute rule)
- Cards: `border-radius: 12px` (only cards)
- Typography: Playfair Display (titles), DM Mono (UI/labels), Inter (body, weight 300)
- Titles: italic on the conceptual keyword, negative letter-spacing on H1/H2
- Scroll narrative: background shifts as narrative tool (cream → black → cream)
- Generous whitespace: 120px section padding standard, 200px for narrative transitions

---

## Scroll Architecture

```
Section  Background  Type                  Content
───────  ──────────  ────────────────────  ──────────────────────────────────────
1 Hero   Cream       Full viewport         Observatory claim + KineticGrid (3D)
2 Gap    Black       Narrative transition  "Every benchmark assumes a perfect world"
3 Thesis Black       Demo section          Split-screen 2D: resilient vs. fragile
4 Observatory Cream  Demo section          Animated timeline + Resilience Scorecard
5 Cascade Cream      Demo section          2D grid ripple + depth/spread counters
6 Engine  Black      Pillars + stats       Rust, Bevy ECS, WASM + community credit
7 Ecosystem Black    Cards                 MAPF Tracker, MovingAI, SMART MAPF
8 Footer  Cream      Standard              © 2026 Stasis AI
```

---

## Section 1: Hero

KineticGrid stays — full viewport, same position, same gradient overlay. Copy reframes from "what this tool does" to "what question this tool answers."

```html
<h1>
  Resilience is not
  <em>performance.</em>
</h1>

<p class="hero-subtitle">
  MAFIS is a fault resilience observatory for lifelong multi-agent systems.
  It measures what benchmarks can't — how fleets degrade, recover, and adapt
  under real-world faults.
</p>

<div class="hero-cta">
  <a href="/docs" class="btn-docs">View Docs</a>
  <a href="#the-gap" class="btn-primary">Read the thesis ↓</a>
</div>
```

**Changes:** Title, subtitle, left CTA. KineticGrid and layout untouched.

---

## Section 2: The Gap

Cinematic transition. Cream → black. Single centered sentence. Full viewport. Typography *is* the design. 200px padding per the design system's narrative transition pattern.

```html
<section class="gap-section" id="the-gap">
  <div class="gap-inner">
    <span class="section-label">THE GAP</span>
    <h2>Every MAPF benchmark assumes a <em>perfect world.</em></h2>
    <p>
      Existing tools compare solver speed on static grids with no failures,
      no congestion, and no sustained operation. But no warehouse runs
      without faults. No fleet operates in ideal conditions. No benchmark
      answers the question that matters most —
    </p>
    <blockquote>
      "What happens to your fleet when things go wrong —
       and keep going wrong?"
    </blockquote>
  </div>
</section>
```

**CSS:** Centered text, max-width ~700px, 200px vertical padding, black background.

---

## Section 3: The Thesis (Split-Screen Mini-Scene)

Still on black. States the thesis, then proves it with a side-by-side 2D comparison.

```html
<section class="thesis-section">
  <div class="thesis-text">
    <span class="section-label">THE THESIS</span>
    <h2>Performance does not predict <em>resilience.</em></h2>
    <p>
      The same solver. The same map. The same fault.
      One system recovers. The other collapses.
      The only difference is how tasks were assigned.
    </p>
  </div>

  <div class="thesis-scenes">
    <ThesisScene /> <!-- React or Canvas component -->
  </div>

  <p class="thesis-caption">
    Same solver. Same map. Same fault.
    Different scheduler → different resilience profile.
  </p>
</section>
```

### ThesisScene Component

**Type:** 2D canvas (no Three.js)
**Layout:** Two canvases side-by-side, each ~10×10 grid

| Left canvas | Right canvas |
|---|---|
| Label: "DISTRIBUTED LOAD" | Label: "CONCENTRATED LOAD" |
| ~15 agents spread across grid | ~15 agents clustered in corridors |
| Fault fires → agents reroute → recovery | Fault fires → cascade → deadlock |
| Throughput sparkline: dip then recovery | Throughput sparkline: sustained drop |
| Result label: "RESILIENT" | Result label: "FRAGILE" |

**Behavior:**
- Triggered by IntersectionObserver
- Both scenes synchronized — same tick rate, fault fires at same tick
- Loops after ~5 seconds
- Scripted, not simulated — predetermined agent positions and fault tick

**Mobile:** Scenes stack vertically (left on top, right below).

---

## Section 4: The Observatory (Animated Timeline)

Background returns to cream. Explains the two-phase simulation model and Resilience Scorecard through an animated timeline.

```html
<section class="observatory-section">
  <div class="observatory-text">
    <span class="section-label">THE OBSERVATORY</span>
    <h2>Two phases. Four metrics. One resilience <em>profile.</em></h2>
    <p>
      Every MAFIS run begins with a clean baseline — no faults,
      no interference. Then faults activate. The delta between
      clean and degraded performance is the research output.
    </p>
  </div>

  <ObservatoryTimeline /> <!-- SVG/Canvas + CSS -->

  <div class="scorecard">
    <h4>RESILIENCE SCORECARD</h4>
    <div class="scorecard-metric">Robustness      <span>0.87</span></div>
    <div class="scorecard-metric">Recoverability  <span>12 ticks</span></div>
    <div class="scorecard-metric">Adaptability    <span>0.64</span></div>
    <div class="scorecard-metric">Degradation     <span>-0.003/tick (Stable)</span></div>
  </div>
</section>
```

### ObservatoryTimeline Component

**Type:** SVG or Canvas for the timeline, CSS animations for the scorecard

**Animation sequence** (IntersectionObserver trigger):
1. Warmup bar fills left-to-right (~1.5s), "BASELINE CAPTURED" label fades in
2. Phase transition marker: "FAULTS ACTIVE"
3. Throughput curve draws: steady during warmup, dips at fault event, recovers
4. Dashed baseline line appears for comparison
5. Scorecard values count up from 0 to final (reuse existing counter animation pattern)
6. Degradation label "STABLE" types in last

**Mobile:** Full-width, stacked vertically.

---

## Section 5: Cascade Propagation (Ripple Scene)

Still on cream. Side-by-side layout: text left, 2D grid scene right.

```html
<section class="cascade-section">
  <div class="cascade-text">
    <span class="section-label">CASCADE PROPAGATION</span>
    <h2>One fault. Twenty-three agents <em>affected.</em></h2>
    <p>
      When an agent dies, it becomes a permanent obstacle. Agents behind
      it replan — but their new paths block others, who block others still.
      MAFIS traces this chain reaction in real time and measures exactly
      how deep and how wide the damage spreads.
    </p>
  </div>

  <div class="cascade-scene">
    <CascadeScene /> <!-- 2D Canvas -->
    <div class="cascade-metrics">
      <div>CASCADE DEPTH <span class="counter">[4]</span> levels</div>
      <div>CASCADE SPREAD <span class="counter">[23]</span> agents</div>
    </div>
  </div>
</section>
```

### CascadeScene Component

**Type:** 2D canvas, ~12×12 grid

**Animation sequence** (IntersectionObserver trigger):
1. ~20 agents (colored dots) moving along paths on the grid
2. One agent in a corridor turns red (dead), cell becomes obstacle
3. Level 1: 3–4 adjacent agents flash orange, freeze, reroute
4. Level 2: agents blocked by level 1's new paths flash lighter orange
5. Level 3, Level 4: ripple extends outward, each level lighter shade
6. Counters tick: Depth 1→2→3→4, Spread 3→8→15→23
7. After cascade (~3s), affected agents finish rerouting, normal movement resumes
8. Loop after brief pause

**Mobile:** Text stacks above scene.

---

## Section 6: The Engine (Rust / Bevy / WASM)

Dark section. Reuses existing pillar layout + stats grid. Copy reframed to answer "how is this observatory possible at this scale?"

```html
<section class="dark-section">
  <div class="section-inner">
    <h2>Built in Rust. <em>Powered by Bevy.</em></h2>

    <div class="pillar-group">
      <!-- Pillar 1: Zero-Cost Abstractions (orange) -->
      <div class="pillar-row">
        MOD.01 | ZERO-COST ABSTRACTIONS
        No garbage collector pauses. No runtime overhead. Rust's ownership
        model guarantees memory safety at compile time, letting MAFIS run
        500-agent fault simulations without a single allocation in the hot loop.
      </div>

      <!-- Pillar 2: Entity Component System (blue) -->
      <div class="pillar-row">
        MOD.02 | ENTITY COMPONENT SYSTEM
        Built on Bevy Engine — a data-oriented game engine where simulation
        logic is pure systems operating on flat data. Cache-friendly.
        Parallelizable. Deterministic execution order via system sets. The
        ECS architecture is why fault injection, heat propagation, and
        replanning compose cleanly without coupling.
      </div>

      <!-- Pillar 3: WebAssembly (green) -->
      <div class="pillar-row">
        MOD.03 | WEBASSEMBLY
        The full simulation compiles to WASM and runs natively in the browser.
        No server. No install. A researcher opens a URL and runs a 500-agent
        fault resilience experiment at 60fps on commodity hardware.
      </div>
    </div>

    <!-- Stats grid (existing component, existing animation) -->
    <div class="stats-grid">
      [256] Concurrent Agents
      [60 FPS] Fluid Rendering
      [0ms] Latency Overhead
    </div>

    <!-- Bevy community credit -->
    <p class="bevy-credit">
      MAFIS is built with Bevy — an open-source engine driven by an
      extraordinary community of contributors. By choosing Bevy, we invest
      in the future of data-driven simulation engines.
    </p>
    <a href="https://bevyengine.org/" class="eco-link">Bevy Engine ↗</a>
  </div>
</section>
```

**Changes:** Pillar copy rewritten. Bevy community note added. Layout/CSS untouched.

---

## Section 7: Ecosystem

Stays on black (continuing from The Engine). Intro text tightened. Cards unchanged.

```html
<section class="community-section">
  <h3>The MAPF <em>Ecosystem.</em></h3>
  <p class="community-intro">
    MAFIS answers one question: how do multi-agent systems behave under
    faults? Everything else has a home.
  </p>

  <!-- Three eco-cards: Algorithm Benchmarking, Standard Instances, Real-World Testbed -->
  <!-- Content unchanged from current site -->
</section>
```

---

## Section 8: Footer

Unchanged.

---

## New Components to Build

| Component | Type | Complexity | Estimated scope |
|---|---|---|---|
| `<ThesisScene />` | 2D Canvas, React or vanilla | Medium | ~250 lines — scripted dual-grid with synchronized agents |
| `<ObservatoryTimeline />` | SVG + CSS animation | Medium | ~200 lines — timeline drawing + scorecard counter animation |
| `<CascadeScene />` | 2D Canvas, React or vanilla | Low-Medium | ~200 lines — scripted grid with ripple color interpolation |

All three share common patterns:
- IntersectionObserver trigger
- Scripted scenarios (not real simulations)
- Loop after completion
- Responsive: full-width on mobile
- No Three.js, no WebGL — pure 2D canvas or SVG

---

## Preserved from Current Site

- KineticGrid component (hero, untouched)
- Pillar layout + hover-fade CSS (reframed copy only)
- Stats grid + counter animation (moved to Section 6)
- Ecosystem cards (content unchanged)
- Footer (unchanged)
- All CSS variables, fonts, design tokens
- Header component (unchanged)
- Dark/light theme system (unchanged)

---

## CSS Changes

| Change | Description |
|---|---|
| Snap scroll | Switch `scroll-snap-type: y mandatory` → `scroll-snap-type: y proximity` |
| Gap section | New CSS class: centered text, max-width 700px, 200px padding, black bg |
| Thesis section | New CSS class: text + dual-canvas layout, black bg |
| Observatory section | New CSS class: text + timeline + scorecard, cream bg |
| Cascade section | New CSS class: text-left + scene-right layout, cream bg |
| Section labels | New shared class for `THE GAP`, `THE THESIS`, etc. (DM Mono, 10px, uppercase, opacity 0.4) |
| Bevy credit | New CSS for community note (Inter, 300, centered, opacity 0.5) |

---

## Decision Log

| # | Decision | Alternatives | Rationale |
|---|----------|-------------|-----------|
| 1 | Research narrative leads, tech supports | Tech leads (current) | Primary visitor should understand what MAFIS reveals, not how it's built |
| 2 | Three-layer thesis: gap → thesis → claim | Single tagline, feature list | Layered approach gives researchers and engineers each their entry point |
| 3 | Interactive mini-scenes inline | Static illustrations, video, text-only | "Show, don't tell" differentiates. Researchers remember what they saw. |
| 4 | 2D canvas/SVG for mini-scenes | Three.js, pre-rendered video | Clearer at small sizes, simpler to build, no WebGL context conflicts |
| 5 | KineticGrid stays in hero | Move later, remove, shrink | Strongest first-contact visual. Proves "this is real and running." |
| 6 | Hero = thesis statement | Question-based, imperative, product name | Signals research contribution immediately. Bold, memorable. |
| 7 | Gap = standalone cinematic (one sentence, full viewport) | Combined with thesis, combined with features | 200px-padding isolation gives the problem statement maximum weight |
| 8 | Thesis = split-screen side-by-side | Before/after toggle, sequential | Side-by-side comparison is instant — no interaction required |
| 9 | Observatory = animated timeline | Static diagram, video | Animation mirrors actual tool experience |
| 10 | Tech section moves from position 2 to 6 | Keep position 2, remove, split | Position 6 answers "how?" after visitor knows "what?" |
| 11 | Bevy community gets explicit credit | Logo only, link only, omit | Community membership signal. Values signal for recruiters. |
| 12 | Snap scroll: proximity instead of mandatory | Remove, keep mandatory | Flexible heights for demo sections, still snaps on viewport-fit sections |
