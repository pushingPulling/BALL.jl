// Benchmark Rmsd
#include <assert.h>
#include <stdio.h>
#include <time.h>
#include <string>
#include <gemmi/pdb.hpp>
#include <gemmi/model.hpp>
#include <gemmi/polyheur.hpp>  // for setup_entities, align_sequence_to_polymer
#include <gemmi/align.hpp>     // for align_sequence_to_polymer
#include <gemmi/seqalign.hpp>  // for align_string_sequences
#include <gemmi/read_coor.hpp>


const gemmi::Model& get_first_model(gemmi::Structure& st) {
  gemmi::setup_entities(st);
  if (st.models.empty())
    gemmi::fail("No atoms found. Wrong input file?");
  return st.models[0];
}

gemmi::ConstResidueSpan get_polymer(const gemmi::Model& model,
                                    const std::string& chain_name) {
  const gemmi::Chain* ch = model.find_chain(chain_name);
  if (!ch)
    gemmi::fail("No such chain: " + chain_name);
  gemmi::ConstResidueSpan polymer = ch->get_polymer();
  if (!polymer)
    gemmi::fail("Polymer not found in chain " + chain_name);
  return polymer;
}

const gemmi::Entity* get_entity(gemmi::Structure& st,
                                const std::string& chain_name) {
  auto polymer = get_polymer(get_first_model(st), chain_name);
  if (const gemmi::Entity* ent = st.get_entity_of(polymer))
    return ent;
  gemmi::fail("No sequence (SEQRES) for chain " + chain_name);
}


int main() {
    std::string pdb_filepath = "1ake.pdb";
    gemmi::Structure st = gemmi::read_pdb_file(pdb_filepath);
    gemmi::Structure st2 = gemmi::read_pdb_file(pdb_filepath);
    timespec tstart, tend;
    auto poly1 = get_polymer(st.models.at(0),st.first_model().chains.at(0).name);
    auto poly2 = get_polymer(st2.models.at(0),st2.first_model().chains.at(0).name);
    const gemmi::Entity* ent = get_entity(st, st.first_model().chains.at(0).name);
    auto ptype = ent->polymer_type;
	auto run = 0.0;
	for (int i = 0; i<1000; i++){
	

    clock_gettime(CLOCK_REALTIME, &tstart);
    //bench
    gemmi::calculate_current_rmsd(poly1,poly2,ptype,gemmi::SupSelect::All);
    clock_gettime(CLOCK_REALTIME, &tend);
	run += (tend.tv_sec - tstart.tv_sec) + (tend.tv_nsec - tstart.tv_nsec) / 1e9;
}

//    printf("%.6f\n", (tend.tv_sec - tstart.tv_sec) + (tend.tv_nsec - tstart.tv_nsec) / 1e9);
	printf("%.6f\n", run/1000);
    return 0;
}

