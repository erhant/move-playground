# Aptos Move

I have followed the tutorial at <https://aptos.dev/tutorials/first-move-module>.

```sh
### 1: Initialize a local account
# you can move config.yaml to home
aptos init

### 2: Fund the account
aptos account fund-with-faucet --account default

### 3: Clone repo & go to example
# i have cloned it but it is gitignored for this repo
git clone https://github.com/aptos-labs/aptos-core
cd ./aptos-core/aptos-move/move-examples/hello_blockchain

### 4: Compile
aptos move compile --named-addresses hello_blockchain=default

### 5: Test
aptos move test --named-addresses hello_blockchain=default

### 6: Publish
aptos move publish --named-addresses hello_blockchain=default

### 7: Make transactions
aptos move run \
  --function-id 'default::message::set_message' \
  --args 'string:hello, blockchain'

### 8: Read global storage (json_pp for pretty printing)
curl https://fullnode.devnet.aptoslabs.com/v1/accounts/360baeec5574c631eb1e661027b038679203bf5bd2999e3262a39e5ade26247b/resource/0x360baeec5574c631eb1e661027b038679203bf5bd2999e3262a39e5ade26247b::message::MessageHolder | json_pp
```

Note that once you have the repository, you can write Move in any directory you would like, as long as you give the correct path to dependencies.
