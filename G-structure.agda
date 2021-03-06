{-# OPTIONS --without-K #-}

module G-structure where
  open import Basics
  open import EqualityAndPaths
  open import Equivalences renaming (underlying-map-of to as-plain-map)
  open import Homotopies
  open import Univalence
  open import LeftInvertibleHspace
  open import FormalDiskBundle
  open import FiberBundle
  open import InfinityGroups
  open import PropositionalTruncation
  open import OneImage
  open import EtaleMaps
  open import Manifolds

  formal-disk-of :
    ∀ {V : U₀}
    → (structure-on-V : left-invertible-structure-on V)
    → U₀
  formal-disk-of structure-on-V =
    formal-disk-at (left-invertible-structure-on_.e structure-on-V)
  
  record groups-over-structure-group-of_ {V : U₀}
    (structure-on-V : left-invertible-structure-on V) : U₁ where
    constructor group-given-by-delooping_with-unit_and-morphism_with-unit-identification_
    field
      BG : U₀
      Be : BG
      Bφ : BG → BAut (formal-disk-of structure-on-V)
      path-between-units : Bφ(Be) ≈ e-BAut (formal-disk-of structure-on-V)


  module G-structures-on-V-manifolds
    {V M W : U₀} (w : W ─ét→ M) (v : W ─ét→ V)
    (structure-on-V : left-invertible-structure-on V)
    (reduction : groups-over-structure-group-of structure-on-V)
    (M-is-a-manifold : M is-a-manifold-with-cover w
                      locally-like structure-on-V by v) where
    

    open left-invertible-structure-on_ structure-on-V
    open groups-over-structure-group-of_ reduction

    De = formal-disk-at e

    χ : M → BAut De
    χ = the-formal-disk-bundle-on-a-manifold-is-a-fiber-bundle.classifying-morphism
        W M w structure-on-V v M-is-a-manifold

    {-
      Let BG be a delooping of a group G
      together with an 'inclusion' Bι : BG → BAut(D)
      into the Automorphisms of the formal disk 
      at the unit of V.
      A G-structure on a V-manifold M is given by a
      lift of the classifying morphism of T∞ V
      along Bι:
  
         ↗ BG 
        φ   |
       /   Bφ
      /     ↓ 
      M ─→ BAut(D)
  
      We do not claim, that the type of those lifts
      is the correct moduli type of G-structures on M.
    -}

    G-structures : U₁
    G-structures = ∑ (λ (φ : M → BG) → Bφ ∘ φ ⇒ χ)
    

  {-
      on a left invertible H-space V,
      there is always a 1-structure (for the trivial group 1)
  -}
  module trivial-structure-on-left-invertible-spaces
    {V : U₀}
    (structure-on-V : left-invertible-structure-on V) 
    (group-over-BAutD : groups-over-structure-group-of structure-on-V)
    where

    open left-invertible-structure-on_ structure-on-V

    De = formal-disk-at e

    G-structures-on-V : U₁
    G-structures-on-V =
      G-structures-on-V-manifolds.G-structures
      id-as-étale-map id-as-étale-map
      structure-on-V
      group-over-BAutD
      (left-invertible-H-spaces-are-manifolds structure-on-V)

    ψ : (x : V) → De ≃ (formal-disk-at x)
    ψ = triviality-of-the-formel-disk-bundle-the-nice-way.equivalences structure-on-V

    open groups-over-structure-group-of_ group-over-BAutD

    -- calculate the classifying morphism for V
    -- i.e. give an explicit description
    χ-V : V → BAut De
    χ-V x = ((formal-disk-at x) , ∣ (∗ , univalence (ψ x)) ∣)

    V-is-a-manifold = (left-invertible-H-spaces-are-manifolds structure-on-V)

    χ′ = G-structures-on-V-manifolds.χ id-as-étale-map id-as-étale-map
              structure-on-V group-over-BAutD
              V-is-a-manifold
    χ-V⇒χ′ :
      χ-V ⇒ χ′
    χ-V⇒χ′ = 1-monos-are-monos χ-V χ′ (ι-BAut De) (ι-im₁-is-1-mono (λ ∗₃ → De))
      (λ (x : V) →
           the-formal-disk-bundle-on-a-manifold-is-a-fiber-bundle.commutes-with-the-dependent-replacement-of-T∞
           V V id-as-étale-map structure-on-V id-as-étale-map V-is-a-manifold
           x)

    trivial-structure : G-structures-on-V
    trivial-structure =
      ((λ x → Be) , (λ x →
         Bφ(Be)
        ≈⟨ path-between-units ⟩
          e-BAut _
        ≈⟨ 1-monos-are-monos (λ _ → e-BAut _) χ-V (ι-BAut De)
             (ι-im₁-is-1-mono (λ ∗₃ → De)) (λ y → univalence (ψ y)) x ⟩
          χ-V x
        ≈⟨ χ-V⇒χ′ x ⟩
          χ′ x
        ≈∎))

  {-
    We will now work towards the definition of 
    torision-free G-structures.
    For this, we need to be able to compare
    G-structures on formal disks
  -}
    D-at = formal-disk-at_
    ι-D = inclusion-of-formal-disk-at
    ι-De = inclusion-of-formal-disk-at e

    trivial-structure-restricted-to-D₁e :
      formal-disk-at e → BG
    trivial-structure-restricted-to-D₁e =
      let
        ψ : V → BG
        ψ = (∑π₁ trivial-structure)
      in ψ ∘ ι-De

    {-
      now, for a general V-manifold
    -}
    module general-manifolds
      {M W : U₀} (w : W ─ét→ M) (v : W ─ét→ V)
      (M-is-a-V-manifold : M is-a-manifold-with-cover w
                      locally-like structure-on-V by v)
                 where

      ∗D : (x₀ : M) → formal-disk-at x₀
      ∗D x₀ = (x₀ , refl) 

      χ-M : M → BAut De
      χ-M =
        the-formal-disk-bundle-on-a-manifold-is-a-fiber-bundle.classifying-morphism
          W M w structure-on-V v M-is-a-V-manifold
      
      all-Ds-are-merely-equivalent :
        ∀ (x : M)
        → ∥  D-at e ≃ D-at x ∥
      all-Ds-are-merely-equivalent x =
        ( ∥→ (λ f → f ∘≃ (pullback-and-sum-definition-of-formal-disks-are-equivalent.conclusion e ⁻¹≃)) ∥→
        (the-formal-disk-bundle-on-a-manifold-is-a-fiber-bundle.all-formal-disks-are-merely-equivalent
          W M w structure-on-V v M-is-a-V-manifold x ) )
      
      G-structures-on-M =
        G-structures-on-V-manifolds.G-structures
        w v structure-on-V group-over-BAutD M-is-a-V-manifold

      _is-torsion-free :
        G-structures-on-M → U₁
      (lift , homotopy) is-torsion-free =
        {- 
          to decide if a G-structure is torsion free,
          we have to compare it locally to the trivial G-structure.
          This means comparing all triangles obtained by restricting the
          G-Structure to the formal disk at some point x
          
  
                ↗ BG                       ↗ BG       
               /   |                      φ   |       
              /   Bφ         ≈           /   Bφ       
             /     ↓                    /     ↓       
          D x ──→ BAut(De)     D x ──→ M ──→ BAut(De) 

          to the De-triangle of the trivial G-Structure 

                ↗ BG       
              B1   |       
              /   Bφ       
             /     ↓       
          D e ──→ BAut(De) 

        -}
        let
          -- classifying map of T∞V
          ξ = G-structures-on-V-manifolds.χ id-as-étale-map id-as-étale-map
              structure-on-V group-over-BAutD
              V-is-a-manifold

          -- the triangle type discussed above
          triangles-at : BAut De → U₁
          triangles-at = λ {(Dx , _) → ∑ λ (f : Dx →  BG) 
                                     → ∑ λ (g : Dx →  BAut De)
                                           → Bφ ∘ f ⇒ g}

          triangle-of-the-trivial-G-structure :
            triangles-at (e-BAut De)
          triangle-of-the-trivial-G-structure =
            (trivial-structure-restricted-to-D₁e ,
              (ξ ∘ ι-De  , (pre-whisker ι-De to (∑π₂ trivial-structure))))

          D-at_as-point-in-BAut-De :
            ∀ (x : M) → BAut De
          D-at_as-point-in-BAut-De x =
            (D-at x , ∥→ (λ z → (∗ , univalence z)) ∥→  (all-Ds-are-merely-equivalent x))

          triangle-from-the-G-structure-at :
            ∀ (x : M) → triangles-at (D-at x as-point-in-BAut-De)
          triangle-from-the-G-structure-at x =
            (lift ∘ ι-D x , (χ-M ∘ ι-D x , (pre-whisker (ι-D x) to homotopy)))

        in  ∀ (x : M)
          → ∀ (γ : D-at x as-point-in-BAut-De ≈ e-BAut De)
          → ∥ transport triangles-at γ (triangle-from-the-G-structure-at x)
              ≈ triangle-of-the-trivial-G-structure ∥ 
