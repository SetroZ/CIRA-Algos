########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(ccfits_COMPONENT_NAMES "")
if(DEFINED ccfits_FIND_DEPENDENCY_NAMES)
  list(APPEND ccfits_FIND_DEPENDENCY_NAMES cfitsio)
  list(REMOVE_DUPLICATES ccfits_FIND_DEPENDENCY_NAMES)
else()
  set(ccfits_FIND_DEPENDENCY_NAMES cfitsio)
endif()
set(cfitsio_FIND_MODE "NO_MODULE")

########### VARIABLES #######################################################################
#############################################################################################
set(ccfits_PACKAGE_FOLDER_RELEASE "/home/vetro/.conan2/p/ccfit3a0cffadf7543/p")
set(ccfits_BUILD_MODULES_PATHS_RELEASE )


set(ccfits_INCLUDE_DIRS_RELEASE "${ccfits_PACKAGE_FOLDER_RELEASE}/include")
set(ccfits_RES_DIRS_RELEASE )
set(ccfits_DEFINITIONS_RELEASE )
set(ccfits_SHARED_LINK_FLAGS_RELEASE )
set(ccfits_EXE_LINK_FLAGS_RELEASE )
set(ccfits_OBJECTS_RELEASE )
set(ccfits_COMPILE_DEFINITIONS_RELEASE )
set(ccfits_COMPILE_OPTIONS_C_RELEASE )
set(ccfits_COMPILE_OPTIONS_CXX_RELEASE )
set(ccfits_LIB_DIRS_RELEASE "${ccfits_PACKAGE_FOLDER_RELEASE}/lib")
set(ccfits_BIN_DIRS_RELEASE )
set(ccfits_LIBRARY_TYPE_RELEASE STATIC)
set(ccfits_IS_HOST_WINDOWS_RELEASE 0)
set(ccfits_LIBS_RELEASE CCfits)
set(ccfits_SYSTEM_LIBS_RELEASE )
set(ccfits_FRAMEWORK_DIRS_RELEASE )
set(ccfits_FRAMEWORKS_RELEASE )
set(ccfits_BUILD_DIRS_RELEASE )
set(ccfits_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(ccfits_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${ccfits_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${ccfits_COMPILE_OPTIONS_C_RELEASE}>")
set(ccfits_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${ccfits_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${ccfits_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${ccfits_EXE_LINK_FLAGS_RELEASE}>")


set(ccfits_COMPONENTS_RELEASE )