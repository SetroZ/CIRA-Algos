# Load the debug and release variables
file(GLOB DATA_FILES "${CMAKE_CURRENT_LIST_DIR}/ccfits-*-data.cmake")

foreach(f ${DATA_FILES})
    include(${f})
endforeach()

# Create the targets for all the components
foreach(_COMPONENT ${ccfits_COMPONENT_NAMES} )
    if(NOT TARGET ${_COMPONENT})
        add_library(${_COMPONENT} INTERFACE IMPORTED)
        message(${ccfits_MESSAGE_MODE} "Conan: Component target declared '${_COMPONENT}'")
    endif()
endforeach()

if(NOT TARGET ccfits::ccfits)
    add_library(ccfits::ccfits INTERFACE IMPORTED)
    message(${ccfits_MESSAGE_MODE} "Conan: Target declared 'ccfits::ccfits'")
endif()
# Load the debug and release library finders
file(GLOB CONFIG_FILES "${CMAKE_CURRENT_LIST_DIR}/ccfits-Target-*.cmake")

foreach(f ${CONFIG_FILES})
    include(${f})
endforeach()