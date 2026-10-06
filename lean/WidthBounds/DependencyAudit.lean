import WidthBounds.AllWidths
import WidthBounds.Growth
import WidthBounds.GeneratorBounds
import WidthBounds.GeneratorExact
import WidthBounds.GeneratorNumberBounds
import WidthBounds.GeneratorQuotientBounds
import WidthBounds.GeneratorTensorBounds
import WidthBounds.TorOneBounds
import WidthBounds.LowerConstructionBounds
import WidthBounds.LexGrowthTheta
import WidthBounds.FinitePresentationBounds
import WidthBounds.MonomialFirstSyzygies
import WidthBounds.LexQuotientResolution
import WidthBounds.HigherTorBounds
import Lean.Util.FoldConsts

/-! Diagnostic audit of actual declaration dependencies, rather than import lists.
This command is not used to establish any mathematical proposition.
-/
open Lean Elab Command in
run_cmd do
  let env ← getEnv
  let roots := [``WidthBounds.all_widths_analytic_bounds,
    ``WidthBounds.all_widths_strict_improvement,
    ``WidthBounds.Growth.sectionLength_le_harmonic,
    ``WidthBounds.Growth.quotient_xy_le_harmonic,
    ``WidthBounds.MonomialInterface.monomialIdeal_exists_generators_le,
    ``WidthBounds.MonomialInterface.finiteColength_exists_generators_card_lt,
    ``WidthBounds.MonomialInterface.quotient_finite_iff_exists_pure_z,
    ``WidthBounds.MonomialInterface.monomialIdeal_exists_exact_minimal_exponents,
    ``WidthBounds.MonomialInterface.finiteColength_exists_exact_minimal_generators,
    ``WidthBounds.MonomialInterface.minimal_exponents_card_le_generators,
    ``WidthBounds.MonomialInterface.finiteColength_generator_number_bounds,
    ``WidthBounds.MonomialInterface.ker_generatorCoefficientMap,
    ``WidthBounds.MonomialInterface.generatorQuotientBasis_apply,
    ``WidthBounds.MonomialInterface.finiteColength_generatorQuotient_bounds,
    ``WidthBounds.MonomialInterface.generatorTensorEquiv,
    ``WidthBounds.MonomialInterface.variableResidueEquiv,
    ``WidthBounds.MonomialInterface.generatorTensorCoordinates_tmul,
    ``WidthBounds.MonomialInterface.generatorTensorBasis_apply,
    ``WidthBounds.MonomialInterface.monomialIdeal_le_variableIdeal_of_x_standard,
    ``WidthBounds.MonomialInterface.finiteColength_generatorTensor_bounds,
    ``WidthBounds.DerivedKernel.isoLeftDerivedOne,
    ``WidthBounds.MonomialInterface.idealQuotientTorOneIsoTensor,
    ``WidthBounds.MonomialInterface.idealQuotientTorOneEquivTensor,
    ``WidthBounds.MonomialInterface.torOneBasis_toTensor,
    ``WidthBounds.MonomialInterface.finiteColength_torOne_bounds,
    ``WidthBounds.Lower.lower_hilbert2_eq,
    ``WidthBounds.Lower.lowerIdeal_admissible,
    ``WidthBounds.Lower.lowerIdeal_xy_finrank,
    ``WidthBounds.Lower.lowerIdeal_xy_harmonic_lower,
    ``WidthBounds.Lower.lowerIdeal_torOne_finrank,
    ``WidthBounds.Lower.lowerIdeal_generator_number,
    ``WidthBounds.LogGrowth.quotient_xy_le_ten_mul_width_log,
    ``WidthBounds.LogLower.lowerIdeal_xy_log_lower,
    ``WidthBounds.LexExtremal.maxLexLength_isGreatest,
    ``WidthBounds.LexExtremal.maxLexLength_log_bounds,
    ``WidthBounds.LexExtremal.maxLexLength_isTheta,
    ``WidthBounds.MonomialPresentation.range_differential_eq_ideal,
    ``WidthBounds.MonomialPresentation.presentation_exact,
    ``WidthBounds.MonomialPresentation.firstSyzygiesKernelIso_hom_inclusion,
    ``WidthBounds.MonomialPresentation.mapToIdealKernelIso_hom_inclusion,
    ``WidthBounds.MonomialPresentation.mapToQuotientKernel_comp_idealQuotientKernelIso,
    ``WidthBounds.MonomialPresentation.residueTensorFunctor_map_differential_eq_zero,
    ``WidthBounds.MonomialPresentation.tensorDifferential_tmul_freeBasis,
    ``WidthBounds.MonomialPresentation.tensorDifferentialK_eq_zero,
    ``WidthBounds.MonomialPresentation.finiteColength_presentation_bounds,
    ``WidthBounds.MonomialPresentation.ker_differential_le_of_commonRelation,
    ``WidthBounds.MonomialPresentation.ker_differential_eq_span_lcmRelation,
    ``WidthBounds.MonomialPresentation.card_boundaryRelationIndex,
    ``WidthBounds.MonomialPresentation.canonicalBoundaryExponent_le,
    ``WidthBounds.MonomialPresentation.exists_boundary_step,
    ``WidthBounds.MonomialPresentation.boundaryRelationTarget_height_lt,
    ``WidthBounds.MonomialPresentation.commonRelation_canonical_mem,
    ``WidthBounds.MonomialPresentation.boundaryRelationSpan_eq_ker,
    ``WidthBounds.MonomialPresentation.range_secondDifferential,
    ``WidthBounds.MonomialPresentation.secondPresentation_exact,
    ``WidthBounds.MonomialPresentation.secondToFirstSyzygies_surjective,
    ``WidthBounds.MonomialPresentation.boundary_firstSyzygies_finite,
    ``WidthBounds.MonomialPresentation.boundary_secondFree_finrank,
    ``WidthBounds.MonomialPresentation.finiteColength_second_presentation_bounds,
    ``WidthBounds.MonomialPresentation.polynomial_xy_relation,
    ``WidthBounds.MonomialPresentation.boundaryRelationTarget_total_le,
    ``WidthBounds.MonomialPresentation.residueTensorFunctor_map_secondDifferential_eq_zero,
    ``WidthBounds.MonomialPresentation.thirdDifferential_injective,
    ``WidthBounds.MonomialPresentation.range_thirdDifferential,
    ``WidthBounds.MonomialPresentation.exists_normalizingCoefficients,
    ``WidthBounds.MonomialPresentation.exists_lexThirdColumn,
    ``WidthBounds.MonomialPresentation.lexThirdColumn_triangular,
    ``WidthBounds.MonomialPresentation.range_lexThirdDifferential,
    ``WidthBounds.MonomialPresentation.lexThirdDifferential_injective,
    ``WidthBounds.MonomialPresentation.lexThird_exact,
    ``WidthBounds.MonomialPresentation.residueTensorFunctor_map_lexThirdDifferential_eq_zero,
    ``WidthBounds.MonomialPresentation.boundary_thirdFree_finrank,
    ``WidthBounds.FiniteThreeResolution.resolution,
    ``WidthBounds.FiniteThreeResolution.map_resolution_d_eq_zero,
    ``WidthBounds.MonomialPresentation.lexQuotientResolution,
    ``WidthBounds.MonomialPresentation.lexQuotientResolution_augmentation,
    ``WidthBounds.MonomialPresentation.lexQuotientResolution_free,
    ``WidthBounds.MonomialPresentation.lexQuotientResolution_finite,
    ``WidthBounds.MonomialPresentation.lexQuotientResolution_zero_tail,
    ``WidthBounds.MonomialPresentation.lexQuotientResolution_residue_d_zero,
    ``WidthBounds.MonomialPresentation.finiteColength_exists_residue_minimal_resolution,
    ``WidthBounds.MonomialInterface.residueTensorKNaturalEquiv,
    ``WidthBounds.MonomialInterface.residueTensorFreeCoordinates,
    ``WidthBounds.MonomialInterface.residueTensor_free_finite,
    ``WidthBounds.MonomialInterface.finrank_residueTensor_free,
    ``WidthBounds.homologyIsoTermOfZeroDifferentials,
    ``WidthBounds.MonomialInterface.idealQuotientTorIsoHomology,
    ``WidthBounds.MonomialInterface.idealQuotientTorIsoResidueTensor,
    ``WidthBounds.MonomialInterface.idealQuotientTorEquivResidueTensor,
    ``WidthBounds.MonomialInterface.idealQuotientTor_isZero_of_resolution_isZero,
    ``WidthBounds.MonomialPresentation.higherTor_one_dimension_compatibility,
    ``WidthBounds.MonomialPresentation.minimalResolution_tor_finite,
    ``WidthBounds.MonomialPresentation.minimalResolution_tor_finrank,
    ``WidthBounds.MonomialPresentation.finrank_tor_eq_zero_of_isZero,
    ``WidthBounds.MonomialPresentation.lexQuotient_tor_dimensions,
    ``WidthBounds.MonomialPresentation.finiteColength_higherTor_dimensions,
    ``WidthBounds.MonomialPresentation.finiteColength_higherTor_width_bounds,
    ``WidthBounds.MonomialPresentation.finiteColength_tor_all_positive_bounds]
  for root in roots do
    let mut pending := [root]
    let mut visited : NameSet := {}
    while !pending.isEmpty do
      let n := pending.head!
      pending := pending.tail!
      if !visited.contains n then
        visited := visited.insert n
        if let some decl := env.find? n then
          for dep in decl.getUsedConstantsAsSet do
            if !visited.contains dep then
              pending := dep :: pending
    let forbidden := [``WidthBounds.finite_envelope_certificate,
      ``WidthBounds.small_width_combinatorial_bounds,
      ``WidthBounds.small_width_binomial_bounds,
      ``WidthBounds.envelope_bounds]
    for n in forbidden do
      if visited.contains n then
        throwError "Unexpected finite/small-width dependency: {n} in {root}"
    if visited.contains ``sorryAx then
      throwError "Unexpected sorryAx dependency in {root}"
    logInfo m!"{root}: finite enumeration and small-width certificate absent from transitive declaration dependencies."
