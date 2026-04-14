class GatectlAgent < Formula
  desc "GateCtl agent — AI governance proxy endpoint agent"
  homepage "https://github.com/gatectl/gatectl"
  version "0.4.0-dev.1"
  license "Proprietary"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gatectl/releases/releases/download/v0.4.0-dev/gatectl-agent-darwin-arm64.tar.gz"
      sha256 "10d67ec6ed97efeef945fba2fc1e5ce635f88f60577a2abbb2b062a07999ecb5"

      def install
        bin.install "gatectl-agent-darwin-arm64" => "gatectl-agent"
      end
    else
      url "https://github.com/gatectl/releases/releases/download/v0.4.0-dev/gatectl-agent-darwin-amd64.tar.gz"
      sha256 "098fc1d62b896da6273fd68239a16710d3c72f646dbad514abf2e2de4b8ad713"

      def install
        bin.install "gatectl-agent-darwin-amd64" => "gatectl-agent"
      end
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gatectl/releases/releases/download/v0.4.0-dev/gatectl-agent-linux-arm64.tar.gz"
      sha256 "c65526a37c6061159748bbb73df4ba5fbf78bc2f8a9b1d0024ec12579b1291d5"

      def install
        bin.install "gatectl-agent-linux-arm64" => "gatectl-agent"
      end
    else
      url "https://github.com/gatectl/releases/releases/download/v0.4.0-dev/gatectl-agent-linux-amd64.tar.gz"
      sha256 "ce8e95a13b95bcdf3cef9870f3c7751e2117877eb390b18164d076b96aa94bae"

      def install
        bin.install "gatectl-agent-linux-amd64" => "gatectl-agent"
      end
    end
  end

  def caveats
    <<~EOS
      To connect the agent to your GateCtl server:

        sudo gatectl-agent init --server <server-addr>:9443 --token <bootstrap-token>

      For local Docker Desktop with self-signed certs:

        sudo gatectl-agent init --server localhost:9443 --token <token> --skip-verify

      The agent runs as a LaunchDaemon (auto-starts on boot).
      Logs: /var/log/gatectl-agent.log
    EOS
  end

  service do
    run [opt_bin/"gatectl-agent", "--config", "/etc/gatectl-agent/agent.yaml"]
    require_root true
    keep_alive true
    log_path "/var/log/gatectl-agent.log"
    error_log_path "/var/log/gatectl-agent.log"
  end

  test do
    assert_match "gatectl-agent", shell_output("#{bin}/gatectl-agent --help 2>&1", 0)
  end
end
