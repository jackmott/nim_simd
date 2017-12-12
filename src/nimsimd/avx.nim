#
#
#          Nimrod's x86 avx intrinsics
#        (c) Copyright 2014 Ben Segovia
#
#    See the file copying.txt, included in this
#    distribution, for details about the copyright.
#
#

const someGcc = defined(gcc) or defined(llvm_gcc) or defined(clang)

when someGcc:
  {.passC: "-msse3 -mssse3 -msse4 -mavx".}
  {.passL: "-msse3 -mssse3 -msse4 -mavx".}

type m128* {.importc: "__m128", header: "xmmintrin.h".} = object
type m128d* {.importc: "__m128d", header: "emmintrin.h".} = object
type m128i* {.importc: "__m128i", header: "emmintrin.h".} = object
type m256* {.importc: "__m256", header: "immintrin.h".} = object
type m256d* {.importc: "__m256d", header: "immintrin.h".} = object
type m256i* {.importc: "__m256i", header: "immintrin.h".} = object

type mf32* = m256 

proc add_pd*(a: m256d, b: m256d): m256d
  {.importc: "_mm256_add_pd", header: "immintrin.h".}
  ## Exposes _mm256_add_pd intrinsics

proc add_ps*(a: m256, b: m256): m256
  {.importc: "_mm256_add_ps", header: "immintrin.h".}
  ## Exposes _mm256_add_ps intrinsics

proc sub_pd*(a: m256d, b: m256d): m256d
  {.importc: "_mm256_sub_pd", header: "immintrin.h".}
  ## Exposes _mm256_sub_pd intrinsics

proc sub_ps*(a: m256, b: m256): m256
  {.importc: "_mm256_sub_ps", header: "immintrin.h".}
  ## Exposes _mm256_sub_ps intrinsics

proc addsub_pd*(a: m256d, b: m256d): m256d
  {.importc: "_mm256_addsub_pd", header: "immintrin.h".}
  ## Exposes _mm256_addsub_pd intrinsics

proc addsub_ps*(a: m256, b: m256): m256
  {.importc: "_mm256_addsub_ps", header: "immintrin.h".}
  ## Exposes _mm256_addsub_ps intrinsics

proc div_pd*(a: m256d, b: m256d): m256d
  {.importc: "_mm256_div_pd", header: "immintrin.h".}
  ## Exposes _mm256_div_pd intrinsics

proc div_ps*(a: m256, b: m256): m256
  {.importc: "_mm256_div_ps", header: "immintrin.h".}
  ## Exposes _mm256_div_ps intrinsics

proc max_pd*(a: m256d, b: m256d): m256d
  {.importc: "_mm256_max_pd", header: "immintrin.h".}
  ## Exposes _mm256_max_pd intrinsics

proc max_ps*(a: m256, b: m256): m256
  {.importc: "_mm256_max_ps", header: "immintrin.h".}
  ## Exposes _mm256_max_ps intrinsics

proc min_pd*(a: m256d, b: m256d): m256d
  {.importc: "_mm256_min_pd", header: "immintrin.h".}
  ## Exposes _mm256_min_pd intrinsics

proc min_ps*(a: m256, b: m256): m256
  {.importc: "_mm256_min_ps", header: "immintrin.h".}
  ## Exposes _mm256_min_ps intrinsics

proc mul_pd*(a: m256d, b: m256d): m256d
  {.importc: "_mm256_mul_pd", header: "immintrin.h".}
  ## Exposes _mm256_mul_pd intrinsics

proc mul_ps*(a: m256, b: m256): m256
  {.importc: "_mm256_mul_ps", header: "immintrin.h".}
  ## Exposes _mm256_mul_ps intrinsics

proc sqrt_pd*(a: m256d): m256d
  {.importc: "_mm256_sqrt_pd", header: "immintrin.h".}
  ## Exposes _mm256_sqrt_pd intrinsics

proc sqrt_ps*(a: m256): m256
  {.importc: "_mm256_sqrt_ps", header: "immintrin.h".}
  ## Exposes _mm256_sqrt_ps intrinsics

proc rsqrt_ps*(a: m256): m256
  {.importc: "_mm256_rsqrt_ps", header: "immintrin.h".}
  ## Exposes _mm256_rsqrt_ps intrinsics

proc rcp_ps*(a: m256): m256
  {.importc: "_mm256_rcp_ps", header: "immintrin.h".}
  ## Exposes _mm256_rcp_ps intrinsics

proc and_pd*(a: m256d, b: m256d): m256d
  {.importc: "_mm256_and_pd", header: "immintrin.h".}
  ## Exposes _mm256_and_pd intrinsics

proc and_ps*(a: m256, b: m256): m256
  {.importc: "_mm256_and_ps", header: "immintrin.h".}
  ## Exposes _mm256_and_ps intrinsics

