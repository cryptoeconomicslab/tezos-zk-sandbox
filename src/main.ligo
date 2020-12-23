#include "./verify.ligo"

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
//type verifyGroth16Params is groth16_proof

(* Valid entry points *)
type entryAction is
//  | VerifyGroth16 of verifyGroth16Params
  | PairingCheck of pairingCheckParams

(*
function verifyGroth16 (
  var proof : groth16_proof;
  var s: storage
) : return is block {
  s.result := verify(proof);
} with (noOperations, s)
*)

function pairingCheck (
  var proof : bls_l;
  var s: storage
) : return is block {
  case pairing_check(proof) of
   | Some(v) -> s.result := v
   | None -> skip
  end
} with (noOperations, s)

(* Main entrypoint *)
function main (const action : entryAction; var s : storage) : return is
  block {
    skip
  } with case action of
//    | VerifyGroth16(params) -> verifyGroth16(params, s)
    | PairingCheck(params) -> pairingCheck(params, s)
  end;
