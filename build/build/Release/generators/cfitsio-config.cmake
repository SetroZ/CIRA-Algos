########## MACROS ###########################################################################
#############################################################################################

# Requires CMake > 3.15
if(${CMAKE_VERSION} VERSION_LESS "3.15")
    message(FATAL_ERROR "The 'CMakeDeps' generator only works with CMake >= 3.15")
endif()

if(cfitsio_FIND_QUIETLY)
    set(cfitsio_MESSAGE_MODE VERBOSE)
else()
    set(cfitsio_MESSAGE_MODE STATUS)
endif()

include(${CMAKE_CURRENT_LIST_DIR}/cmakedeps_macros.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cfitsioTargets.cmake)
include(CMakeFindDependencyMacro)

check_build_type_defined()

foreach(_DEPENDENCY ${cfitsio_FIND_DEPENDENCY_NAMES} )
    # Check that we have not already called a find_package with the transitive dependency
    if(NOT ${_DEPENDENCY}_FOUND)
        find_dependency(${_DEPENDENCY} REQUIRED ${${_DEPENDENCY}_FIND_MODE})
    endif()
endforeach()

set(cfitsio_VERSION_STRING "4.2.0")
set(cfitsio_INCLUDE_DIRS ${cfitsio_INCLUDE_DIRS_RELEASE} )
set(cfitsio_INCLUDE_DIR ${cfitsio_INCLUDE_DIRS_RELEASE} )
set(cfitsio_LIBRARIES ${cfitsio_LIBRARIES_RELEASE} )
set(cfitsio_DEFINITIONS ${cfitsio_DEFINITIONS_RELEASE} )


# Only the last installed configuration BUILD_MODULES are included to avoid the collision
foreach(_BUILD_MODULE ${cfitsio_BUILD_MODULES_PATHS_RELEASE} )
    message(${cfitsio_MESSAGE_MODE} "Conan: Including build module from '${_BUILD_MODULE}'")
    include(${_BUILD_MODULE})
endforeach()