proc andnot_pd*(a: m256d, b: m256d): m256d
  {.importc: "_mm256_andnot_pd", header: "immintrin.h".}
  ## Exposes _mm256_andnot_pd intrinsics

proc andnot_ps*(a: m256, b: m256): m256
  {.importc: "_mm256_andnot_ps", header: "immintrin.h".}
  ## Exposes _mm256_andnot_ps intrinsics

proc or_pd*(a: m256d, b: m256d): m256d
  {.importc: "_mm256_or_pd", header: "immintrin.h".}
  ## Exposes _mm256_or_pd intrinsics

proc or_ps*(a: m256, b: m256): m256
  {.importc: "_mm256_or_ps", header: "immintrin.h".}
  ## Exposes _mm256_or_ps intrinsics

proc xor_pd*(a: m256d, b: m256d): m256d
  {.importc: "_mm256_xor_pd", header: "immintrin.h".}
  ## Exposes _mm256_xor_pd intrinsics

proc xor_ps*(a: m256, b: m256): m256
  {.importc: "_mm256_xor_ps", header: "immintrin.h".}
  ## Exposes _mm256_xor_ps intrinsics

proc hadd_pd*(a: m256d, b: m256d): m256d
  {.importc: "_mm256_hadd_pd", header: "immintrin.h".}
  ## Exposes _mm256_hadd_pd intrinsics

proc hadd_ps*(a: m256, b: m256): m256
  {.importc: "_mm256_hadd_ps", header: "immintrin.h".}
  ## Exposes _mm256_hadd_ps intrinsics

proc hsub_pd*(a: m256d, b: m256d): m256d
  {.importc: "_mm256_hsub_pd", header: "immintrin.h".}
  ## Exposes _mm256_hsub_pd intrinsics

proc hsub_ps*(a: m256, b: m256): m256
  {.importc: "_mm256_hsub_ps", header: "immintrin.h".}
  ## Exposes _mm256_hsub_ps intrinsics

proc permutevar_pd*(a: m128d, c: m128i): m128d
  {.importc: "_mm_permutevar_pd", header: "immintrin.h".}
  ## Exposes _mm_permutevar_pd intrinsics

proc permutevar_pd*(a: m256d, c: m256i): m256d
  {.importc: "_mm256_permutevar_pd", header: "immintrin.h".}
  ## Exposes _mm256_permutevar_pd intrinsics

proc permutevar_ps*(a: m128, c: m128i): m128
  {.importc: "_mm_permutevar_ps", header: "immintrin.h".}
  ## Exposes _mm_permutevar_ps intrinsics

proc permutevar_ps*(a: m256, c: m256i): m256
  {.importc: "_mm256_permutevar_ps", header: "immintrin.h".}
  ## Exposes _mm256_permutevar_ps intrinsics

proc blendv_pd*(a: m256d, b: m256d, c: m256d): m256d
  {.importc: "_mm256_blendv_pd", header: "immintrin.h".}
  ## Exposes _mm256_blendv_pd intrinsics

proc blendv_ps*(a: m256, b: m256, c: m256): m256
  {.importc: "_mm256_blendv_ps", header: "immintrin.h".}
  ## Exposes _mm256_blendv_ps intrinsics

when not defined(vcc):
  proc extract_epi32*(a: m256i, imm: int32): int32
    {.importc: "_mm256_extract_epi32", header: "immintrin.h".}
    ## Exposes _mm256_extract_epi32 intrinsics

  proc extract_epi16*(a: m256i, imm: int32): int32
    {.importc: "_mm256_extract_epi16", header: "immintrin.h".}
    ## Exposes _mm256_extract_epi16 intrinsics

  proc extract_epi8*(a: m256i, imm: int32): int32
    {.importc: "_mm256_extract_epi8", header: "immintrin.h".}
    ## Exposes _mm256_extract_epi8 intrinsics

  proc insert_epi32*(a: m256i, b: int32, imm: int32): m256i
    {.importc: "_mm256_insert_epi32", header: "immintrin.h".}
    ## Exposes _mm256_insert_epi32 intrinsics

  proc insert_epi16*(a: m256i, b: int32, imm: int32): m256i
    {.importc: "_mm256_insert_epi16", header: "immintrin.h".}
    ## Exposes _mm256_insert_epi16 intrinsics

  proc insert_epi8*(a: m256i, b: int32, imm: int32): m256i
    {.importc: "_mm256_insert_epi8", header: "immintrin.h".}
    ## Exposes _mm256_insert_epi8 intrinsic

when defined(x86_64) and defined(vcc):
  proc insert_epi64*(a: m256i, b: int32, imm: int32): m256i
    {.importc: "_mm256_insert_epi64", header: "immintrin.h".}
    ## Exposes _mm256_insert_epi64 intrinsics

proc cvtepi32_pd*(a: m128i): m256d
  {.importc: "_mm256_cvtepi32_pd", header: "immintrin.h".}
  ## Exposes _mm256_cvtepi32_pd intrinsics

