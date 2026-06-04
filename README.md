<p align="center">
  <img src="assets/hero.png" alt="Drafty — share a Claude artifact as a link anyone can comment on" width="1100" />
</p>

**Drafty** is point-and-comment review for the things Claude makes. Claude writes a plan, a spec, a page — you publish it to a link, then click any line and leave a note, Figma-style. Claude reads the comments and ships a new version on the same link, with history. No screenshots, no re-pasting "the third paragraph, the one about pricing."

**Easiest:** in a Claude Code session, just ask — *"install the drafty-im/drafty plugin."* Claude runs it for you (you approve the install once, or it's automatic on auto-approve), then run `/reload-plugins` to switch it on live — no restart.

Or do it by hand:

```
/plugin marketplace add drafty-im/drafty
/plugin install drafty@drafty-im
/reload-plugins
```

`/reload-plugins` activates everything live in the current session — the `drafty` skill and the `drafty` command on PATH, no restart. (Requires [bun](https://bun.sh).)

## How it works

Once installed, just tell Claude to **"drafty it"** after it writes something:

1. Claude runs `drafty push <file>` and hands you a `drafty.im/canvas/<slug>` link.
2. Open it. Hover any element, click, leave a comment. Share the link — anyone comments as a guest, no sign-up, live cursors.
3. Tell Claude "address the canvas" (or set it live) — it reads each thread, edits the source, and pushes a new version on the same link. Old versions are kept.

You talk; Claude runs the commands. You never touch the CLI yourself.

## What's in the box

- **The `drafty` skill** — teaches Claude the whole loop: publish, read comments, reply on the canvas, mark threads done, push revisions, roll back. Claude loads it on its own when you say "drafty it" / "share this for feedback" / "what did they comment".
- **The `drafty` CLI** — a thin HTTP client (no login, no keys — it authenticates as a persistent guest stored in `~/.drafty`). `push`, `watch`, `inbox`, `reply`, `resolve`, `mode`, `claim`, and the rest.

## Modes

A canvas has one **mode**, and Claude sets it from how you talk:

| Mode | Viewers comment | Claude acts on comments |
|---|---|---|
| `readonly` | no | — |
| `feedback` *(default)* | yes | no — parked until you say go |
| `live` | yes | yes — works them as they arrive |

"Go live" arms a realtime doorbell so Claude reacts the moment you comment; "park it" stops it.

## Privacy & telemetry

The CLI authenticates as an anonymous guest — no account, no email. It sends basic usage events (e.g. `canvas.published`) to drafty.im so I can see what's used; set `DRAFTY_NO_ANALYTICS=1` to turn that off. It only ever talks to `drafty.im` (override with `DRAFTY_BASE_URL`).

## Links

- The product: **[drafty.im](https://drafty.im)**
- Agent quickstart (no install, demo only): [drafty.im/get](https://drafty.im/get)

MIT licensed.
