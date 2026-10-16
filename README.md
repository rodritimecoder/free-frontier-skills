# ⚡ Free Frontier Skills (`free-frontier-skills`)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Endpoints: OpenRouter & NVIDIA NIM](https://img.shields.io/badge/Endpoints-OpenRouter%20%7C%20NVIDIA%20NIM-green.svg)](#-flagship-skills)
[![Architecture: Kem Glitch Subagents](https://img.shields.io/badge/Architecture-Compound%20Bash%20Batching-purple.svg)](#-the-compound-bash-protocol)

Delegate autonomous coding loops, bash execution, deep reasoning, calibrated decision routing, and vector embeddings to verified zero-cost and free-tier hosted frontier endpoints without burning your primary model token quotas.

---

## 🏛️ Flagship Skills

```
                               ┌────────────────────────────────────────┐
                               │   AI Coding Agent / Orchestrator      │
                               │   (Antigravity, Claude, Roo, Pi)       │
                               └──────────────────┬─────────────────────┘
                                                  │
                 ┌────────────────────────────────┴────────────────────────────────┐
                 ▼                                                                 ▼
    ┌──────────────────────────────┐                              ┌──────────────────────────────┐
    │       nvidia-nim (Skill)     │                              │    openrouter-free (Skill)   │
    │  • GLM-5.3 Flash (Reasoning) │                              │  • Nemotron-3 Ultra (550B)   │
    │  • DeepSeek R1 & V3          │                              │  • Nemotron-3.5 Lightning    │
    │  • Multi-Key Pool Failover   │                              │  • Mercury Decide Engine     │
    │  • Nemotron Embed VL 1B      │                              │  • Fish Audio TTS & LFM Embed│
    └──────────────┬───────────────┘                              └──────────────┬───────────────┘
                   │                                                             │
                   └──────────────────────────────┬──────────────────────────────┘
                                                  │
                                 ┌────────────────▼───────────────┐
                                 │   Autonomous Subagent Loop     │
                                 │   • run_bash_batch Execution   │
                                 │   • Response Disk Buffering    │
                                 │   • Multi-Turn Verification    │
                                 └────────────────────────────────┘
```

| Skill | Primary Models | Capabilities | Zero-Cost Provider |
| :--- | :--- | :--- | :--- |
| **[`nvidia-nim`](./nvidia-nim/)** | `z-ai/glm-5.3-flash`, `deepseek-ai/deepseek-r1`, `nvidia/llama-nemotron-embed-vl-1b-v2` | Autonomous coding subagent, deep reasoning traces (`--thinking`), multi-key pool rotation, 2048d embeddings | [build.nvidia.com](https://build.nvidia.com) |
| **[`openrouter-free`](./openrouter-free/)** | `nvidia/nemotron-3-ultra-550b-a55b:free`, `inception/mercury-decide:free`, `fish-audio/s2.1-pro-free:free` | 550B reasoning, calibrated decision routing, zero-cost text-to-speech, batched embeddings | [openrouter.ai](https://openrouter.ai) |

---

## ⚡ The Compound Bash Protocol (`run_bash_batch`)

Standard LLM tool calling consumes 1 API turn per shell command (`cd`, `ls`, `grep`, `edit`, `test`). In an autonomous loop, running 5 discrete commands burns 5 round-trips and thousands of tokens.

Both skills in this suite implement **Compound Bash Batching**:
1. The subagent receives `run_bash_batch` with an ordered array of commands.
2. All commands execute sequentially inside a single subshell (`set -eo pipefail`).
3. Working directory state persists (`cd` sticks across commands).
4. Output is aggregated and returned in a single turn, slashing turn consumption by **75–80%**.

---

## 🚀 Quick Start Guide

### 1. Autonomous Coding Subagent (`nim agent` & `openrouter-free agent`)

Run a self-contained autonomous agent to inspect code, run tests, and report back:

```bash
# Using NVIDIA GLM-5.3 Flash
nvidia-nim agent \
  --prompt "Inspect src/auth.ts, fix the unhandled null token bug, run tests, and report." \
  --max-turns 6 \
  --out /tmp/subagent_report.md

# Using OpenRouter Nemotron-3.5 Lightning Free
openrouter-free agent \
  --prompt "Check git diff for TypeScript any casts and summarize." \
  --out /tmp/diff_report.md
```

### 2. Fast Reasoning with Thinking Trace (`nim chat`)

Stream live reasoning from GLM-5.3 Flash:

```bash
# Query with visible reasoning trace
nvidia-nim chat "Which number is larger, 9.11 or 9.8?" --thinking

# Buffer large output to disk with a 2-line summary preview (Kem Glitch token reduction)
nvidia-nim chat "Generate CMakeLists.txt for a C project" --out /tmp/build.cmake --project
```

### 3. Calibrated Decision Routing (`decide`)

Perform zero-shot discrete triage with confidence scoring:

```bash
# Using Mercury Decide
openrouter-free decide \
  --query "Is this pull request safe to deploy immediately?" \
  --options "deploy_now" "needs_human_review" "block_build"

# Using NVIDIA NIM
nvidia-nim decide \
  --query "Should we run integration tests before release?" \
  --options "run_tests" "skip" "abort"
```

### 4. Batched Vector Embeddings (`embed`)

Generate dense vector embeddings for texts or files in 1 single HTTP request:

```bash
# NVIDIA NeMo Retriever (2048 dims)
nvidia-nim embed "Kernel memory architecture" "Page tables in x86" README.md \
  --out-json /tmp/embeddings.json

# Liquid LFM Embeddings
openrouter-free embed \
  --inputs "First chunk" "Second chunk" \
  --out-json /tmp/lfm_vectors.json
```

---

## 🔐 Credentials & Setup

Configure your API keys in `~/.agent_keys.env` or `.env`:

```bash
# Get free key from https://build.nvidia.com
export NVIDIA_API_KEY="nvapi-..."

# Optional multi-key pool for automatic failover
export NVIDIA_API_KEYS="nvapi-key1,nvapi-key2"

# Get free key from https://openrouter.ai/settings/keys
export OPENROUTER_API_KEY="sk-or-v1-..."
```

Verify your setup:
```bash
nvidia-nim doctor
```

---

## 📄 License

MIT © [rodritimecoder](https://github.com/rodritimecoder).