proc cvtepi32_ps*(a: m256i): m256
  {.importc: "_mm256_cvtepi32_ps", header: "immintrin.h".}
  ## Exposes _mm256_cvtepi32_ps intrinsics

proc cvtpd_ps*(a: m256d): m128
  {.importc: "_mm256_cvtpd_ps", header: "immintrin.h".}
  ## Exposes _mm256_cvtpd_ps intrinsics

proc cvtps_epi32*(a: m256): m256i
  {.importc: "_mm256_cvtps_epi32", header: "immintrin.h".}
  ## Exposes _mm256_cvtps_epi32 intrinsics

proc cvtps_pd*(a: m128): m256d
  {.importc: "_mm256_cvtps_pd", header: "immintrin.h".}
  ## Exposes _mm256_cvtps_pd intrinsics

proc cvttpd_epi32*(a: m256d): m128i
  {.importc: "_mm256_cvttpd_epi32", header: "immintrin.h".}
  ## Exposes _mm256_cvttpd_epi32 intrinsics

proc cvtpd_epi32*(a: m256d): m128i
  {.importc: "_mm256_cvtpd_epi32", header: "immintrin.h".}
  ## Exposes _mm256_cvtpd_epi32 intrinsics

proc cvttps_epi32*(a: m256): m256i
  {.importc: "_mm256_cvttps_epi32", header: "immintrin.h".}
  ## Exposes _mm256_cvttps_epi32 intrinsics

proc movehdup_ps*(a: m256): m256
  {.importc: "_mm256_movehdup_ps", header: "immintrin.h".}
  ## Exposes _mm256_movehdup_ps intrinsics

proc moveldup_ps*(a: m256): m256
  {.importc: "_mm256_moveldup_ps", header: "immintrin.h".}
  ## Exposes _mm256_moveldup_ps intrinsics

proc movedup_pd*(a: m256d): m256d
  {.importc: "_mm256_movedup_pd", header: "immintrin.h".}
  ## Exposes _mm256_movedup_pd intrinsics

proc unpackhi_pd*(a: m256d, b: m256d): m256d
  {.importc: "_mm256_unpackhi_pd", header: "immintrin.h".}
  ## Exposes _mm256_unpackhi_pd intrinsics

proc unpacklo_pd*(a: m256d, b: m256d): m256d
  {.importc: "_mm256_unpacklo_pd", header: "immintrin.h".}
  ## Exposes _mm256_unpacklo_pd intrinsics

proc unpackhi_ps*(a: m256, b: m256): m256
  {.importc: "_mm256_unpackhi_ps", header: "immintrin.h".}
  ## Exposes _mm256_unpackhi_ps intrinsics

proc unpacklo_ps*(a: m256, b: m256): m256
  {.importc: "_mm256_unpacklo_ps", header: "immintrin.h".}
  ## Exposes _mm256_unpacklo_ps intrinsics

proc testz_pd*(a: m128d, b: m128d): int32
  {.importc: "_mm_testz_pd", header: "immintrin.h".}
  ## Exposes _mm_testz_pd intrinsics

proc testc_pd*(a: m128d, b: m128d): int32
  {.importc: "_mm_testc_pd", header: "immintrin.h".}
  ## Exposes _mm_testc_pd intrinsics

proc testnzc_pd*(a: m128d, b: m128d): int32
  {.importc: "_mm_testnzc_pd", header: "immintrin.h".}
  ## Exposes _mm_testnzc_pd intrinsics

proc testz_ps*(a: m128, b: m128): int32
  {.importc: "_mm_testz_ps", header: "immintrin.h".}
  ## Exposes _mm_testz_ps intrinsics

proc testc_ps*(a: m128, b: m128): int32
  {.importc: "_mm_testc_ps", header: "immintrin.h".}
  ## Exposes _mm_testc_ps intrinsics

proc testnzc_ps*(a: m128, b: m128): int32
  {.importc: "_mm_testnzc_ps", header: "immintrin.h".}
  ## Exposes _mm_testnzc_ps intrinsics

proc testz_pd*(a: m256d, b: m256d): int32
  {.importc: "_mm256_testz_pd", header: "immintrin.h".}
  ## Exposes _mm256_testz_pd intrinsics

proc testc_pd*(a: m256d, b: m256d): int32
  {.importc: "_mm256_testc_pd", header: "immintrin.h".}
  ## Exposes _mm256_testc_pd intrinsics

proc testnzc_pd*(a: m256d, b: m256d): int32
  {.importc: "_mm256_testnzc_pd", header: "immintrin.h".}
  ## Exposes _mm256_testnzc_pd intrinsics

proc testz_ps*(a: m256, b: m256): int32
  {.importc: "_mm256_testz_ps", header: "immintrin.h".}
  ## Exposes _mm256_testz_ps intrinsics

