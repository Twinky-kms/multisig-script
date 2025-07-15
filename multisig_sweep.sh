#!/bin/bash

# Usage: ./multisig_sweep.sh <MULTISIG_ADDRESS> <DEST_ADDRESS> [FEE]
# Example: ./multisig_sweep.sh DMultisigAddr DDestAddr 10

MULTISIG_ADDRESS="$1"
DEST_ADDRESS="$2"
FEE="${3:-10}"

if [ -z "$MULTISIG_ADDRESS" ] || [ -z "$DEST_ADDRESS" ]; then
  echo "Usage: $0 <MULTISIG_ADDRESS> <DEST_ADDRESS> [FEE]"
  exit 1
fi

if ! dingocoin-cli validateaddress "$MULTISIG_ADDRESS" | grep -q '"isvalid": true'; then
  echo "Error: Multisig address $MULTISIG_ADDRESS is not valid."
  exit 1
fi

if ! dingocoin-cli validateaddress "$DEST_ADDRESS" | grep -q '"isvalid": true'; then
  echo "Error: Destination address $DEST_ADDRESS is not valid."
  exit 1
fi

UTXOS=$(dingocoin-cli listunspent 0 9999999 "[\"$MULTISIG_ADDRESS\"]")

INPUTS=$(echo "$UTXOS" | jq '[.[] | {txid: .txid, vout: .vout}]')
TOTAL=$(echo "$UTXOS" | jq '[.[] | .amount] | add')

if [ -z "$TOTAL" ] || [ "$TOTAL" = "null" ]; then
  echo "No UTXOs found for $MULTISIG_ADDRESS"
  exit 1
fi

AMOUNT_TO_SEND=$(echo "$TOTAL - $FEE" | bc)

if (( $(echo "$AMOUNT_TO_SEND <= 0" | bc -l) )); then
  echo "Not enough funds to cover the fee."
  exit 1
fi

OUTPUTS="{\"$DEST_ADDRESS\":$AMOUNT_TO_SEND}"

RAW_TX=$(dingocoin-cli createrawtransaction "$INPUTS" "$OUTPUTS")

echo "Raw transaction created:"
echo "$RAW_TX"
