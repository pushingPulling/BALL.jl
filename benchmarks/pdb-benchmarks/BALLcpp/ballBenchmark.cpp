//#include <BALL/CONFIG/config.h>

#include <iostream>
#include <iosfwd>
#include <unordered_map>
#include <algorithm>
#include <math.h>
#include <limits>

#include <BALL/FORMAT/PDBFile.h>
#include <BALL/KERNEL/system.h>
#include <BALL/KERNEL/atom.h>
#include <BALL/KERNEL/residue.h>
#include <BALL/KERNEL/bond.h>
#include <BALL/KERNEL/PTE.h>
#include <BALL/STRUCTURE/addHydrogenProcessor.h>
#include <BALL/STRUCTURE/structureMapper.h>
#include <BALL/QSAR/ringPerceptionProcessor.h>
#include <BALL/QSAR/aromaticityProcessor.h>
#include <BALL/STRUCTURE/peptides.h>
#include <BALL/KERNEL/selector.h>
#include <benchmark/benchmark.h>


using namespace BALL;
using namespace benchmark;
bool comp(std::pair<std::string, int> pair1, std::pair<std::string, int> pair2) {
    return std::get<1>(pair1) > std::get<1>(pair2);
}

static void BM_RMSD(benchmark::State& state) {
	
    PDBFile f {"/mnt/c/Users/Dan/BALLprogs/1ake.pdb"};
    System s;
    f >> s;
    System s2 = System(s);

    auto atit = s2.beginAtom();

    for (;+atit;++atit){
        atit->setPosition(atit->getPosition() + Vector3(1/sqrt(3),1/sqrt(3),1/sqrt(3)));
    }

    for (auto _ : state) {

	    StructureMapper mapper(s,s2);
	    mapper.calculateDefaultBijection();

	    float rmsd = mapper.calculateRMSD();
	}
}





static void BM_distance(benchmark::State& state) {
    PDBFile f {"/home/sunnyd/CLionProjects/BALLprogs/1ake.pdb"};
    System s;
    f >> s;
    for (auto _ : state) {
        //state.PauseTiming();

        //state.ResumeTiming();


        int c = 0;
        auto chit = s.beginChain();
        auto resit = chit->beginResidue();
        BidirectionalIterator<Composite, Residue, BidirectionalIterator<Composite, Composite, Composite *, Composite::CompositeIteratorTraits>, ResidueIteratorTraits> res2;
        BidirectionalIterator<Composite, Residue, BidirectionalIterator<Composite, Composite, Composite *, Composite::CompositeIteratorTraits>, ResidueIteratorTraits> res1;



        int i = 0;
        for (; +resit; ++resit) {
            if (i == 49){
                res1 = resit;
            }
            if (i == 59){
                res2 = resit;
                break;
            }
            i++;
        }
        auto atit1 =res1->beginAtom();
        auto atit2 =res2->beginAtom();
        float mindist = std::numeric_limits<float>::max();
        float dist;
        for (; +atit1; ++atit1){
            for (atit2 = atit1; +atit2; ++atit2){
                auto vec1  = atit1->getPosition();
                auto vec2  = atit2->getPosition();
                dist = vec1.getDistance(vec2);
                if (dist < mindist && dist != 0.0){
                    mindist = dist;
                }

            }
        }

    }

}
// Register the function as a benchmark
BENCHMARK(BM_RMSD);

BENCHMARK_MAIN();


//int main() {

    
//}
    /*
    //benchmark this
    *//*
    PDBFile f {"2lzx.pdb"};
    System s;

    f >> s;
    Protein* prot = s.getProtein(0);

    if(prot) {
        std::cout << "Found a protein:\n"
                  << Peptides::GetSequence(*prot) << "\n";
    } else {
        std::cout << "Sorry, no protein here!\n";
    }


    System s2 = System();
    Residue r1 = Residue();
    s2.appendChild(r1);
    Element elem = PTE_::getElement(6);
    Atom a1 = Atom();
    Atom a2 = Atom();
    Atom a3 = Atom();
    Atom a4 = Atom();
    Atom a5 = Atom();
    a1.setElement(elem);
    a2.setElement(elem);
    a3.setElement(elem);
    a4.setElement(elem);
    a5.setElement(elem);
    a1.createBond(a2);
    //a2.createBond(a3);
    //a3.createBond(a4);
    //a4.createBond(a5);


    std::cout << a1.countBonds() << std::endl;

    r1.appendChild(a1);
    r1.appendChild(a2);
    //r1.appendChild(a3);
    //r1.appendChild(a4);
    //r1.appendChild(a5);
    //std::cout << a5.getElement().getName() << std::endl;

    AtomIterator it = s2.beginAtom();
    std::cout << "Bfore addHydro \n" << std::endl;
    for(; +it;++it){
        std::cout << (*it).getElement().getName() << std::endl;
    }

//ResidueIterator rit = s2.beginResidue();
    AddHydrogenProcessor ap;
    s2.apply(ap);
    Selector wat("element(H)");
    s2.apply(wat);
    s2.removeSelected();


    it = s2.beginAtom();
    std::cout << "\n after hydro" << std::endl;
    for(; +it;++it) {
        std::cout << (*it).getElement().getName() << std::endl;
    }
    *//*


    PDBFile f {"1EN2.pdb"};
    System s;

    f >> s;



    std::cout << s.countAtoms() << std::endl;
    auto chit = s.beginChain();
    int i = 0;
    for (;+chit; ++chit){
        std::cout << i << " ";
        std::cout<< chit->countAtoms() <<std::endl;
        i++;
    }

    RingPerceptionProcessor rpp;
    s.apply(rpp);

    for (int i = 0; i< rpp.getAllSmallRings().size(); i++)
    {
        for (int j = 0; j < rpp.getAllSmallRings()[i].size(); j++)
        {
            std::cout <<i<< " "<< j << rpp.getAllSmallRings()[i][j]->getElement() << " " << rpp.getAllSmallRings()[i][j]->getName() << std::endl;
        }
    }
    auto vec = std::vector<std::vector<Atom*>>();
    std::cout << rpp.getAllSmallRings().size() << std::endl;
    std::cout << rpp.calculateSSSR(vec,s) << std::endl;
    std::cout << s.countBonds() << std::endl;
    std::cout << s.countAtoms() << std::endl;
    std::cout << "...........................------------------------------------" << std::endl;

    AromaticityProcessor arom;
    arom.aromatize(rpp.getAllSmallRings(), s);
    s.apply(arom);









    *//*
    auto counter = 0;
    auto map = std::unordered_map<std::string, int>();

    auto resit = s.beginChain()->beginResidue();
    for (; +resit; ++resit){
        counter++;
        if (!resit->isAminoAcid()) {
            std::cout << resit->getName() << " is not an Amino Acid" << std::endl;
        }
        //std::cout << resit->getName() << std::endl;
        if (map.find(resit->getName()) == map.end()) {
            map[resit->getName()] = 1;
        } else {
            map[resit->getName()] += 1;
        }
    }
    std::vector<std::pair<std::string, int>> elems(map.begin(), map.end());

    std::sort(elems.begin(), elems.end(), comp);

    for (auto i: elems){
        std::cout << std::get<0>(i) << " " << std::get<1>(i) << std::endl;
    }
    std::cout << counter << std::endl;
     *//*




}*/