proc testc_ps*(a: m256, b: m256): int32
  {.importc: "_mm256_testc_ps", header: "immintrin.h".}
  ## Exposes _mm256_testc_ps intrinsics

proc testnzc_ps*(a: m256, b: m256): int32
  {.importc: "_mm256_testnzc_ps", header: "immintrin.h".}
  ## Exposes _mm256_testnzc_ps intrinsics

proc testz_si256*(a: m256i, b: m256i): int32
  {.importc: "_mm256_testz_si256", header: "immintrin.h".}
  ## Exposes _mm256_testz_si256 intrinsics

proc testc_si256*(a: m256i, b: m256i): int32
  {.importc: "_mm256_testc_si256", header: "immintrin.h".}
  ## Exposes _mm256_testc_si256 intrinsics

proc testnzc_si256*(a: m256i, b: m256i): int32
  {.importc: "_mm256_testnzc_si256", header: "immintrin.h".}
  ## Exposes _mm256_testnzc_si256 intrinsics

proc movemask_pd*(a: m256d): int32
  {.importc: "_mm256_movemask_pd", header: "immintrin.h".}
  ## Exposes _mm256_movemask_pd intrinsics

proc movemask_ps*(a: m256): int32
  {.importc: "_mm256_movemask_ps", header: "immintrin.h".}
  ## Exposes _mm256_movemask_ps intrinsics

proc zeroall*(): void
  {.importc: "_mm256_zeroall", header: "immintrin.h".}
  ## Exposes _mm256_zeroall intrinsics

proc zeroupper*(): void
  {.importc: "_mm256_zeroupper", header: "immintrin.h".}
  ## Exposes _mm256_zeroupper intrinsics

proc broadcast_ss*(a: ptr float32): m128
  {.importc: "_mm_broadcast_ss", header: "immintrin.h".}
  ## Exposes _mm_broadcast_ss intrinsics

proc broadcast_sd_256*(a: ptr float64): m256d
  {.importc: "_mm256_broadcast_sd", header: "immintrin.h".}
  ## Exposes _mm256_broadcast_sd intrinsics

proc broadcast_ss_256*(a: ptr float32): m256
  {.importc: "_mm256_broadcast_ss", header: "immintrin.h".}
  ## Exposes _mm256_broadcast_ss intrinsics

proc broadcast_pd*(a: ptr m128d): m256d
  {.importc: "_mm256_broadcast_pd", header: "immintrin.h".}
  ## Exposes _mm256_broadcast_pd intrinsics

proc broadcast_ps*(a: ptr m128): m256
  {.importc: "_mm256_broadcast_ps", header: "immintrin.h".}
  ## Exposes _mm256_broadcast_ps intrinsics

proc load_pd_256*(p: ptr float64): m256d
  {.importc: "_mm256_load_pd", header: "immintrin.h".}
  ## Exposes _mm256_load_pd intrinsics

proc load_ps*(p: ptr float32): m256
  {.importc: "_mm256_load_ps", header: "immintrin.h".}
  ## Exposes _mm256_load_ps intrinsics

proc loadu_pd_256*(p: ptr float64): m256d
  {.importc: "_mm256_loadu_pd", header: "immintrin.h".}
  ## Exposes _mm256_loadu_pd intrinsics

proc loadu_ps*(p: ptr float32): m256
  {.importc: "_mm256_loadu_ps", header: "immintrin.h".}
  ## Exposes _mm256_loadu_ps intrinsics

proc load_si256*(p: ptr m256i): m256i
  {.importc: "_mm256_load_si256", header: "immintrin.h".}
  ## Exposes _mm256_load_si256 intrinsics

proc loadu_si256*(p: ptr m256i): m256i
  {.importc: "_mm256_loadu_si256", header: "immintrin.h".}
  ## Exposes _mm256_loadu_si256 intrinsics

proc lddqu_si256*(p: ptr m256i): m256i
  {.importc: "_mm256_lddqu_si256", header: "immintrin.h".}
  ## Exposes _mm256_lddqu_si256 intrinsics

proc store_pd*(p: ptr float64, a: m256d): void
  {.importc: "_mm256_store_pd", header: "immintrin.h".}
  ## Exposes _mm256_store_pd intrinsics

proc store_ps*(p: ptr float32, a: m256): void
  {.importc: "_mm256_store_ps", header: "immintrin.h".}
  ## Exposes _mm256_store_ps intrinsics

proc storeu_pd*(p: ptr float64, a: m256d): void
  {.importc: "_mm256_storeu_pd", header: "immintrin.h".}
  ## Exposes _mm256_storeu_pd intrinsics

proc storeu_ps*(p: ptr float32, a: m256): void
  {.importc: "_mm256_storeu_ps", header: "immintrin.h".}
  ## Exposes _mm256_storeu_ps intrinsics

proc store_si256*(p: ptr m256i, a: m256i): void
  {.importc: "_mm256_store_si256", header: "immintrin.h".}
  ## Exposes _mm256_store_si256 intrinsics

