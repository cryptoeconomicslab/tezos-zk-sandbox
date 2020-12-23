//type groth16_proof is (bls12_381_fr * bls12_381_fr * bls12_381_g1 * bls12_381_g2 * bls12_381_g1)
type bls_l is list(bls12_381_g1 * bls12_381_g2)
type bool_option is option(bool)

function pairing_check (const n : bls_l ) : bool_option is block {
  const f : (bls_l -> bool_option) = 
    [%Michelson ({| {PAIRING_CHECK; SOME} |} : bls_l -> bool_option)];
} with f (n)

(*
function verify (
  var proof : groth16_proof
) : bool is block {
    const f : (bls12_381_fr * bls12_381_fr * bls12_381_g1 * bls12_381_g2 * bls12_381_g1 -> bool) = 
      [%Michelson ({|
      {
    CAR; UNPPAIPPAIIR;

    # Push the verifying key. Result stack should be
    # input{x:y}
    # : proof{a:b:c}
    # : vk_{a:b:gamma:delta:gamma_{a:b:c}}
    DIP 5
        {
          PUSH @vk_gamma_c bls12_381_g1 0x063bd6e11e2fcaac1dd8cf68c6b1925a73c3c583e298ed37c41c3715115cf96358a42dbe85a0228cbfd8a6c8a8c54cd015b5ae2860d1cc47f84698d951f14d9448d03f04df2ca0ffe609a2067d6f1a892163a5e05e541279134cae52b1f23c6b;

          PUSH @vk_gamma_b bls12_381_g1 0x11f5b5db1da7f1f26217edcce2219d016003af6e5b4d1ca3ad0ff477e354717e658bf16beddc4f4fb76ce39d3327811e0601709dc7ed98c70463cfa1ba33f99851b52b51d1a042d7425bec6277287441c399973632445ce61e7fdd63a70f0f60;

          PUSH @vk_gamma_a bls12_381_g1 0x03535a322edd23c55b0ca025e54d450d95df49cc9ee873dcd500e8219f4771264bf159b3b105954d85c7bea8ffe1ea0400c767fe58989366c2837fba76f1b4f46644f19be8ad01e22d894b649e427e0d7e04677ee3919d982f0f96bb0a2f0c34;

          PUSH @vk_delta bls12_381_g2 0x10c6d5cdca84fc3c7f33061add256f48e0ab03a697832b338901898b650419eb6f334b28153fb73ad2ecd1cd2ac67053161e9f46cfbdaf7b1132a4654a55162850249650f9b873ac3113fa8c02ef1cd1df481480a4457f351d28f4da89d19fa405c3d77f686dc9a24d2681c9184bf2b091f62e6b24df651a3da8bd7067e14e7908fb02f8955b84af5081614cb5bc49b416d9edf914fc608c441b3f2eb8b6043736ddb9d4e4d62334a23b5625c14ef3e1a7e99258386310221b22d83a5eac035c;

          PUSH @vk_gamma bls12_381_g2 0x16dcbd28bff336c2649c7dd1d8391ac7ce6f7ef0124a9db7a4a485a124199eded7ce963c1c18aee1eca9994fe06f192c00e0fb653e1fc737d8d0e2f2f91424ca01f6e6e7c5c04f1c43db03a2900cf6b942aaed6ae77daea6200e094b78c38d770028d531a9d1a118ec23d5a39be7aa6dc28f778da1988856d2235c4a35e81fa48380f050d4baf7ebd7b5e058bf294da916afc34562f097c02a8fcbcf62a00de44f8ae6cfa7acb8ad254e3aeea8b2af12f65b7ee0f54855cb9bd432f3436f238f;

          PUSH @vk_b bls12_381_g2 0x0e9383f98df2c6e8b5b45f3876c3384596a0cdbc41349f83c4380bf463a050cdbd1d5057aa483a642e66486d1ed7362a1869e423c3877095e215c17282b11108601166f928043254bbce603bf86f4cec9f2e97e9660e98e4f5bce9b2b3bbacb40946b702ccfcc9a31e0bfc1543a2128edcc95807740a2310ae25eb47b935648e392c58dfae5b5e899d3b970d64e4e9e209741ea8bfedcfcc16b3fd890ff02c788ec0943feaaf01bbb354317acb85fcfd611133e4e563d53ca4e0f50e21cf2e7e;

          PUSH @vk_a bls12_381_g1 0x1040577c7d349e332735fc947c868c24a665f812f5dc1e7f60e65e2df80be2267a4b7341ed2287285fccd517acd96d910abba947235c364553aa6445f2f2b3a1a728225a330286ba5197ab87f0edc560d89fc7b623812f7d0d633341726e597a
        };

    # Compute vk_x as
    # (vk_gamma_b * input_x) + (vk_gamma_c * input_y) + vk_gamma_a
    # Result stack should be
    # vk_x
    # : input{x:y}
    # : proof{a:b:c}
    # : vk_{a:b:gamma:delta:gamma_{a:b:c}}
    DUP; DUP 12; MUL;
    DUP 3; DUP 14; MUL;
    ADD; DUP 11; ADD @vk_x;

    # Push the list for the pairing check. The list should be
    # [ (proof_a, proof_b);
    #   (-vk_x, vk_gamma);
    #   (-proof_c, vk_delta);
    #   (-vk_a, vk_b) ]
    NIL (pair bls12_381_g1 bls12_381_g2);
    DUP  9; DUP 9; NEG; PAIR; CONS;
    DUP 11; DUP 8; NEG; PAIR; CONS;
    DUP 10; DUP 3; NEG; PAIR; CONS;
    DUP  6; DUP 6;      PAIR; CONS;

    # Compute the pairing check and fail if it does not succeed
    PAIRING_CHECK; ASSERT;

    # Drop the stack
    DROP 13;

    # return no operations
    # UNIT; NIL operation; PAIR

  }
      |} : groth16_proof -> bool)];
  } with f (proof)

*)
