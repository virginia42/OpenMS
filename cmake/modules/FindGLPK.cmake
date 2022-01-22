# Taken from lemon library  
# https://lemon.cs.elte.hu/trac/lemon
# License: Boost Software License, Version 1.0

set(GLPK_ROOT_DIR "" CACHE PATH "GLPK root directory")

set(GLPK_REGKEY "[HKEY_LOCAL_MACHINE\\SOFTWARE\\GnuWin32\\Glpk;InstallPath]")
get_filename_component(GLPK_ROOT_PATH ${GLPK_REGKEY} ABSOLUTE)

find_path(GLPK_INCLUDE_DIR
  glpk.h
  PATHS ${GLPK_REGKEY}/include
  HINTS ${GLPK_ROOT_DIR}/include
)

if (NOT GLPK_LIBRARIES)
	# find library and (optionally) the corresponding debug version
	find_library(GLPK_LIBRARY_RELEASE
		glpk
		PATHS ${GLPK_REGKEY}/lib
		HINTS ${GLPK_ROOT_DIR}/lib
	)

	find_library(GLPK_LIBRARY_DEBUG
		glpkd
		PATHS ${GLPK_REGKEY}/lib
		HINTS ${GLPK_ROOT_DIR}/lib
	)

	include(${CMAKE_CURRENT_LIST_DIR}/SelectLibraryConfigurations.cmake)
	SELECT_LIBRARY_CONFIGURATIONS(GLPK)
endif()

if(GLPK_INCLUDE_DIR AND GLPK_LIBRARY)
  file(READ ${GLPK_INCLUDE_DIR}/glpk.h GLPK_GLPK_H)

  string(REGEX MATCH "define[ ]+GLP_MAJOR_VERSION[ ]+[0-9]+" GLPK_MAJOR_VERSION_LINE "${GLPK_GLPK_H}")
  string(REGEX REPLACE "define[ ]+GLP_MAJOR_VERSION[ ]+([0-9]+)" "\\1" GLPK_VERSION_MAJOR "${GLPK_MAJOR_VERSION_LINE}")

  string(REGEX MATCH "define[ ]+GLP_MINOR_VERSION[ ]+[0-9]+" GLPK_MINOR_VERSION_LINE "${GLPK_GLPK_H}")
  string(REGEX REPLACE "define[ ]+GLP_MINOR_VERSION[ ]+([0-9]+)" "\\1" GLPK_VERSION_MINOR "${GLPK_MINOR_VERSION_LINE}")

  set(GLPK_VERSION_STRING "${GLPK_VERSION_MAJOR}.${GLPK_VERSION_MINOR}")

  if(GLPK_FIND_VERSION)
    if(GLPK_FIND_VERSION_COUNT GREATER 2)
      message(SEND_ERROR "unexpected version string")
    endif(GLPK_FIND_VERSION_COUNT GREATER 2)

    math(EXPR GLPK_REQUESTED_VERSION "${GLPK_FIND_VERSION_MAJOR}*100 + ${GLPK_FIND_VERSION_MINOR}")
    math(EXPR GLPK_FOUND_VERSION "${GLPK_VERSION_MAJOR}*100 + ${GLPK_VERSION_MINOR}")

    if(GLPK_FOUND_VERSION LESS GLPK_REQUESTED_VERSION)
      set(GLPK_PROPER_VERSION_FOUND FALSE)
    else(GLPK_FOUND_VERSION LESS GLPK_REQUESTED_VERSION)
      set(GLPK_PROPER_VERSION_FOUND TRUE)
    endif(GLPK_FOUND_VERSION LESS GLPK_REQUESTED_VERSION)
  else(GLPK_FIND_VERSION)
    set(GLPK_PROPER_VERSION_FOUND TRUE)
  endif(GLPK_FIND_VERSION)
endif(GLPK_INCLUDE_DIR AND GLPK_LIBRARY)



INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(GLPK DEFAULT_MSG GLPK_LIBRARY GLPK_INCLUDE_DIR GLPK_PROPER_VERSION_FOUND)

if(GLPK_FOUND)
  set(GLPK_INCLUDE_DIRS ${GLPK_INCLUDE_DIR})
  set(GLPK_LIBRARIES ${GLPK_LIBRARY})
  set(GLPK_BIN_DIR ${GLPK_ROOT_PATH}/bin)
  if(NOT TARGET GLPK::GLPK)
    add_library(GLPK::GLPK UNKNOWN IMPORTED) # TODO we could try to infer shared/static
    set_property(TARGET GLPK::GLPK PROPERTY IMPORTED_LOCATION "${GLPK_LIBRARY_RELEASE}")
    if(GLPK_LIBRARY_DEBUG)
      set_property(TARGET GLPK::GLPK PROPERTY IMPORTED_LOCATION_DEBUG "${GLPK_LIBRARY_DEBUG}")
    endif()
    set_property(TARGET GLPK::GLPK PROPERTY INCLUDE_DIRECTORIES "${GLPK_INCLUDE_DIR}")
    set_property(TARGET GLPK::GLPK PROPERTY INTERFACE_INCLUDE_DIRECTORIES "${GLPK_INCLUDE_DIR}")
  endif()
endif(GLPK_FOUND)

MARK_AS_ADVANCED(GLPK_LIBRARY GLPK_INCLUDE_DIR GLPK_BIN_DIR)