proc storeu_si256*(p: ptr m256i, a: m256i): void
  {.importc: "_mm256_storeu_si256", header: "immintrin.h".}
  ## Exposes _mm256_storeu_si256 intrinsics

proc maskload_pd*(p: ptr float64, m: m128i): m128d
  {.importc: "_mm_maskload_pd", header: "immintrin.h".}
  ## Exposes _mm_maskload_pd intrinsics

proc maskload_pd*(p: ptr float64, m: m256i): m256d
  {.importc: "_mm256_maskload_pd", header: "immintrin.h".}
  ## Exposes _mm256_maskload_pd intrinsics

proc maskload_ps*(p: ptr float32, m: m128i): m128
  {.importc: "_mm_maskload_ps", header: "immintrin.h".}
  ## Exposes _mm_maskload_ps intrinsics

proc maskload_ps*(p: ptr float32, m: m256i): m256
  {.importc: "_mm256_maskload_ps", header: "immintrin.h".}
  ## Exposes _mm256_maskload_ps intrinsics

proc maskstore_ps*(p: ptr float32, m: m256i, a: m256): void
  {.importc: "_mm256_maskstore_ps", header: "immintrin.h".}
  ## Exposes _mm256_maskstore_ps intrinsics

proc maskstore_pd*(p: ptr float64, m: m128i, a: m128d): void
  {.importc: "_mm_maskstore_pd", header: "immintrin.h".}
  ## Exposes _mm_maskstore_pd intrinsics

proc maskstore_pd*(p: ptr float64, m: m256i, a: m256d): void
  {.importc: "_mm256_maskstore_pd", header: "immintrin.h".}
  ## Exposes _mm256_maskstore_pd intrinsics

proc maskstore_ps*(p: ptr float32, m: m128i, a: m128): void
  {.importc: "_mm_maskstore_ps", header: "immintrin.h".}
  ## Exposes _mm_maskstore_ps intrinsics

proc stream_si256*(a: ptr m256i, b: m256i): void
  {.importc: "_mm256_stream_si256", header: "immintrin.h".}
  ## Exposes _mm256_stream_si256 intrinsics

proc stream_pd*(a: ptr float64, b: m256d): void
  {.importc: "_mm256_stream_pd", header: "immintrin.h".}
  ## Exposes _mm256_stream_pd intrinsics

proc stream_ps*(p: ptr float32, a: m256): void
  {.importc: "_mm256_stream_ps", header: "immintrin.h".}
  ## Exposes _mm256_stream_ps intrinsics

proc set_pd*(a: float64, b: float64, c: float64, d: float64): m256d
  {.importc: "_mm256_set_pd", header: "immintrin.h".}
  ## Exposes _mm256_set_pd intrinsics

proc set_ps*(a: float32, b: float32, c: float32, d: float32, e: float32, f: float32, g: float32, h: float32): m256
  {.importc: "_mm256_set_ps", header: "immintrin.h".}
  ## Exposes _mm256_set_ps intrinsics

proc set_epi32*(i0: int32, i1: int32, i2: int32, i3: int32, i4: int32, i5: int32, i6: int32, i7: int32): m256i
  {.importc: "_mm256_set_epi32", header: "immintrin.h".}
  ## Exposes _mm256_set_epi32 intrinsics

proc set_epi16*(w15: int16, w14: int16, w13: int16, w12: int16, w11: int16, w10: int16, w09: int16, w08: int16, w07: int16, w06: int16, w05: int16, w04: int16, w03: int16, w02: int16, w01: int16, w00: int16): m256i
  {.importc: "_mm256_set_epi16", header: "immintrin.h".}
  ## Exposes _mm256_set_epi16 intrinsics

proc set_epi8*(b31: int8, b30: int8, b29: int8, b28: int8, b27: int8, b26: int8, b25: int8, b24: int8, b23: int8, b22: int8, b21: int8, b20: int8, b19: int8, b18: int8, b17: int8, b16: int8, b15: int8, b14: int8, b13: int8, b12: int8, b11: int8, b10: int8, b09: int8, b08: int8, b07: int8, b06: int8, b05: int8, b04: int8, b03: int8, b02: int8, b01: int8, b00: int8): m256i
  {.importc: "_mm256_set_epi8", header: "immintrin.h".}
  ## Exposes _mm256_set_epi8 intrinsics

when defined(x86_64):
  proc set_epi64x*(a: int64, b: int64, c: int64, d: int64): m256i
    {.importc: "_mm256_set_epi64x", header: "immintrin.h".}
    ## Exposes _mm256_set_epi64x intrinsics

  proc setr_epi64x*(a: int64, b: int64, c: int64, d: int64): m256i
    {.importc: "_mm256_setr_epi64x", header: "immintrin.h".}
    ## Exposes _mm256_setr_epi64x intrinsics

  proc set1_epi64x*(q: int64): m256i
    {.importc: "_mm256_set1_epi64x", header: "immintrin.h".}
    ## Exposes _mm256_set1_epi64x intrinsics

