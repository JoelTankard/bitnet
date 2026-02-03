/**
 * BitNet LLM Provider for OpenClaw
 *
 * This provider connects OpenClaw to a BitNet inference server running
 * the llama-server with OpenAI-compatible API endpoints.
 *
 * BitNet uses 1.58-bit quantization for extremely efficient inference,
 * making it ideal for running LLMs on local devices.
 */

const BITNET_API_URL = process.env.BITNET_API_URL || 'http://bitnet-server:8080';

/**
 * BitNet Provider Configuration
 */
const BitNetProvider = {
  name: 'bitnet',
  displayName: 'BitNet 1-bit LLM',

  /**
   * Available models configuration
   */
  models: {
    'bitnet-b1.58-2b': {
      id: 'bitnet-b1.58-2b',
      name: 'BitNet b1.58 2B (Official)',
      description: 'Official Microsoft BitNet 2B parameter model trained on 4T tokens',
      contextLength: 4096,
      capabilities: ['chat', 'completion'],
    },
    'bitnet-b1.58-large': {
      id: 'bitnet-b1.58-large',
      name: 'BitNet b1.58 Large (0.7B)',
      description: 'Smaller 0.7B model for faster inference',
      contextLength: 2048,
      capabilities: ['chat', 'completion'],
    },
    'bitnet-b1.58-3b': {
      id: 'bitnet-b1.58-3b',
      name: 'BitNet b1.58 3B',
      description: '3.3B parameter model for improved quality',
      contextLength: 4096,
      capabilities: ['chat', 'completion'],
    },
    'llama3-8b-1.58bit': {
      id: 'llama3-8b-1.58bit',
      name: 'Llama3 8B 1.58-bit',
      description: 'Llama3 8B quantized to 1.58-bit weights',
      contextLength: 8192,
      capabilities: ['chat', 'completion'],
    },
  },

  /**
   * Create a chat completion request
   */
  async createChatCompletion(messages, options = {}) {
    const {
      model = 'bitnet-b1.58-2b',
      temperature = 0.7,
      maxTokens = 2048,
      stream = false,
    } = options;

    const response = await fetch(`${BITNET_API_URL}/v1/chat/completions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model,
        messages,
        temperature,
        max_tokens: maxTokens,
        stream,
      }),
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(`BitNet API error: ${response.status} - ${error}`);
    }

    if (stream) {
      return response.body;
    }

    return response.json();
  },

  /**
   * Create a text completion request
   */
  async createCompletion(prompt, options = {}) {
    const {
      model = 'bitnet-b1.58-2b',
      temperature = 0.7,
      maxTokens = 2048,
      stop = null,
    } = options;

    const response = await fetch(`${BITNET_API_URL}/v1/completions`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model,
        prompt,
        temperature,
        max_tokens: maxTokens,
        stop,
      }),
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(`BitNet API error: ${response.status} - ${error}`);
    }

    return response.json();
  },

  /**
   * Check if the BitNet server is healthy
   */
  async healthCheck() {
    try {
      const response = await fetch(`${BITNET_API_URL}/health`, {
        method: 'GET',
        timeout: 5000,
      });
      return response.ok;
    } catch (error) {
      console.error('BitNet health check failed:', error.message);
      return false;
    }
  },

  /**
   * Get model information
   */
  async getModels() {
    try {
      const response = await fetch(`${BITNET_API_URL}/v1/models`);
      if (response.ok) {
        return response.json();
      }
    } catch (error) {
      console.error('Failed to fetch models:', error.message);
    }

    // Return configured models as fallback
    return {
      object: 'list',
      data: Object.values(this.models).map(m => ({
        id: m.id,
        object: 'model',
        owned_by: 'bitnet',
      })),
    };
  },
};

// Export for OpenClaw provider system
module.exports = BitNetProvider;
export default BitNetProvider;
