/**
 * OpenClaw Custom Providers Index
 *
 * This file exports all custom LLM providers for OpenClaw.
 * The BitNet provider allows using local 1-bit LLMs as the backend.
 */

const BitNetProvider = require('./bitnet-provider');

module.exports = {
  bitnet: BitNetProvider,
};
