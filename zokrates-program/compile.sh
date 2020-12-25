#!bin/bash

# compile
~/.zokrates/bin/zokrates compile -i main.zok -c bls12_381
# perform the setup phase
~/.zokrates/bin/zokrates setup
# execute the program
~/.zokrates/bin/zokrates compute-witness -a 64 8
# generate a proof of computation
~/.zokrates/bin/zokrates generate-proof
~/.zokrates/bin/zokrates verify -c bls12_381

node parse-proof
