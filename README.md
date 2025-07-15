# multisig-script

Multisig balance sweeper for Dingocoin.

## Note
This can be used on other coins, just change the `dingocoin-cli` to the appropriate command.

## Description
This script helps you sweep (move) all funds from a Dingocoin multisig address to a destination address, subtracting a specified fee. It creates a raw transaction that you can then sign and broadcast.

## Dependencies
- [Dingocoin Core](https://github.com/dingocoin/dingocoin) (`dingocoin-cli` must be in your PATH)
- [jq](https://stedolan.github.io/jq/) (for JSON parsing)
- [bc](https://www.gnu.org/software/bc/) (for arithmetic)

Make sure your Dingocoin Core node is fully synced and `dingocoin-cli` is configured to connect to it.

## Usage

```sh
./multisig_sweep.sh <MULTISIG_ADDRESS> <DEST_ADDRESS> [FEE]
```

- `<MULTISIG_ADDRESS>`: The Dingocoin multisig address to sweep funds from.
- `<DEST_ADDRESS>`: The Dingocoin address to receive the swept funds.
- `[FEE]`: (Optional) Transaction fee in DINGO. Default is 10.

### Example

```sh
./multisig_sweep.sh DMultisigAddr DDestAddr 10
```

This will create a raw transaction moving all funds (minus a 10 DINGO fee) from `DMultisigAddr` to `DDestAddr`.

### Output
The script will output the raw transaction hex. You must sign this transaction with the required keys and then broadcast it using `dingocoin-cli`.

## Notes
- The script does not sign or broadcast the transaction. You must collect signatures and send the transaction yourself.
- Ensure you have the necessary permissions and private keys to sign the transaction.
