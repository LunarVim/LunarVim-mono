cmake_minimum_required(VERSION 3.14)

project(lvim C)

if(NOT DEFINED LVIM_BRANCH)
  set(LVIM_BRANCH master)
endif()

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

configure_file(${lvimRepo_SOURCE_DIR}/LICENSE ${CMAKE_BINARY_DIR}/LICENSE.txt)

if(WIN32)
  set(LVIM_BIN_NAME lvim.ps1)
else()
  set(LVIM_BIN_NAME lvim)
endif()

file(READ ${CMAKE_SOURCE_DIR}/bin/${LVIM_BIN_NAME} FILE_CONTENTS)
string(REPLACE "CMAKE_INSTALL_DATAROOTDIR" "${CMAKE_INSTALL_DATAROOTDIR}" FILE_CONTENTS "${FILE_CONTENTS}")
file(WRITE ${CMAKE_BINARY_DIR}/bin/${LVIM_BIN_NAME} "${FILE_CONTENTS}")

install(PROGRAMS ${CMAKE_SOURCE_DIR}/bin/${LVIM_BIN_NAME} DESTINATION ${CMAKE_INSTALL_BINDIR})
install(FILES ${lvimRepo_SOURCE_DIR}/init.lua DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/lunarvim)
install(DIRECTORY 
  ${lvimRepo_SOURCE_DIR}/lua
  ${lvimRepo_SOURCE_DIR}/snapshots 
  DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/lunarvim)

# for backwards compability
if(EXISTS "${lvimRepo_SOURCE_DIR}/ftdetect")
install(DIRECTORY 
  ${lvimRepo_SOURCE_DIR}/ftdetect
  DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/lunarvim)
endif()

add_subdirectory(cmake.packaging)

unset(LVIM_BRANCH CACHE)
