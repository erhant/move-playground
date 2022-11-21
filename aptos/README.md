# Aptos Move

To begin, we follow the tutorial at <https://aptos.dev/tutorials/first-move-module>. I have cloned the aptos-core repository in this directory.

1. First, do `aptos init` to initialize a local account. The newly created account will be default, and can be addressed as such. I have moved the resulting `config.yaml` to my home folder. My address turned out to be `360baeec5574c631eb1e661027b038679203bf5bd2999e3262a39e5ade26247b`.
2. Fund the account with `aptos account fund-with-faucet --account default`.
3. Go to `hello_blockchain` examples in the repo, and run `aptos move compile --named-addresses hello_blockchain=default`.
4. To test, run `aptos move test --named-addresses hello_blockchain=default`.
5. Publish the module via `aptos move publish --named-addresses hello_blockchain=default`.
6. You can interact with this module via CLI:

```sh
aptos move run \
  --function-id 'default::message::set_message' \
  --args 'string:hello, blockchain'
```

7. You can also see the effect in place (`json_pp` to pretty-print JSON response):

```sh
curl https://fullnode.devnet.aptoslabs.com/v1/accounts/360baeec5574c631eb1e661027b038679203bf5bd2999e3262a39e5ade26247b/resource/0x360baeec5574c631eb1e661027b038679203bf5bd2999e3262a39e5ade26247b::message::MessageHolder | json_pp
```
