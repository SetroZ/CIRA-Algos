# Load the debug and release variables
file(GLOB DATA_FILES "${CMAKE_CURRENT_LIST_DIR}/cfitsio-*-data.cmake")

foreach(f ${DATA_FILES})
    include(${f})
endforeach()

# Create the targets for all the components
foreach(_COMPONENT ${cfitsio_COMPONENT_NAMES} )
    if(NOT TARGET ${_COMPONENT})
        add_library(${_COMPONENT} INTERFACE IMPORTED)
        message(${cfitsio_MESSAGE_MODE} "Conan: Component target declared '${_COMPONENT}'")
    endif()
endforeach()

if(NOT TARGET cfitsio::cfitsio)
    add_library(cfitsio::cfitsio INTERFACE IMPORTED)
    message(${cfitsio_MESSAGE_MODE} "Conan: Target declared 'cfitsio::cfitsio'")
endif()
# Load the debug and release library finders
file(GLOB CONFIG_FILES "${CMAKE_CURRENT_LIST_DIR}/cfitsio-Target-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()