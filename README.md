# Learning Office — Day 1 (Foundry + SimpleStorage)

This project is a small Foundry lab. Goal: write a simple Solidity contract, deploy it to a local chain (Anvil), and understand the folders Foundry creates.

> Safety note: see `promise.md`. Never put a real-money private key in plain text.

---

## What is Foundry?

Foundry is a toolkit for Ethereum development:

| Tool | Simple meaning |
| --- | --- |
| **Forge** | Build, test, and run deploy scripts |
| **Cast** | Talk to a chain from the terminal (read data, convert hex, send txs) |
| **Anvil** | A fake local blockchain on your laptop (great for practice) |
| **Chisel** | A Solidity playground / REPL |

Docs: https://book.getfoundry.sh/

---

## Folder structure (what each part is for)

```text
learning_office/
├── src/                  # Your real smart contracts live here
│   └── SimpleStorage.sol
├── script/               # Deploy / setup scripts (not the app itself)
│   └── DeploySimpleStorage.s.sol
├── test/                 # Automated tests go here (empty for now)
├── lib/                  # Outside libraries you installed
│   └── forge-std/        # Foundry helper library (Script, Test, console, vm, ...)
├── broadcast/            # Logs of deploys you actually sent (or dry-ran)
│   └── README.md         # Explains run-latest.json in simple words
├── cache/                # Compiler cache (auto-generated, do not edit)
├── out/                  # Compiled contract JSON / ABI (auto-generated)
├── .github/workflows/    # CI: build/test on GitHub Actions
├── foundry.toml          # Foundry project settings (src, out, libs, ...)
├── foundry.lock          # Locks library versions (like a lockfile)
├── .gitignore            # Files git should not track (cache, out, local anvil logs, .env)
├── .gitmodules           # Points to git submodules (forge-std)
├── promise.md            # Personal rule: no real private keys in plain text
└── README.md             # This file
```

### Quick meanings

- **`src/`** — code that will live on-chain.
- **`script/`** — code that *deploys* or sets things up using Foundry.
- **`lib/`** — code you did not write; helpers you import.
- **`broadcast/`** — “receipt book” of what your script sent to a chain.
- **`cache/` + `out/`** — build leftovers. Safe to delete; `forge build` recreates them.
- **`foundry.toml`** — project config. Right now it mostly says: source is `src`, output is `out`, libs are in `lib`.

---

## The contract (simple idea)

`SimpleStorage` can:

1. **store** a favorite number
2. **retrieve** that number
3. **addPerson** (name + number), kept in a list and a name→number map

Comments inside `src/SimpleStorage.sol` explain each line in plain words.

---

## Local deploy flow (what you practiced)

1. Start a local chain:

```shell
anvil
```

Anvil prints fake accounts and private keys. Chain id is usually **31337**.

2. In another terminal, deploy with the script:

```shell
forge script script/DeploySimpleStorage.s.sol \
  --rpc-url http://127.0.0.1:8545 \
  --broadcast \
  --private-key <anvil_private_key>
```

Tips:

- Run **without** `--broadcast` first to simulate (dry-run).
- Use only Anvil’s practice keys on Anvil. Never real funds keys.

3. After a real broadcast, Foundry writes files under:

```text
broadcast/DeploySimpleStorage.s.sol/31337/run-latest.json
```

That JSON is your deploy diary. Full field-by-field guide: [`broadcast/README.md`](broadcast/README.md).

---

## Common commands

```shell
forge build          # compile contracts
forge test           # run tests
forge fmt            # format Solidity
forge script ...     # run a deploy script
cast --to-base 0x7a69 dec   # convert hex to decimal (0x7a69 -> 31337)
```

---

## Git note about `broadcast/`

Local Anvil deploy logs (`broadcast/.../31337/`) are ignored by `.gitignore` on purpose:

- they are machine-specific practice runs
- they can be large (bytecode inside)
- regenerating them is easy by deploying again

The **explanation** of those files is kept in `broadcast/README.md` so you can learn without committing every local run.
