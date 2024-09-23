# Avoid multiple calls to find_package to append duplicated properties to the targets
include_guard()########### VARIABLES #######################################################################
#############################################################################################
set(cfitsio_FRAMEWORKS_FOUND_RELEASE "") # Will be filled later
conan_find_apple_frameworks(cfitsio_FRAMEWORKS_FOUND_RELEASE "${cfitsio_FRAMEWORKS_RELEASE}" "${cfitsio_FRAMEWORK_DIRS_RELEASE}")

set(cfitsio_LIBRARIES_TARGETS "") # Will be filled later


######## Create an interface target to contain all the dependencies (frameworks, system and conan deps)
if(NOT TARGET cfitsio_DEPS_TARGET)
    add_library(cfitsio_DEPS_TARGET INTERFACE IMPORTED)
endif()

set_property(TARGET cfitsio_DEPS_TARGET
             APPEND PROPERTY INTERFACE_LINK_LIBRARIES
             $<$<CONFIG:Release>:${cfitsio_FRAMEWORKS_FOUND_RELEASE}>
             $<$<CONFIG:Release>:${cfitsio_SYSTEM_LIBS_RELEASE}>
             $<$<CONFIG:Release>:ZLIB::ZLIB>)

####### Find the libraries declared in cpp_info.libs, create an IMPORTED target for each one and link the
####### cfitsio_DEPS_TARGET to all of them
conan_package_library_targets("${cfitsio_LIBS_RELEASE}"    # libraries
                              "${cfitsio_LIB_DIRS_RELEASE}" # package_libdir
                              "${cfitsio_BIN_DIRS_RELEASE}" # package_bindir
                              "${cfitsio_LIBRARY_TYPE_RELEASE}"
                              "${cfitsio_IS_HOST_WINDOWS_RELEASE}"
                              cfitsio_DEPS_TARGET
                              cfitsio_LIBRARIES_TARGETS  # out_libraries_targets
                              "_RELEASE"
                              "cfitsio"    # package_name
                              "${cfitsio_NO_SONAME_MODE_RELEASE}")  # soname

# FIXME: What is the result of this for multi-config? All configs adding themselves to path?
set(CMAKE_MODULE_PATH ${cfitsio_BUILD_DIRS_RELEASE} ${CMAKE_MODULE_PATH})

########## GLOBAL TARGET PROPERTIES Release ########################################
    set_property(TARGET cfitsio::cfitsio
                 APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                 $<$<CONFIG:Release>:${cfitsio_OBJECTS_RELEASE}>
                 $<$<CONFIG:Release>:${cfitsio_LIBRARIES_TARGETS}>
                 )

    if("${cfitsio_LIBS_RELEASE}" STREQUAL "")
        # If the package is not declaring any "cpp_info.libs" the package deps, system libs,
        # frameworks etc are not linked to the imported targets and we need to do it to the
        # global target
        set_property(TARGET cfitsio::cfitsio
                     APPEND PROPERTY INTERFACE_LINK_LIBRARIES
                     cfitsio_DEPS_TARGET)
    endif()

    set_property(TARGET cfitsio::cfitsio
                 APPEND PROPERTY INTERFACE_LINK_OPTIONS
                 $<$<CONFIG:Release>:${cfitsio_LINKER_FLAGS_RELEASE}>)
    set_property(TARGET cfitsio::cfitsio
                 APPEND PROPERTY INTERFACE_INCLUDE_DIRECTORIES
                 $<$<CONFIG:Release>:${cfitsio_INCLUDE_DIRS_RELEASE}>)
    # Necessary to find LINK shared libraries in Linux
    set_property(TARGET cfitsio::cfitsio
                 APPEND PROPERTY INTERFACE_LINK_DIRECTORIES
                 $<$<CONFIG:Release>:${cfitsio_LIB_DIRS_RELEASE}>)
    set_property(TARGET cfitsio::cfitsio
                 APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS
                 $<$<CONFIG:Release>:${cfitsio_COMPILE_DEFINITIONS_RELEASE}>)
    set_property(TARGET cfitsio::cfitsio
                 APPEND PROPERTY INTERFACE_COMPILE_OPTIONS
                 $<$<CONFIG:Release>:${cfitsio_COMPILE_OPTIONS_RELEASE}>)

########## For the modules (FindXXX)
set(cfitsio_LIBRARIES_RELEASE cfitsio::cfitsio)
