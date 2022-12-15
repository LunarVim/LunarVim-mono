set(CPACK_VERBATIM_VARIABLES TRUE)
set(CPACK_RESOURCE_FILE_LICENSE ${CMAKE_BINARY_DIR}/LICENSE.txt)
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "An IDE layer for Neovim with sane defaults. Completely free and community driven.")

set(CPACK_PACKAGE_VERSION_MAJOR ${LVIM_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR ${LVIM_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH ${LVIM_VERSION_PATCH})

if(WIN32)
  set(CPACK_PACKAGE_FILE_NAME "lvim-win64")
  set(CPACK_GENERATOR ZIP WIX)

  # WIX
  # CPACK_WIX_UPGRADE_GUID should be set, but should never change.
  # CPACK_WIX_PRODUCT_GUID should not be set (leave as default to auto-generate).

  # The following guid is just a randomly generated guid that's been pasted here.
  # It has no special meaning other than to supply it to WIX.
  set(CPACK_WIX_UPGRADE_GUID "f11fd72c-36ed-4f9d-8eff-dbf0aec7e981")
  set(CPACK_WIX_PRODUCT_ICON ${CMAKE_CURRENT_LIST_DIR}/lvim.ico)

  # We use a wix patch to add further options to the installer. At present, it's just to add lvim to the path
  # on installation, however, it can be extended.
  # See: https://cmake.org/cmake/help/v3.7/module/CPackWIX.html#variable:CPACK_WIX_PATCH_FILE
  list(APPEND CPACK_WIX_EXTENSIONS WixUtilExtension)
  list(APPEND CPACK_WIX_PATCH_FILE ${CMAKE_CURRENT_LIST_DIR}/WixPatch.xml)
elseif(APPLE)
  set(CPACK_PACKAGE_FILE_NAME "lvim-macos")
  set(CPACK_GENERATOR TGZ)
  set(CPACK_PACKAGE_ICON ${CMAKE_CURRENT_LIST_DIR}/lvim.icns)
elseif(CMAKE_SYSTEM_NAME STREQUAL "Linux")
  set(CPACK_PACKAGE_FILE_NAME "lvim-linux64")
  set(CPACK_GENERATOR TGZ DEB)
  set(CPACK_DEBIAN_PACKAGE_NAME "Lunarvim") # required
  set(CPACK_DEBIAN_PACKAGE_MAINTAINER "lunarvim.org") # required
else()
  set(CPACK_GENERATOR TGZ)
endif()

include(CPack)
