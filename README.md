# Tezos Sandbox

### Requirements

* [LIGO](https://ligolang.org/docs/next/intro/installation)
* Docker


1. start texos node

run tezos node with another terminal.

```
docker run -it --rm -p 8732:8732 registry.gitlab.com/tezos/flextesa:master-run edobox start --base-port=8732
```

2. build and test smart contracts

```
npm run compile
npm test
```

3. if you want to modify zokrates program, check ./zokrates-program/main.zok and run compile.sh.

## Roadmap

- [x] connecting to tezos node(edo protocol)
- [x] compile LIGO code using new op-code
- [x] pass test with valid proof
