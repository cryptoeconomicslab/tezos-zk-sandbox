# Tezos Sandbox

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
