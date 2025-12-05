FROM node:24-bookworm

ARG TZ
ENV TZ="$TZ"

ARG CLAUDE_CODE_VERSION=latest
ARG CODEX_CLI_VERSION=latest
ARG GEMINI_CLI_VERSION=latest
ARG GIT_DELTA_VERSION=0.18.2
ARG ZSH_IN_DOCKER_VERSION=1.2.0
ARG USERNAME=node

# Install base tools, networking utilities, and Python for data helpers
RUN apt-get update && apt-get install -y --no-install-recommends \
  aggregate \
  curl \
  dnsutils \
  fzf \
  gh \
  git \
  gnupg2 \
  iproute2 \
  ipset \
  iptables \
  jq \
  less \
  make \
  man-db \
  nano \
  procps \
  python3 \
  python3-pip \
  python3-venv \
  sudo \
  unzip \
  vim \
  wget \
  zsh \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Install Playwright system dependencies for browser automation
# These are required for Playwright to run Chromium, Firefox, and WebKit
RUN apt-get update && apt-get install -y --no-install-recommends \
  libnss3 \
  libnspr4 \
  libatk1.0-0 \
  libatk-bridge2.0-0 \
  libcups2 \
  libdrm2 \
  libdbus-1-3 \
  libxkbcommon0 \
  libatspi2.0-0 \
  libxcomposite1 \
  libxdamage1 \
  libxfixes3 \
  libxrandr2 \
  libgbm1 \
  libpango-1.0-0 \
  libcairo2 \
  libasound2 \
  libxshmfence1 \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

# Ensure default node user has access to /usr/local/share
RUN mkdir -p /usr/local/share/npm-global && \
  chown -R ${USERNAME}:${USERNAME} /usr/local/share

# Persist shell history
RUN SNIPPET="export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  && mkdir /commandhistory \
  && touch /commandhistory/.bash_history \
  && chown -R ${USERNAME} /commandhistory

# Set `DEVCONTAINER` environment variable to help with orientation
ENV DEVCONTAINER=true

# Create workspace directory (don't create .claude - it's bind-mounted from host)
RUN mkdir -p /workspace && \
  chown -R ${USERNAME}:${USERNAME} /workspace

WORKDIR /workspace

# Install git-delta for better diffs
RUN ARCH=$(dpkg --print-architecture) && \
  wget "https://github.com/dandavison/delta/releases/download/${GIT_DELTA_VERSION}/git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
  sudo dpkg -i "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
  rm "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb"

# Enable corepack for pnpm/yarn support (requires root)
RUN corepack enable

# Set up non-root user
USER ${USERNAME}

# Configure npm global directory
ENV NPM_CONFIG_PREFIX=/usr/local/share/npm-global
ENV PATH=$PATH:/usr/local/share/npm-global/bin

# Set the default shell to zsh rather than sh
ENV SHELL=/bin/zsh

# Set the default editor and visual
ENV EDITOR=nano
ENV VISUAL=nano

# Default powerline10k theme
RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v${ZSH_IN_DOCKER_VERSION}/zsh-in-docker.sh)" -- \
  -p git \
  -p fzf \
  -a "source /usr/share/doc/fzf/examples/key-bindings.zsh" \
  -a "source /usr/share/doc/fzf/examples/completion.zsh" \
  -a "export PROMPT_COMMAND='history -a' && export HISTFILE=/commandhistory/.bash_history" \
  -x

# Install Codex, Claude Code, and Gemini CLIs
RUN npm install -g \
  @openai/codex@${CODEX_CLI_VERSION} \
  @anthropic-ai/claude-code@${CLAUDE_CODE_VERSION} \
  @google/gemini-cli@${GEMINI_CLI_VERSION}

# Convenience alias for Claude (add to both bash and zsh)
RUN echo "alias claude-yolo='claude --dangerously-skip-permissions'" >> /home/${USERNAME}/.bashrc && \
  echo "alias claude-yolo='claude --dangerously-skip-permissions'" >> /home/${USERNAME}/.zshrc

# Copy and set up firewall script
COPY init-firewall.sh /usr/local/bin/
USER root
RUN chmod +x /usr/local/bin/init-firewall.sh && \
  echo "${USERNAME} ALL=(root) NOPASSWD: /usr/local/bin/init-firewall.sh" > /etc/sudoers.d/${USERNAME}-firewall && \
  chmod 0440 /etc/sudoers.d/${USERNAME}-firewall

# Allow node user to fix node_modules permissions without password
RUN echo "${USERNAME} ALL=(root) NOPASSWD: /bin/chown -R node\\:node /workspace/node_modules" >> /etc/sudoers.d/${USERNAME}-firewall

USER ${USERNAME}
