# OpenCode container

An opinionated [OpenCode](https://github.com/anomalyco/opencode) container with podman and other tools as well as a starter script, allowing to run a coding agent with improved isolation that is able to create nested Linux containers itself.

## Installation

Copy the [opencode.sh](./opencode.sh) script into an `opencode` file within a directory that is registered within your `PATH`.

## Configuration

### Using a self-hosted LLM

To ensure data privacy and allow offline operations, you can let OpenCode use a self-hosted LLM running on your own hardware/infrastructure.

To configure OpenCode to use your self-hosted model, configure it within `~/.config/opencode/opencode.json`.  
For example the following configuration allows to use the Qwen3.8-Flash-Next LLM that is served via an OpenAI-compatible API at `http://localai:8731/v1`:
```json
{
  "$schema": "https://opencode.ai/config.json",
  "model": "local/halogen-qwen3.8-flash-next",
  "compaction": {
    "auto": true,
    "prune": true
  },
  "provider": {
    "local": {
      "npm": "@ai-sdk/openai-compatible",
      "name": "localai",
      "options": {
        "baseURL": "http://localai:8731/v1"
      },
      "models": {
        "halogen-qwen3.8-flash-next": {
          "name": "Qwen3.8-Flash-Next",
          "limit": {
            "context": 262144,
            "output": 8192
          }
        }
      }
    }
  }
}
```

Examples for locally runnable LLM servers are as follows:
* [Strata](https://github.com/Niko1221/Strata)
* [halogen-flash-server](https://github.com/peonist-ai/halogen-flash-server)
* [strix-llama.cpp](https://github.com/halo-box/strix-llama.cpp)
* [LMStudio](https://lmstudio.ai/)
* [LocalAI](https://github.com/mudler/LocalAI)
* [Ollama](https://github.com/ollama/ollama)

Please note that local LLM execution of capable coding models such as Qwen3.8-Flash-Next or the smaller Qwen3-Coder requires a fast GPU and at least 32GB fast VRAM (better have more).
Currently the cheapest available hardware to run those models on are AMD Ryzen AI APUs with >=64GB shared LPDDR5x memory.
Alternatively, Apple M4 Max workstations, Apple M3 Ultra or NVIDIA DGX Spark could be used.

## Usage

1. If you didn't already clone the git repo you want to edit using OpenCode, please do so, e.g. `git clone <PROJECT> some-project`.
2. Change into the project directory, e.g. `cd some-project`.
3. Run the OpenCode TUI within the project directory: `opencode`.
4. Type your prompt to tell the coding agent what to do.
5. Iterate.

### Recommendations

Sometimes, when OpenCode keeps deviating with every iteration more and more from your goal, it may make sense to terminate it and start from scratch with a more complete initial prompt.

Correspondingly, it may make sense to create a new git commit every now and then while you're iterating so that you have a safe checkpoint you can go back to in case OpenCode suddenly does complete non-sense and so that you can clearly compare the last changes of your generated code based on the git history using additional tools.
