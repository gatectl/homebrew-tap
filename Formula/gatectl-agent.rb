class GatectlAgent < Formula
  desc "GateCtl agent — AI governance proxy endpoint agent"
  homepage "https://github.com/gatectl/gatectl"
  version "0.2.1"
  license "Proprietary"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/gatectl/gatectl/releases/download/v0.2.1/gatectl-agent-darwin-arm64.tar.gz"
      sha256 "592a6db87acfb6b8ed43287762bb7f28fc961d319e29ffc3b262d17cf52722b6"

      def install
        bin.install "gatectl-agent-darwin-arm64" => "gatectl-agent"
      end
    else
      url "https://github.com/gatectl/gatectl/releases/download/v0.2.1/gatectl-agent-darwin-amd64.tar.gz"
      sha256 "179b856849b5a4248f8272b749c5fa4d31179e67b4a3e843d3f4461fc97c3789"

      def install
        bin.install "gatectl-agent-darwin-amd64" => "gatectl-agent"
      end
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/gatectl/gatectl/releases/download/v0.2.1/gatectl-agent-linux-arm64.tar.gz"
      sha256 "03b2c1137a45e0ff8924c3da9c399e7d5ebcdda26d3231b591b20710ab5add83"

      def install
        bin.install "gatectl-agent-linux-arm64" => "gatectl-agent"
      end
    else
      url "https://github.com/gatectl/gatectl/releases/download/v0.2.1/gatectl-agent-linux-amd64.tar.gz"
      sha256 "dedd3f3a8b38a24ef60d970dcb8c6f5cfca737023d11ef4a077452c60028488e"

      def install
        bin.install "gatectl-agent-linux-amd64" => "gatectl-agent"
      end
    end
  end

  def caveats
    <<~EOS
      To connect the agent to your GateCtl server:

        gatectl-agent init --server <server-addr>

      This will create a config file and register the agent.

      To start the agent as a background service:

        brew services start gatectl-agent

      Or run it manually:

        gatectl-agent --config ~/.gatectl-agent/agent.yaml
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
