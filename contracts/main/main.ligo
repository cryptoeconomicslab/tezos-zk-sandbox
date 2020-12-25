#include "../partials/verify.ligo"

(* contract storage *)
type storage is record[
  result: bool;
]

(* define return for readability *)
type return is list (operation) * storage

(* define noop for readability *)
const noOperations : list (operation) = nil;

(* Inputs *)
type pairingCheckParams is bls_l

type proof3 is michelson_pair(bls12_381_fr, "", bls12_381_fr, "")
type proof2 is michelson_pair(proof3, "", bls12_381_g1, "")
type proof1 is michelson_pair(proof2, "", bls12_381_g2, "")
type proof0 is michelson_pair(proof1, "", bls12_381_g1, "")
type verifyGroth16Params is proof0

(* Valid entry points *)
type entryAction is
  | VerifyGroth16 of verifyGroth16Params
  | PairingCheck of pairingCheckParams

function verifyGroth16 (
  var proof : groth16_proof;
  var s: storage
) : return is block {
  if verify(proof) then s.result := True else failwith("none?");
} with (noOperations, s)

function pairingCheck (
  var proof : bls_l;
  var s: storage
) : return is block {
  if pairing_check(proof) then s.result := True else failwith("none?");
} with (noOperations, s)

(* Main entrypoint *)
function main (const action : entryAction; var s : storage) : return is
  block {
    skip
  } with case action of
    | VerifyGroth16(params) -> verifyGroth16((params.0.0.0.0, params.0.0.0.1, params.0.0.1, params.0.1, params.1), s)
    | PairingCheck(params) -> pairingCheck(params, s)
  end;
