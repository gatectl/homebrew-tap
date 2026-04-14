class GatectlAgent < Formula
  desc "GateCtl agent — AI governance proxy endpoint agent"
  homepage "https://github.com/gatectl/gatectl"
  version "0.4.0-dev"
  license "Proprietary"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gatectl/releases/releases/download/v0.4.0-dev/gatectl-agent-darwin-arm64.tar.gz"
      sha256 "26a839b9e5bbbebd19d1c13ae1ce3a4ed3c26ff0b05c8c1ecfae66ca90d6fc67"

      def install
        bin.install "gatectl-agent-darwin-arm64" => "gatectl-agent"
      end
    else
      url "https://github.com/gatectl/releases/releases/download/v0.4.0-dev/gatectl-agent-darwin-amd64.tar.gz"
      sha256 "a276c6b9230a19cad5c23f916bcf9ce8b96ef22f1b03cfd9fe8de9e7076fab22"

      def install
        bin.install "gatectl-agent-darwin-amd64" => "gatectl-agent"
      end
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gatectl/releases/releases/download/v0.4.0-dev/gatectl-agent-linux-arm64.tar.gz"
      sha256 "73a17539c41ccf0f3ed52151f18a1b2249308a3ef54b5ce5b3c1553b12946a19"

      def install
        bin.install "gatectl-agent-linux-arm64" => "gatectl-agent"
      end
    else
      url "https://github.com/gatectl/releases/releases/download/v0.4.0-dev/gatectl-agent-linux-amd64.tar.gz"
      sha256 "08a95b8497537cfd0174442ee957b8c238985119bf5c821198c46cbeadef6c68"

      def install
        bin.install "gatectl-agent-linux-amd64" => "gatectl-agent"
      end
    end
  end

  def caveats
    <<~EOS
      To connect the agent to your GateCtl server:

        gatectl-agent init --server <server-addr>:9443 --token <bootstrap-token>

      For local Docker Desktop with self-signed certs:

        gatectl-agent init --server localhost:9443 --token <token> --skip-verify

      To start the agent as a background service:

        brew services start gatectl-agent
    EOS
  end

  service do
    run [opt_bin/"gatectl-agent", "--config", var/"gatectl-agent/agent.yaml"]
    keep_alive true
    log_path var/"log/gatectl-agent.log"
    error_log_path var/"log/gatectl-agent.log"
    working_dir var/"gatectl-agent"
  end

  test do
    assert_match "gatectl-agent", shell_output("#{bin}/gatectl-agent --help 2>&1", 0)
  end
end
