# What is the `broadcast/` folder?

When you run a Foundry script with `--broadcast` (or even a dry-run), Foundry saves a report of what happened.

Think of it as a **deploy diary**.

---

## Folder path, piece by piece

Example path from this project:

```text
broadcast/DeploySimpleStorage.s.sol/31337/run-latest.json
```

| Part | Meaning |
| --- | --- |
| `broadcast/` | Root folder for all script run reports |
| `DeploySimpleStorage.s.sol/` | Which script was run |
| `31337/` | Which chain id (Anvil’s default local chain is 31337) |
| `run-latest.json` | Shortcut file pointing at the newest run |
| `run-<timestamp>.json` | A dated copy of that same run |
| `dry-run/` | Simulation only (no real on-chain send) |

So:

- **script name** → which deploy script
- **chain id** → which network
- **run-latest.json** → most recent result for that pair

---

## Your Day 1 real deploy (Anvil)

This is what your successful local deploy looked like (values from `run-latest.json`):

| Thing | Value | Simple meaning |
| --- | --- | --- |
| Chain | `31337` | Local Anvil |
| Transaction type | `CREATE` | You created a new contract (not calling an existing one) |
| Contract name | `SimpleStorage` | What got deployed |
| Contract address | `0x5FbDB2315678afecb367f032d93F642f64180aa3` | Where it lives on Anvil |
| Tx hash | `0x852306f6...ad90` | Unique id of that deploy transaction |
| From | `0xf39Fd6e5...2266` | Anvil account #0 (the deployer) |
| Status in receipt | `0x1` | Success (`0x0` would mean failed) |
| Block number | `0x1` (decimal 1) | First block after genesis in that Anvil run |
| Gas used | `0x89603` | How much gas the deploy burned |
| `to` | `null` | Normal for CREATE — there is no “to” address yet |

Also useful:

- `input` inside the transaction = the **bytecode** Foundry sent to create the contract (long hex blob). You do not need to read it by hand.
- `returns` = what your script’s `run()` gave back (here: the new `SimpleStorage` address).
- `chainId` in the tx shows as hex `0x7a69` → decimal **31337** (`cast --to-base 0x7a69 dec`).

---

## Anatomy of `run-latest.json` (simple map)

```text
run-latest.json
├── transactions[]     # list of txs the script sent
│   ├── hash           # tx id
│   ├── transactionType# CREATE / CALL / etc.
│   ├── contractName   # which contract
│   ├── contractAddress# where it was created (for CREATE)
│   └── transaction    # raw fields: from, gas, input, nonce, chainId, ...
├── receipts[]         # chain’s answer for each tx
│   ├── status         # 0x1 success, 0x0 fail
│   ├── blockNumber
│   ├── gasUsed
│   └── contractAddress
├── returns            # values returned by script run()
├── timestamp          # when Foundry wrote this file
└── chain              # chain id again (31337)
```

### `transactions` vs `receipts`

- **transactions** = what you *asked* the chain to do
- **receipts** = what the chain *confirmed* happened

If something fails, look at `receipts[].status`.

---

## Dry-run vs real broadcast

| Mode | Command idea | Folder |
| --- | --- | --- |
| Simulate only | `forge script ... --rpc-url ...` (no `--broadcast`) | `.../dry-run/` |
| Really send | add `--broadcast` and a key | `.../31337/` (for Anvil) |

Always simulate first when you are unsure.

---

## Why this file may not be in git

`.gitignore` skips local Anvil logs under `broadcast/*/31337/` so every practice deploy does not clutter git.

That is OK. This README is the learning copy of what those files mean. Redeploy anytime to regenerate `run-latest.json` on your machine.

---

## Mini practice checklist

1. Start `anvil`
2. Run the deploy script with `--broadcast`
3. Open `broadcast/DeploySimpleStorage.s.sol/31337/run-latest.json`
4. Find: `contractAddress`, `hash`, `status`, `chain`
5. Convert a hex with Cast, e.g. `cast --to-base 0x7a69 dec`
