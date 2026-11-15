# Mubu MCP (recommended, no migration)

Mubu (幕布) officially supports **MCP (Model Context Protocol)**, so AI clients can search and read your documents directly. This is the recommended way to use Mubu as memory: no export, no migration.

Official help pages:

- Overview: <https://mubu.com/help/124>
- OAuth (automatic authorization): <https://mubu.com/help/125>
- Personal Token: <https://mubu.com/help/126>

## Requirements

- A **Mubu Super membership** (超级会员) — MCP is a Super-member feature.
- A client that supports MCP connections (Claude, ChatGPT, Cursor, and others; see the help pages for the current list).

## What the MCP server exposes

- Search documents and folders by keyword
- Read a document's full content and its folder
- Browse a folder's documents / subfolders
- Create documents and folders
- Move documents / folders
- Get basic account info

The exact tool names differ between clients — ask the assistant to list its Mubu tools.

## Connect

### Option 1: OAuth (recommended)

Clients that can open a browser authorization page (Claude, ChatGPT, Cursor, …):

1. Open the client's **MCP / Connectors** settings.
2. Add a new connector / remote MCP server for Mubu.
3. Complete the Mubu login/authorization flow.
4. The Mubu tools become available in the conversation.

### Option 2: Personal Token

For clients that cannot open the authorization page:

1. Create a personal token in Mubu **Settings → MCP connections**.
2. Paste it into the client's MCP configuration (client-side secret store).
3. Never paste the token into a chat message.

## Privacy notes (from Mubu's help page)

- Encrypted documents are **not readable** through MCP and do not appear in document lists.
- The AI does **not** read your Mubu in the background; it only accesses documents when the conversation explicitly asks it to.
- You can disconnect authorized applications or revoke the token at any time in **Settings → MCP connections**.
- This skill never handles your token; it lives in the client's MCP configuration.

## Use it as memory

Once connected, the skill's Mode A applies: search documents by keywords, read the top matches, cite the document title and folder, and integrate the memory into the answer. Read-only by default — the skill creates or moves documents only when you explicitly ask.
