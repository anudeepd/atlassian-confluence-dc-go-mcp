# Atlassian Confluence Data Center MCP Server (Go)

[![Go Version](https://img.shields.io/badge/Go-1.25.5-blue.svg)](https://golang.org)
[![MCP](https://img.shields.io/badge/MCP-0.43.2-green.svg)](https://github.com/mark3labs/mcp-go)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

A Model Context Protocol (MCP) server implementation in Go for interacting with Atlassian Confluence Data Center edition. This server enables AI assistants and other MCP clients to read, search, create, and update Confluence content programmatically.

> **Note**: This is a Go rewrite of the original TypeScript implementation. Special thanks to [b1ff/atlassian-dc-mcp](https://github.com/b1ff/atlassian-dc-mcp) for the original implementation that inspired this project.

## Features

- **Search & Retrieve**: Search for content using CQL (Confluence Query Language) and retrieve content by ID
- **Content Management**: Create new pages and blog posts, update existing content
- **Space Management**: List and search Confluence spaces
- **Secure Authentication**: Bearer token authentication support
- **High Performance**: Built with Go for speed and efficiency
- **Zero Dependencies**: Minimal external dependencies, uses standard library where possible

## Tools

The server provides the following MCP tools:

### `confluence_get_content`
Get Confluence content by ID from the Confluence Data Center edition instance.

**Arguments:**
- `contentId` (string, required): Confluence Data Center content ID
- `expand` (string, optional): Comma-separated list of properties to expand

### `confluence_search_content`
Search for content in Confluence Data Center edition instance using CQL.

**Arguments:**
- `cql` (string, required): Confluence Query Language (CQL) search string for Confluence Data Center
- `limit` (number, optional): Maximum number of results to return (default: 25)
- `start` (number, optional): The starting index of the results to return
- `expand` (string, optional): Comma-separated list of properties to expand

### `confluence_create_content`
Create new content in Confluence Data Center edition instance.

**Arguments:**
- `title` (string, required): The title of the new content
- `spaceKey` (string, required): The key of the space where content will be created
- `content` (string, required): The content of the page in Confluence storage format
- `type` (string, optional): The type of content (page or blogpost)
- `parentId` (string, optional): The ID of the parent content

### `confluence_update_content`
Update existing content in Confluence Data Center edition instance.

**Arguments:**
- `contentId` (string, required): The ID of the content to update
- `version` (number, optional): The new version number (defaults to current version + 1)
- `title` (string, optional): New title for the content
- `content` (string, optional): New content in storage format
- `versionComment` (string, optional): A comment for the new version

### `confluence_list_spaces`
List and search for spaces in Confluence Data Center edition instance.

**Arguments:**
- `searchText` (string, optional): Text to search for in space names or descriptions (returns all spaces if omitted)
- `limit` (number, optional): Maximum number of spaces to return
- `start` (number, optional): The starting index of the results to return
- `expand` (string, optional): Comma-separated list of properties to expand

## Usage Modes (MCP Configuration)

> If you are unsure which option to choose:
> - Use **Pre-built Binary** if you don’t use Go
> - Use **go install** if you are a Go developer

This MCP server can be used in **three supported ways**.
Choose **one** based on how you want to install and run it.

### Option 1: Using a Pre-Built Binary (Recommended for non-Go users)

#### Install

Download the appropriate binary from the
[Releases page](https://github.com/anudeepd/atlassian-confluence-dc-go-mcp/releases)
and place it somewhere on your system (e.g. `/usr/local/bin`).

```bash
chmod +x atlassian-confluence-dc-go-mcp
```

#### MCP Configuration

```json
{
  "mcpServers": {
    "confluence": {
      "command": "/usr/local/bin/atlassian-confluence-dc-go-mcp",
      "env": {
        "CONFLUENCE_API_TOKEN": "your-api-token",
        "CONFLUENCE_BASE_URL": "https://confluence.example.com"
      }
    }
  }
}
```



### Option 2: Using `go install` (Recommended for Go users)

#### Install

```bash
go install github.com/anudeepd/atlassian-confluence-dc-go-mcp@latest
```

Ensure `$GOBIN` (or `~/go/bin`) is in your `PATH`.

```bash
export PATH="$HOME/go/bin:$PATH"
```

#### MCP Configuration

Because the binary is on your `PATH`, you only need the command name:

```json
{
  "mcpServers": {
    "confluence": {
      "command": "atlassian-confluence-dc-go-mcp",
      "env": {
        "CONFLUENCE_API_TOKEN": "your-api-token",
        "CONFLUENCE_BASE_URL": "https://confluence.example.com"
      }
    }
  }
}
```



### Option 3: Running from Source (Development / Contribution)

#### Run directly

```bash
git clone https://github.com/anudeepd/atlassian-confluence-dc-go-mcp.git
cd atlassian-confluence-dc-go-mcp
go run .
```

#### MCP Configuration (not recommended for production)

```json
{
  "mcpServers": {
    "confluence-dev": {
      "command": "go",
      "args": ["run", "."],
      "cwd": "/path/to/atlassian-confluence-dc-go-mcp",
      "env": {
        "CONFLUENCE_API_TOKEN": "your-api-token",
        "CONFLUENCE_BASE_URL": "https://confluence.example.com"
      }
    }
  }
}
```



## Configuration

The server requires the following environment variables:

### Required Variables

- `CONFLUENCE_API_TOKEN`: Your Confluence API token (Bearer token)
- `CONFLUENCE_BASE_URL`: The base URL of your Confluence instance (e.g., `https://confluence.example.com`)

### Alternative URL Variables

You can also use one of these instead of `CONFLUENCE_BASE_URL`:
- `CONFLUENCE_API_BASE_PATH`: Full API path
- `CONFLUENCE_HOST`: Just the hostname (will be prefixed with `https://`)

The server will automatically append `/rest/api` to the base URL if not present.

### Example Configuration

```bash
export CONFLUENCE_API_TOKEN="your-api-token-here"
export CONFLUENCE_BASE_URL="https://confluence.example.com"
```

## Development

### Running Tests

```bash
# Run all tests
go test -v

# Run tests with coverage
go test -v -cover

# Generate coverage report
go test -coverprofile=coverage.out
go tool cover -html=coverage.out
```

### Building

```bash
# Build for current platform
go build .

# Build for multiple platforms
./build.sh
```

The `build.sh` script creates binaries for:
- Linux (amd64, arm64)
- macOS (amd64, arm64)
- Windows (amd64, arm64)

### Building with older Go versions

If you are using an older version of Go (e.g., 1.24) and cannot upgrade, you can modify the `go.mod` file:

1. Clone the repository:
   ```bash
   git clone https://github.com/anudeepd/atlassian-confluence-dc-go-mcp.git
   cd atlassian-confluence-dc-go-mcp
   ```

2. Edit the Go version in `go.mod`:
   ```bash
   go mod edit -go=1.24
   ```

3. Tidy the modules:
   ```bash
   go mod tidy
   ```

4. Build the project:
   ```bash
   go build .
   ```

## Project Structure

```
.
├── main.go           # Main server implementation
├── main_test.go      # Comprehensive test suite
├── go.mod            # Go module dependencies
├── go.sum            # Dependency checksums
├── build.sh          # Multi-platform build script
└── README.md         # This file
```

## API Reference

### Confluence REST API

This server uses the Confluence Data Center REST API v1. For more information about the API endpoints and CQL syntax, see:

- [Confluence REST API Documentation](https://developer.atlassian.com/server/confluence/rest/latest/)
- [Confluence Query Language (CQL)](https://developer.atlassian.com/server/confluence/advanced-searching-using-cql/)

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- Original TypeScript implementation: [b1ff/atlassian-dc-mcp](https://github.com/b1ff/atlassian-dc-mcp)
- MCP Go SDK: [mark3labs/mcp-go](https://github.com/mark3labs/mcp-go)
- Model Context Protocol: [Anthropic MCP](https://modelcontextprotocol.io/)

## Support

For issues, questions, or contributions, please open an issue on GitHub.

## Changelog

### v1.0.2
- Added documentation for building with older Go versions

### v1.0.1 [Deprecated]
- Fixed incorrect module path in `go.mod`
- **Note**: This version is deprecated due to configuration issues. Please use v1.0.2+.

### v1.0.0 (Initial Release) [Deprecated]
- Complete Go rewrite of the TypeScript implementation
- Support for all core Confluence operations
- Multi-platform build support
- MCP protocol compliance
- **Note**: This version is deprecated due to incorrect module configuration. Please use v1.0.2+.