proc setr_pd*(a: float64, b: float64, c: float64, d: float64): m256d
  {.importc: "_mm256_setr_pd", header: "immintrin.h".}
  ## Exposes _mm256_setr_pd intrinsics

proc setr_ps*(a: float32, b: float32, c: float32, d: float32, e: float32, f: float32, g: float32, h: float32): m256
  {.importc: "_mm256_setr_ps", header: "immintrin.h".}
  ## Exposes _mm256_setr_ps intrinsics

proc setr_epi32*(i0: int32, i1: int32, i2: int32, i3: int32, i4: int32, i5: int32, i6: int32, i7: int32): m256i
  {.importc: "_mm256_setr_epi32", header: "immintrin.h".}
  ## Exposes _mm256_setr_epi32 intrinsics

proc setr_epi16*(w15: int16, w14: int16, w13: int16, w12: int16, w11: int16, w10: int16, w09: int16, w08: int16, w07: int16, w06: int16, w05: int16, w04: int16, w03: int16, w02: int16, w01: int16, w00: int16): m256i
  {.importc: "_mm256_setr_epi16", header: "immintrin.h".}
  ## Exposes _mm256_setr_epi16 intrinsics

proc setr_epi8*(b31: int8, b30: int8, b29: int8, b28: int8, b27: int8, b26: int8, b25: int8, b24: int8, b23: int8, b22: int8, b21: int8, b20: int8, b19: int8, b18: int8, b17: int8, b16: int8, b15: int8, b14: int8, b13: int8, b12: int8, b11: int8, b10: int8, b09: int8, b08: int8, b07: int8, b06: int8, b05: int8, b04: int8, b03: int8, b02: int8, b01: int8, b00: int8): m256i
  {.importc: "_mm256_setr_epi8", header: "immintrin.h".}
  ## Exposes _mm256_setr_epi8 intrinsics

proc set1_pd_256*(w: float64): m256d
  {.importc: "_mm256_set1_pd", header: "immintrin.h".}
  ## Exposes _mm256_set1_pd intrinsics

proc set1_ps*(w: float32): m256
  {.importc: "_mm256_set1_ps", header: "immintrin.h".}
  ## Exposes _mm256_set1_ps intrinsics

proc set1_epi32*(i: int32): m256i
  {.importc: "_mm256_set1_epi32", header: "immintrin.h".}
  ## Exposes _mm256_set1_epi32 intrinsics

proc set1_epi16*(w: int16): m256i
  {.importc: "_mm256_set1_epi16", header: "immintrin.h".}
  ## Exposes _mm256_set1_epi16 intrinsics

proc set1_epi8*(b: int8): m256i
  {.importc: "_mm256_set1_epi8", header: "immintrin.h".}
  ## Exposes _mm256_set1_epi8 intrinsics

proc setzero_pd*(): m256d
  {.importc: "_mm256_setzero_pd", header: "immintrin.h".}
  ## Exposes _mm256_setzero_pd intrinsics

proc setzero_ps*(): m256
  {.importc: "_mm256_setzero_ps", header: "immintrin.h".}
  ## Exposes _mm256_setzero_ps intrinsics

proc setzero_si256*(): m256i
  {.importc: "_mm256_setzero_si256", header: "immintrin.h".}
  ## Exposes _mm256_setzero_si256 intrinsics

proc castpd_ps*(a: m256d): m256
  {.importc: "_mm256_castpd_ps", header: "immintrin.h".}
  ## Exposes _mm256_castpd_ps intrinsics

proc castpd_si*(a: m256d): m256i
  {.importc: "_mm256_castpd_si256", header: "immintrin.h".}
  ## Exposes _mm256_castpd_si256 intrinsics

proc castps_pd*(a: m256): m256d
  {.importc: "_mm256_castps_pd", header: "immintrin.h".}
  ## Exposes _mm256_castps_pd intrinsics

proc castps_si*(a: m256): m256i
  {.importc: "_mm256_castps_si256", header: "immintrin.h".}
  ## Exposes _mm256_castps_si256 intrinsics

proc castsi256_ps*(a: m256i): m256
  {.importc: "_mm256_castsi256_ps", header: "immintrin.h".}
  ## Exposes _mm256_castsi256_ps intrinsics

proc castsi256_pd*(a: m256i): m256d
  {.importc: "_mm256_castsi256_pd", header: "immintrin.h".}
  ## Exposes _mm256_castsi256_pd intrinsics

proc castpd256_pd128*(a: m256d): m128d
  {.importc: "_mm256_castpd256_pd128", header: "immintrin.h".}
  ## Exposes _mm256_castpd256_pd128 intrinsics

