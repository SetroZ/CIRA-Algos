########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(ccfits_FIND_QUIETLY)
    set(ccfits_MESSAGE_MODE VERBOSE)
else()
    set(ccfits_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/ccfitsTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${ccfits_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(ccfits_VERSION_STRING "2.6")
set(ccfits_INCLUDE_DIRS ${ccfits_INCLUDE_DIRS_RELEASE} )
set(ccfits_INCLUDE_DIR ${ccfits_INCLUDE_DIRS_RELEASE} )
set(ccfits_LIBRARIES ${ccfits_LIBRARIES_RELEASE} )
set(ccfits_DEFINITIONS ${ccfits_DEFINITIONS_RELEASE} )


# Only the last installed configuration BUILD_MODULES are included to avoid the collision
foreach(_BUILD_MODULE ${ccfits_BUILD_MODULES_PATHS_RELEASE} )
    message(${ccfits_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


