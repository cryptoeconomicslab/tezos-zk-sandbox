const fs = require('fs')
const v = fs.readFileSync('./verification.key')
const proof = require('./proof.json')
const vk = JSON.parse(v)
console.log('=====verifier=====')
console.log('alpha', join(vk.alpha))
console.log('beta', join(vk.beta))
console.log('gamma', join(vk.gamma))
console.log('delta', join(vk.delta))
const gamma_abc = join_gamma_abc(vk.gamma_abc)
console.log('gamma_abc', gamma_abc)
console.log(generateCode(
    gamma_abc[0],
    gamma_abc[1],
    gamma_abc[2],
    join(vk.delta),
    join(vk.gamma),
    join(vk.beta),
    join(vk.alpha)
))


console.log('===== proof  =====')
console.log('inputs', proof.inputs.map(i => i.substr(2)))
console.log('proofA', join(proof.proof.a).substr(2))
console.log('proofB', join(proof.proof.b).substr(2))
console.log('proofC', join(proof.proof.c).substr(2))


function join(a) {
    if(a[0].length > 5) {
        return a[0] + a[1].substr(2)
    }else {
        let o = ''
        a.forEach(a=>{
            o += a[1].substr(2) + a[0].substr(2)
        })
        return '0x' + o
    }
}
function join_gamma_abc(a) {
    let o = []
    a.forEach(a=>{
        o.push(a[0] + a[1].substr(2))
    })
    return o
}

function generateCode(vk_gamma_a, vk_gamma_b, vk_gamma_c, vk_delta, vk_gamma, vk_b, vk_a) {
    const code = `
function verify (
  var proof : groth16_proof
) : bool is block {
    const vk_gamma_c: bls12_381_g1 = ([%Michelson ({| 
      { DROP 1; PUSH @vk_gamma_c bls12_381_g1 ${vk_gamma_c}; }
    |} : unit -> bls12_381_g1)])(unit);
    const vk_gamma_b: bls12_381_g1 = ([%Michelson ({| 
      { DROP 1; PUSH @vk_gamma_b bls12_381_g1 ${vk_gamma_b}; }
    |} : unit -> bls12_381_g1)])(unit);
    const vk_gamma_a: bls12_381_g1 = ([%Michelson ({| 
      { DROP 1; PUSH @vk_gamma_a bls12_381_g1 ${vk_gamma_a}; }
    |} : unit -> bls12_381_g1)])(unit);
    const vk_delta: bls12_381_g2 = ([%Michelson ({| 
      { DROP 1; PUSH @vk_delta bls12_381_g2 ${vk_delta}; }
    |} : unit -> bls12_381_g2)])(unit);
    const vk_gamma: bls12_381_g2 = ([%Michelson ({| 
      { DROP 1; PUSH @vk_gamma bls12_381_g2 ${vk_gamma}; }
    |} : unit -> bls12_381_g2)])(unit);
    const vk_b: bls12_381_g2 = ([%Michelson ({| 
      { DROP 1; PUSH @vk_b bls12_381_g2 ${vk_b}; }
    |} : unit -> bls12_381_g2)])(unit);
    const vk_a: bls12_381_g1 = ([%Michelson ({| 
      { DROP 1; PUSH @vk_a bls12_381_g1 ${vk_a}; }
    |} : unit -> bls12_381_g1)])(unit);
    const vk_x = (vk_gamma_b * proof.0) + (vk_gamma_c * proof.1) + vk_gamma_a;
  } with pairing_check(list [(proof.2, proof.3); (neg_g1(vk_x), vk_gamma); (neg_g1(proof.4), vk_delta); (neg_g1(vk_a), vk_b)])
`
    return code
}