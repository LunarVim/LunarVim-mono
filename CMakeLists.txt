cmake_minimum_required(VERSION 3.14)

project(lvim C)

if(NOT DEFINED LVIM_BRANCH AND DEFINED ENV{LVIM_BRANCH})
  set(LVIM_BRANCH $ENV{LVIM_BRANCH})
endif()
if(NOT DEFINED LVIM_BRANCH OR "${LVIM_BRANCH}" STREQUAL "")
  set(LVIM_BRANCH master)
endif()

message("LVIM_BRANCH: ${LVIM_BRANCH}")

# Fetch LunarVim repo
include(FetchContent)
Set(FETCHCONTENT_QUIET FALSE)
FetchContent_Declare(
  lvimRepo
  GIT_REPOSITORY https://github.com/LunarVim/LunarVim.git
  GIT_TAG ${LVIM_BRANCH}
  GIT_PROGRESS TRUE
)
FetchContent_MakeAvailable(lvimRepo)
set(lvimRepo_SOURCE_DIR ${CMAKE_BINARY_DIR}/_deps/lvimrepo-src)

include(cmake/GetVersion.cmake)

# INSTALL

include(GNUInstallDirs)

# create and install lvim shim

if(PACKAGE_FOR_WINDOWS OR WIN32)
  set(LVIM_BIN_NAME lvim.ps1)
else()
  set(LVIM_BIN_NAME lvim)
endif()

file(READ ${CMAKE_SOURCE_DIR}/bin/${LVIM_BIN_NAME} FILE_CONTENTS)
string(REPLACE "CMAKE_INSTALL_DATAROOTDIR" "${CMAKE_INSTALL_DATAROOTDIR}" FILE_CONTENTS "${FILE_CONTENTS}")
file(WRITE ${CMAKE_BINARY_DIR}/bin/${LVIM_BIN_NAME} "${FILE_CONTENTS}")

install(PROGRAMS ${CMAKE_BINARY_DIR}/bin/${LVIM_BIN_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})

# install the rest of the files
install(FILES ${lvimRepo_SOURCE_DIR}/init.lua DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/lunarvim)
install(DIRECTORY 
  ${lvimRepo_SOURCE_DIR}/lua
  ${lvimRepo_SOURCE_DIR}/utils
  ${lvimRepo_SOURCE_DIR}/snapshots 
  DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/lunarvim
  PATTERN "lua/lvim/utils/git.lua" EXCLUDE)

# install desktop file
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
  install(
    FILES ${lvimRepo_SOURCE_DIR}/utils/desktop/lvim.desktop
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/applications)
  install(
    FILES ${lvimRepo_SOURCE_DIR}/utils/desktop/48x48/lvim.svg
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/48x48/apps)
  install(
    FILES ${lvimRepo_SOURCE_DIR}/utils/desktop/64x64/lvim.svg
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/scalable/apps)
  install(
    FILES ${CMAKE_SOURCE_DIR}/cmake.packaging/lvim.png
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/icons/hicolor/256x256/apps)
endif()

# bake the lvim version into the code  TODO: find a better way to do this
file(READ ${lvimRepo_SOURCE_DIR}/lua/lvim/utils/git.lua FILE_CONTENTS)
string(REPLACE 
  "local current_branch = M.get_lvim_branch()"
  "local current_branch = \"${LVIM_VERSION}\"
  if true then
    return current_branch
  end"
  FILE_CONTENTS "${FILE_CONTENTS}")
file(WRITE ${CMAKE_BINARY_DIR}/git.lua "${FILE_CONTENTS}")
install(FILES 
  ${CMAKE_BINARY_DIR}/git.lua
  DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/lunarvim/lua/lvim/utils/)

if(BUNDLE_PLUGINS OR NOT DEFINED BUNDLE_PLUGINS)
  include(cmake/BundlePlugins.cmake)
endif()

add_subdirectory(cmake.packaging)

unset(LVIM_BRANCH CACHE)
