# typed: false
# frozen_string_literal: true

class AppleMailMcp < Formula
  desc "MCP server for Apple Mail — natural language email management"
  homepage "https://github.com/sm-moshi/apple-mail-mcp"
  url "https://github.com/sm-moshi/apple-mail-mcp/archive/refs/tags/v2.6.2.tar.gz"
  sha256 "3bf32b1562ca53e4e40be7749ad7ed7a000f8b924026066ea23d16509ad719cc"
  license "Apache-2.0"

  depends_on :macos
  depends_on "uv"

  def install
    # Install all source files into libexec
    libexec.install Dir["*"]

    # Create wrapper script in bin
    (bin/"apple-mail-mcp").write <<~EOS
      #!/bin/bash
      set -e
      exec "#{libexec}/start_mcp.sh" "$@"
    EOS
    (bin/"apple-mail-mcp").chmod 0755
  end

  def caveats
    <<~EOS
      Apple Mail MCP requires macOS with Apple Mail configured.

      To use with Claude Desktop, add to your MCP config:
        {
          "apple-mail-mcp": {
            "command": "#{opt_bin}/apple-mail-mcp"
          }
        }

      To use with Claude Code:
        claude mcp add apple-mail-mcp #{opt_bin}/apple-mail-mcp

      On first run, macOS will prompt for Mail.app access permissions.
    EOS
  end

  test do
    # Verify the start script exists and is executable
    assert_predicate libexec/"start_mcp.sh", :executable?
    # Verify the Python entry point exists
    assert_path_exists libexec/"apple_mail_mcp.py"
  end
end
