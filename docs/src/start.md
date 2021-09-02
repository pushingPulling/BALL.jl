# Getting started

## Install BALL
(once BALL goes online)\
Get BALL by executing\

```
import Pkg; Pkg.add("BALL")
using BALL
```
## Exploring Proteins with BALL
A common use case is to read a Protein specification from a fileformat like `PDB`.
This example inspects a [superantigen](https://en.wikipedia.org/wiki/Superantigen) 
for t-cells. Its ID in the protein databank is \"1EN2\".


```
protein = System("1EN2.pdb")
    > System "1EN2" with 3 children containing 754 Atoms

countAtoms(protein)
    > 754

collectAtoms(protein)[1:5]
    > Atom[Atom[N|PCA], Atom[C|PCA], Atom[C|PCA], Atom[C|PCA], Atom[C|PCA]]

countResidues(protein)
    > 166

countBonds(protein)
    > 152

first(collectBonds(protein))
    > Single covalent bond: Atom[O|HOH] -> Atom[O|HOH]

collectChains(protein)
    > Chain[Chain "A" with 86 children containing 622 Atoms, 
            Chain "B" with 4 children containing 56 Atoms,
            Chain "C" with 76 children containing 76 Atoms]
```
Modification, removal and addition of Elements is supported.\
```
chain_c = collectChains(protein)["C"]
    > Chain "C" with 76 children containing 76 Atoms
removeComposite(chain_c)
collectChains(protein)
    > Chain[Chain "A" with 86 children containing 622 Atoms, 
            Chain "B" with 4 children containing 56 Atoms]
```

Thanks to the design of Julia, it is easy to implement new tasks:\

```
histogram = Dict{Element, Int}()
for at in collectAtoms(protein)
    histogram[getElement(at)] = get(histogram, getElement(at),0) + 1
end
foreach(println, histogram)
    > S => 16
    > O => 141
    > N => 127
    > C => 394
```
