# Iteration

The preferred way to iterate over objects in the composite tree is via the functions\

 * [`collectAtoms`](@ref)(`node`)     to collect Atoms      in the subtree rooted in `node`
 * [`collectChains`](@ref)(`node`)    to collect Chains     in the subtree rooted in `node`
 * [`collectResidues`](@ref)(`node`) to collect Residues in the subtree rooted in `node`
 * [`collectSysten`](@ref)(`node`)    to collect Systems   in the subtree rooted in `node`
 * [collect](@ref collect(node::AbstractComposite))(`node`)                  to collect all nodes  in the subtree rooted in `node`
 
 [`collectBonds`](@ref)(`node`) collects all the bonds in the subtree rooted in `node`
 
 Other -- significantly slower -- methods are [`iterate`](@ref iterate(s :: T) where T <: CompositeIterator)
 and associated itertor wrappers.