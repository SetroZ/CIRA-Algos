########### AGGREGATED COMPONENTS AND DEPENDENCIES FOR THE MULTI CONFIG #####################
#############################################################################################

set(cfitsio_COMPONENT_NAMES "")
if(DEFINED cfitsio_FIND_DEPENDENCY_NAMES)
  list(APPEND cfitsio_FIND_DEPENDENCY_NAMES ZLIB)
  list(REMOVE_DUPLICATES cfitsio_FIND_DEPENDENCY_NAMES)
else()
  set(cfitsio_FIND_DEPENDENCY_NAMES ZLIB)
endif()
set(ZLIB_FIND_MODE "NO_MODULE")

########### VARIABLES #######################################################################
#############################################################################################
set(cfitsio_PACKAGE_FOLDER_RELEASE "/home/vetro/.conan2/p/cfitsc5071a32803f6/p")
set(cfitsio_BUILD_MODULES_PATHS_RELEASE )


set(cfitsio_INCLUDE_DIRS_RELEASE "${cfitsio_PACKAGE_FOLDER_RELEASE}/include")
set(cfitsio_RES_DIRS_RELEASE )
set(cfitsio_DEFINITIONS_RELEASE )
set(cfitsio_SHARED_LINK_FLAGS_RELEASE )
set(cfitsio_EXE_LINK_FLAGS_RELEASE )
set(cfitsio_OBJECTS_RELEASE )
set(cfitsio_COMPILE_DEFINITIONS_RELEASE )
set(cfitsio_COMPILE_OPTIONS_C_RELEASE )
set(cfitsio_COMPILE_OPTIONS_CXX_RELEASE )
set(cfitsio_LIB_DIRS_RELEASE "${cfitsio_PACKAGE_FOLDER_RELEASE}/lib")
set(cfitsio_BIN_DIRS_RELEASE )
set(cfitsio_LIBRARY_TYPE_RELEASE STATIC)
set(cfitsio_IS_HOST_WINDOWS_RELEASE 0)
set(cfitsio_LIBS_RELEASE cfitsio)
set(cfitsio_SYSTEM_LIBS_RELEASE m)
set(cfitsio_FRAMEWORK_DIRS_RELEASE )
set(cfitsio_FRAMEWORKS_RELEASE )
set(cfitsio_BUILD_DIRS_RELEASE )
set(cfitsio_NO_SONAME_MODE_RELEASE FALSE)


# COMPOUND VARIABLES
set(cfitsio_COMPILE_OPTIONS_RELEASE
    "$<$<COMPILE_LANGUAGE:CXX>:${cfitsio_COMPILE_OPTIONS_CXX_RELEASE}>"
    "$<$<COMPILE_LANGUAGE:C>:${cfitsio_COMPILE_OPTIONS_C_RELEASE}>")
set(cfitsio_LINKER_FLAGS_RELEASE
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,SHARED_LIBRARY>:${cfitsio_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,MODULE_LIBRARY>:${cfitsio_SHARED_LINK_FLAGS_RELEASE}>"
    "$<$<STREQUAL:$<TARGET_PROPERTY:TYPE>,EXECUTABLE>:${cfitsio_EXE_LINK_FLAGS_RELEASE}>")


set(cfitsio_COMPONENTS_RELEASE )