proc castps256_ps128*(a: m256): m128
  {.importc: "_mm256_castps256_ps128", header: "immintrin.h".}
  ## Exposes _mm256_castps256_ps128 intrinsics

proc castsi256_si128*(a: m256i): m128i
  {.importc: "_mm256_castsi256_si128", header: "immintrin.h".}
  ## Exposes _mm256_castsi256_si128 intrinsics

proc castpd128_pd256*(a: m128d): m256d
  {.importc: "_mm256_castpd128_pd256", header: "immintrin.h".}
  ## Exposes _mm256_castpd128_pd256 intrinsics

proc castps128_ps256*(a: m128): m256
  {.importc: "_mm256_castps128_ps256", header: "immintrin.h".}
  ## Exposes _mm256_castps128_ps256 intrinsics

proc castsi128_si256*(a: m128i): m256i
  {.importc: "_mm256_castsi128_si256", header: "immintrin.h".}
  ## Exposes _mm256_castsi128_si256 intrinsics

# Export all avx immintrin.h constants
proc ceil_ps*(a: m256): m256
  {.importc: "_mm256_ceil_ps", header: "immintrin.h".}
  ## Exposes _mm256_ceil_ps intrinsics

proc ceil_pd*(a: m256d): m256d
  {.importc: "_mm256_ceil_pd", header: "immintrin.h".}
  ## Exposes _mm256_ceil_pd intrinsics

proc floor_ps*(a: m256): m256
  {.importc: "_mm256_floor_ps", header: "immintrin.h".}
  ## Exposes _mm256_floor_ps intrinsics

proc floor_pd*(a: m256d): m256d
  {.importc: "_mm256_floor_pd", header: "immintrin.h".}
  ## Exposes _mm256_floor_pd intrinsics

proc round_ps*(a: m256, b: int32): m256
  {.importc: "_mm256_round_ps", header: "immintrin.h".}
  ## Exposes _mm256_round_ps intrinsics

proc round_pd*(a: m256d, b: int32): m256d
  {.importc: "_mm256_round_pd", header: "immintrin.h".}
  ## Exposes _mm256_round_pd intrinsics

proc blend_ps*(a: m256, b: m256, c: int32): m256
  {.importc: "_mm256_blend_ps", header: "immintrin.h".}
  ## Exposes _mm256_blend_ps intrinsics

proc blend_pd*(a: m256d, b: m256d, c: int32): m256d
  {.importc: "_mm256_blend_pd", header: "immintrin.h".}
  ## Exposes _mm256_blend_pd intrinsics

proc permute_pd*(a: m256d, b: int32): m256d
  {.importc: "_mm256_permute_pd", header: "immintrin.h".}
  ## Exposes _mm256_permute_pd intrinsics

proc permute_pd*(a: m128d, b: int32): m128d
  {.importc: "_mm_permute_pd", header: "immintrin.h".}
  ## Exposes _mm_permute_pd intrinsics

proc permute_ps*(a: m256, b: int32): m256
  {.importc: "_mm256_permute_ps", header: "immintrin.h".}
  ## Exposes _mm256_permute_ps intrinsics

proc permute_ps*(a: m128, b: int32): m128
  {.importc: "_mm_permute_ps", header: "immintrin.h".}
  ## Exposes _mm_permute_ps intrinsics

proc permute2f128_pd*(a: m256d, b: m256d, c: int32): m256d
  {.importc: "_mm256_permute2f128_pd", header: "immintrin.h".}
  ## Exposes _mm256_permute2f128_pd intrinsics

proc permute2f128_ps*(a: m256, b: m256, c: int32): m256
  {.importc: "_mm256_permute2f128_ps", header: "immintrin.h".}
  ## Exposes _mm256_permute2f128_ps intrinsics

proc permute2f128_si256*(a: m256i, b: m256i, c: int32): m256i
  {.importc: "_mm256_permute2f128_si256", header: "immintrin.h".}
  ## Exposes _mm256_permute2f128_si256 intrinsics

proc dp_ps*(a: m256, b: m256, c: int32): m256
  {.importc: "_mm256_dp_ps", header: "immintrin.h".}
  ## Exposes _mm256_dp_ps intrinsics

proc shuffle_pd*(a: m256d, b: m256d, c: int32): m256d
  {.importc: "_mm256_shuffle_pd", header: "immintrin.h".}
  ## Exposes _mm256_shuffle_pd intrinsics

proc shuffle_ps*(a: m256, b: m256, c: int32): m256
  {.importc: "_mm256_shuffle_ps", header: "immintrin.h".}
  ## Exposes _mm256_shuffle_ps intrinsics

proc insertf128_pd*(a: m256d, b: m128d, c: int32): m256d
  {.importc: "_mm256_insertf128_pd", header: "immintrin.h".}
  ## Exposes _mm256_insertf128_pd intrinsics

