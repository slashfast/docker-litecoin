# docker-bitcoin

[![License: MIT](https://img.shields.io/badge/License-MIT-black.svg)](https://opensource.org/licenses/MIT)


**Litecoind running in docker container with JSON-RPC enabled.**

[Bitcoin Core](https://litecoin.org/) is a peer-to-peer Internet currency that enables instant, near-zero cost payments to anyone in the world.

### Ports

#### JSON-RPC ports

* `9332` - mainnet.
* `18332` - regnet.
* `18443` - testnet.

#### P2P network ports

* `9333` - mainnet.
* `18333` - regnet.
* `18444` - testnet.

#### ZMQ ports

* `28332` - transactions.
* `28333` - blocks.

### Volumes

* `/data` - user data folder (on host it usually has a path ``/home/user/.litecoin``).


## Getting started



#### docker-compose

[docker-compose.yml](https://github.com/slashfast/docker-litecoin/blob/main/docker-compose.yml) to see minimal working setup. When running in production, you can use this as a guide.

```bash
git clone https://github.com/slashfast/docker-litecoin.git
cd docker-litecoin
docker compose up
```

#### getting rpcauth pair before using JSON-RPC


Generate an rpcauth pair [there](https://jlopp.github.io/bitcoin-core-rpc-auth-generator/) and paste it into the `docker-compose.yml` file as the `RPC_AUTH=`**user:hash** value, or paste `rpcauth=`**user:hash** into the [`litecoin.conf`](https://litecoin.info/index.php/Litecoin.conf) file which must be created in the `.litecoin` directory or `litecoin` on the host.

#### bind and allow ip before using JSON-RPC

Before use JSON-RPC, two parameters must be added to the [`litecoin.conf`](https://litecoin.info/index.php/Litecoin.conf)

```
rpcbind=<ip>
rpcallowip=<cidr>
```
After you can send requests:

```bash
curl --data-binary '{"jsonrpc": "1.0", "id": "test", "method": "getblockchaininfo", "params": []}'  http://litecoin:changeme@127.0.0.1:9332
```

:exclamation:**Warning**:exclamation:

Always link litecoind to containers or bind to localhost directly and not expose JSON-RPC ports for security reasons.

## License

See [LICENSE](https://github.com/slashfast/docker-litecoin/blob/main/LICENSE)
