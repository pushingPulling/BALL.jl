# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /mnt/c/Users/Dan/pdb-benchmarks/ESBTL

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /mnt/c/Users/Dan/pdb-benchmarks/ESBTL/build

# Include any dependencies generated for this target.
include CMakeFiles/parse_pdb.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/parse_pdb.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/parse_pdb.dir/flags.make

CMakeFiles/parse_pdb.dir/parse_pdb.o: CMakeFiles/parse_pdb.dir/flags.make
CMakeFiles/parse_pdb.dir/parse_pdb.o: ../parse_pdb.cc
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/mnt/c/Users/Dan/pdb-benchmarks/ESBTL/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/parse_pdb.dir/parse_pdb.o"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/parse_pdb.dir/parse_pdb.o -c /mnt/c/Users/Dan/pdb-benchmarks/ESBTL/parse_pdb.cc

CMakeFiles/parse_pdb.dir/parse_pdb.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/parse_pdb.dir/parse_pdb.i"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /mnt/c/Users/Dan/pdb-benchmarks/ESBTL/parse_pdb.cc > CMakeFiles/parse_pdb.dir/parse_pdb.i

CMakeFiles/parse_pdb.dir/parse_pdb.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/parse_pdb.dir/parse_pdb.s"
	/usr/bin/c++ $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /mnt/c/Users/Dan/pdb-benchmarks/ESBTL/parse_pdb.cc -o CMakeFiles/parse_pdb.dir/parse_pdb.s

# Object files for target parse_pdb
parse_pdb_OBJECTS = \
"CMakeFiles/parse_pdb.dir/parse_pdb.o"

# External object files for target parse_pdb
parse_pdb_EXTERNAL_OBJECTS =

parse_pdb: CMakeFiles/parse_pdb.dir/parse_pdb.o
parse_pdb: CMakeFiles/parse_pdb.dir/build.make
parse_pdb: CMakeFiles/parse_pdb.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/mnt/c/Users/Dan/pdb-benchmarks/ESBTL/build/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Linking CXX executable parse_pdb"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/parse_pdb.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/parse_pdb.dir/build: parse_pdb

.PHONY : CMakeFiles/parse_pdb.dir/build

CMakeFiles/parse_pdb.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/parse_pdb.dir/cmake_clean.cmake
.PHONY : CMakeFiles/parse_pdb.dir/clean

CMakeFiles/parse_pdb.dir/depend:
	cd /mnt/c/Users/Dan/pdb-benchmarks/ESBTL/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /mnt/c/Users/Dan/pdb-benchmarks/ESBTL /mnt/c/Users/Dan/pdb-benchmarks/ESBTL /mnt/c/Users/Dan/pdb-benchmarks/ESBTL/build /mnt/c/Users/Dan/pdb-benchmarks/ESBTL/build /mnt/c/Users/Dan/pdb-benchmarks/ESBTL/build/CMakeFiles/parse_pdb.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/parse_pdb.dir/depend