proc insertf128_ps*(a: m256, b: m128, c: int32): m256
  {.importc: "_mm256_insertf128_ps", header: "immintrin.h".}
  ## Exposes _mm256_insertf128_ps intrinsics

proc insertf128_si256*(a: m256i, b: m128i, c: int32): m256i
  {.importc: "_mm256_insertf128_si256", header: "immintrin.h".}
  ## Exposes _mm256_insertf128_si256 intrinsics

proc cmp_pd*(a: m128d, b: m128d, c: int32): m128d
  {.importc: "_mm_cmp_pd", header: "immintrin.h".}
  ## Exposes _mm_cmp_pd intrinsics

proc cmp_ps*(a: m128, b: m128, c: int32): m128
  {.importc: "_mm_cmp_ps", header: "immintrin.h".}
  ## Exposes _mm_cmp_ps intrinsics

proc cmp_ss*(a: m128, b: m128, c: int32): m128
  {.importc: "_mm_cmp_ss", header: "immintrin.h".}
  ## Exposes _mm_cmp_ss intrinsics

proc cmp_pd*(a: m256d, b: m256d, c: int32): m256d
  {.importc: "_mm256_cmp_pd", header: "immintrin.h".}
  ## Exposes _mm256_cmp_pd intrinsics

proc cmp_ps*(a: m256, b: m256, c: int32): m256
  {.importc: "_mm256_cmp_ps", header: "immintrin.h".}
  ## Exposes _mm256_cmp_ps intrinsics

# Compare constants
const CMP_EQ_OQ* = 0x00 # Equal (ordered, non-signaling)
const CMP_LT_OS* = 0x01 # Less-than (ordered, signaling)
const CMP_LE_OS* = 0x02 # Less-than-or-equal (ordered, signaling)
const CMP_UNORD_Q* = 0x03 # Unordered (non-signaling)
const CMP_NEQ_UQ* = 0x04 # Not-equal (unordered, non-signaling)
const CMP_NLT_US* = 0x05 # Not-less-than (unordered, signaling)
const CMP_NLE_US* = 0x06 # Not-less-than-or-equal (unordered, signaling)
const CMP_ORD_Q* = 0x07 # Ordered (nonsignaling)
const CMP_EQ_UQ* = 0x08 # Equal (unordered, non-signaling)
const CMP_NGE_US* = 0x09 # Not-greater-than-or-equal (unord, signaling)
const CMP_NGT_US* = 0x0a # Not-greater-than (unordered, signaling)
const CMP_FALSE_OQ* = 0x0b # False (ordered, non-signaling)
const CMP_NEQ_OQ* = 0x0c # Not-equal (ordered, non-signaling)
const CMP_GE_OS* = 0x0d # Greater-than-or-equal (ordered, signaling)
const CMP_GT_OS* = 0x0e # Greater-than (ordered, signaling)
const CMP_TRUE_UQ* = 0x0f # True (unordered, non-signaling)
const CMP_EQ_OS* = 0x10 # Equal (ordered, signaling)
const CMP_LT_OQ* = 0x11 # Less-than (ordered, non-signaling)
const CMP_LE_OQ* = 0x12 # Less-than-or-equal (ordered, non-signaling)
const CMP_UNORD_S* = 0x13 # Unordered (signaling)
const CMP_NEQ_US* = 0x14 # Not-equal (unordered, signaling)
const CMP_NLT_UQ* = 0x15 # Not-less-than (unordered, non-signaling)
const CMP_NLE_UQ* = 0x16 # Not-less-than-or-equal (unord, non-signaling)
const CMP_ORD_S* = 0x17 # Ordered (signaling)
const CMP_EQ_US* = 0x18 # Equal (unordered, signaling)
const CMP_NGE_UQ* = 0x19 # Not-greater-than-or-equal (unord, non-sign)
const CMP_NGT_UQ* = 0x1a # Not-greater-than (unordered, non-signaling)
const CMP_FALSE_OS* = 0x1b # False (ordered, signaling)
const CMP_NEQ_OS* = 0x1c # Not-equal (ordered, signaling)
const CMP_GE_OQ* = 0x1d # Greater-than-or-equal (ordered, non-signaling)
const CMP_GT_OQ* = 0x1e # Greater-than (ordered, non-signaling)
const CMP_TRUE_US* = 0x1f # True (unordered, signaling)

## Falbacks

# Floor and convert to int in one go
template floor_ps_epi32*(a: m256) : m256i = 
  cvtps_epi32(floor_ps(a))

# Greater than or equal with same conventions as SSE
template cmpge_ps*(a,b:m256) : m256 =
  cmp_ps(a,b,CMP_GE_OQ)

# Greater than with same conventions as SSE
template cmpgt_ps*(a,b:m256) : m256 = 
  cmp_ps(a,b,CMP_GT_OQ)

# Less than with same conventions as SSE
template cmplt_ps*(a,b:m256) : m256 =
  cmp_ps(a,b,CMP_LT_OQ)
