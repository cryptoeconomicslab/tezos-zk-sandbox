type groth16_proof is (bls12_381_fr * bls12_381_fr * bls12_381_g1 * bls12_381_g2 * bls12_381_g1)
type bls_l is list(bls12_381_g1 * bls12_381_g2)

[@inline] function pairing_check (const n : bls_l ) : bool is block {
  const f : (bls_l -> bool) = 
    [%Michelson ({| {PAIRING_CHECK } |} : bls_l -> bool)];
} with f (n)

[@inline] function neg_g1 (const n : bls12_381_g1 ) : bls12_381_g1 is block {
  const f : (bls12_381_g1 -> bls12_381_g1) = 
    [%Michelson ({| {NEG } |} : bls12_381_g1 -> bls12_381_g1)];
} with f (n)

function verify (
  var proof : groth16_proof
) : bool is block {
    const vk_gamma_c: bls12_381_g1 = ([%Michelson ({| 
      { DROP 1; PUSH @vk_gamma_c bls12_381_g1 0x102bae3361383e2cef7d4aed348743201f6fd5fd25f4400d0888451a5556cd980f311510e6457e36fe8f3309472695390cf8968b8d779e53c04632588e402ae5884cc49ee3988159ede6a292fb3b9cd1071eec4bf3fffe51b7325184cadeab1d; }
    |} : unit -> bls12_381_g1)])(unit);
    const vk_gamma_b: bls12_381_g1 = ([%Michelson ({| 
      { DROP 1; PUSH @vk_gamma_b bls12_381_g1 0x09e4c38f362d9ecb0f9fb69119bc6095bd81d202e9eef827a5d500b303a63061378727ddba6e07281d0bd5d5b6d6ad5b0cbbe0382eb0131ab87ad5438ae374ba81525ae76f2eca21198dd5fb777209b5f15beb7cbff9000cdc9f2d4d4ccf2441; }
    |} : unit -> bls12_381_g1)])(unit);
    const vk_gamma_a: bls12_381_g1 = ([%Michelson ({| 
      { DROP 1; PUSH @vk_gamma_a bls12_381_g1 0x07f1710668da99b2b45e6392d5cd89db7a1d34eff180ead6c886d51bca063f8111a179640d5d2dfc209e0a92783fea070b5a9436d5c1be84f88a4127c9a02d307c5858df52ce76ae0b6fbb5c0d855438419e06a1c37f633b306e9da44eaf345e; }
    |} : unit -> bls12_381_g1)])(unit);
    const vk_delta: bls12_381_g2 = ([%Michelson ({| 
      { DROP 1; PUSH @vk_delta bls12_381_g2 0x1394d62459f5e72373706504085111cae6afb88121e8f5707a9ff82daf97d300b9a20fc52a6ac7149dac1626d1e4d0ae095f3f088b18f2ab4e44df666560e101f4c83da739ce074527deb3fde2fcb25e2a19fe2a0f7c4f546ca7f904575875b916ec4958b2b639d08f0c1bbd4af8e9e9289280e84b7308d790da4707ceefe61c78b661fbd76f8be9bd365ddd9a5f0b250d108a1585684a6ccbc94bdcb37c133579866e5dabb75c77178927d38f59a687015995d7c6d7fb536ee9f76f7e8081b2; }
    |} : unit -> bls12_381_g2)])(unit);
    const vk_gamma: bls12_381_g2 = ([%Michelson ({| 
      { DROP 1; PUSH @vk_gamma bls12_381_g2 0x00e3114ca5fa1c0af741154f059c94a4d2647481ba6071b97317587a937e21f048e5f85191ba2fbd0f3929121485f4e21889d7bcf405c1932c7cc66ea8d353b34844769b50da863b3f0f11079371d2e6b7c10031e270761f136e2f4e52f162241182c943f4672b1293f79699f6747d874e805f57e8211aae940d3e31693619054e2be22cb99b177cfc092db80c1f789616872517c4811f11bba424dc64fdb3e6f27455e736d369d04de53a3e51eb36d4be6686a07f8be5352c138aceea7c6357; }
    |} : unit -> bls12_381_g2)])(unit);
    const vk_b: bls12_381_g2 = ([%Michelson ({| 
      { DROP 1; PUSH @vk_b bls12_381_g2 0x16c58ffdfec9c8b7a4d3826e32a40f99e97bd237067971e474438078e8bca6ccbbee0870bef905972fe879030273dd671116f52efd0f128a0bd6be9042bec761332408e765609caae2b6f7805ab3287143a9bafeb94a7cdd6635fd1ee293c2cf037bef7f92e32e639cd632611077b121db404705da6a507b9b8d8adc08a38eba27b2d31b7b22e95a96e22e26660162d30dd3791f5adb64150c2e7082f23a214b7ef5aa97fd903e648637deb13c156061788756f74b75545c3453e10822012e6a; }
    |} : unit -> bls12_381_g2)])(unit);
    const vk_a: bls12_381_g1 = ([%Michelson ({| 
      { DROP 1; PUSH @vk_a bls12_381_g1 0x169d7633e3da4d413bf1918c412fc54c548ddf641a423f47b61ca883c0ba1b85f5ee13dd63d7c1661cc4fe2ca38f00e1065dbcfb2123f8258ae2b3cf92035485f621e55d433b1f251ad37c02ae2b3ec6a1658ae23bbc77649878ec0871a6d8f1; }
    |} : unit -> bls12_381_g1)])(unit);
    const vk_x = (vk_gamma_b * proof.0) + (vk_gamma_c * proof.1) + vk_gamma_a;
  } with pairing_check(list [(proof.2, proof.3); (neg_g1(vk_x), vk_gamma); (neg_g1(proof.4), vk_delta); (neg_g1(vk_a), vk_b)])
