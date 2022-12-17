cmake_minimum_required(VERSION 3.14)

project(lvim C)

set(LVIM_VERSION_MAJOR 1)
set(LVIM_VERSION_MINOR 2)
set(LVIM_VERSION_PATCH 0)

# Fetch LunarVim repo

include(FetchContent)
FetchContent_Declare(
  lvimRepo
  GIT_REPOSITORY https://github.com/LunarVim/LunarVim.git
  GIT_SHALLOW 1
  GIT_TAG master
)
FetchContent_MakeAvailable(lvimRepo)
set(lvimRepo_SOURCE_DIR ${CMAKE_BINARY_DIR}/_deps/lvimrepo-src)

# INSTALL

include(GNUInstallDirs)

configure_file(${lvimRepo_SOURCE_DIR}/LICENSE ${CMAKE_BINARY_DIR}/LICENSE.txt)

if(WIN32)
  file(WRITE ${CMAKE_BINARY_DIR}/bin/lvim.ps1
    "#Requires -Version 7.1\n"
    "$ErrorActionPreference = \"Stop\"\n"
    "$env:XDG_DATA_HOME = $env:XDG_DATA_HOME ?? $env:APPDATA\n"
    "$env:XDG_CONFIG_HOME = $env:XDG_CONFIG_HOME ?? $env:LOCALAPPDATA\n"
    "$env:XDG_CACHE_HOME = $env:XDG_CACHE_HOME ?? $env:TEMP\n"
    "$env:LUNARVIM_RUNTIME_DIR = $env:LUNARVIM_RUNTIME_DIR ?? \"$env:XDG_DATA_HOME\\lunarvim\"\n"
    "$env:LUNARVIM_CONFIG_DIR = $env:LUNARVIM_CONFIG_DIR ?? \"$env:XDG_CONFIG_HOME\\lvim\"\n"
    "$env:LUNARVIM_CACHE_DIR = $env:LUNARVIM_CACHE_DIR ?? \"$env:XDG_CACHE_HOME\\lvim\"\n"
    "$env:LUNARVIM_BASE_DIR = $env:LUNARVIM_BASE_DIR ?? $(Resolve-Path \"$PSScriptRoot\\..\\${CMAKE_INSTALL_DATAROOTDIR}\\lunarvim\")\n"
    "nvim -u \"$env:LUNARVIM_BASE_DIR\\init.lua\" @args\n")

  install(PROGRAMS ${CMAKE_BINARY_DIR}/bin/lvim.ps1 DESTINATION ${CMAKE_INSTALL_BINDIR})
else()
  file(WRITE ${CMAKE_BINARY_DIR}/bin/lvim
    "#!/usr/bin/env bash\n"
    "XDG_DATA_HOME=\"\${XDG_DATA_HOME:-\"$HOME/.local/share\"}\"\n"
    "XDG_CONFIG_HOME=\"\${XDG_CONFIG_HOME:-\"$HOME/.config\"}\"\n"
    "XDG_CACHE_HOME=\"\${XDG_CACHE_HOME:-\"$HOME/.cache\"}\"\n"
    "export LUNARVIM_RUNTIME_DIR=\"\${LUNARVIM_RUNTIME_DIR:-\"$XDG_DATA_HOME/lunarvim\"}\"\n"
    "export LUNARVIM_CONFIG_DIR=\"\${LUNARVIM_CONFIG_DIR:-\"$XDG_CONFIG_HOME/lvim\"}\"\n"
    "export LUNARVIM_CACHE_DIR=\"\${LUNARVIM_CACHE_DIR:-\"$XDG_CACHE_HOME/lvim\"}\"\n"
    "ROOT_DIR=$(readlink -f \"$(dirname $(realpath \"$0\"))/..\")\n"
    "export LUNARVIM_BASE_DIR=\"\${LUNARVIM_BASE_DIR:-$\"$ROOT_DIR/${CMAKE_INSTALL_DATAROOTDIR}/lunarvim\"}\"\n"
    "exec -a lvim nvim -u \"$LUNARVIM_BASE_DIR/init.lua\" \"$@\"\n")

  install(PROGRAMS ${CMAKE_BINARY_DIR}/bin/lvim DESTINATION ${CMAKE_INSTALL_BINDIR})
endif()

install(FILES ${lvimRepo_SOURCE_DIR}/init.lua DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/lunarvim)
install(DIRECTORY 
  ${lvimRepo_SOURCE_DIR}/lua
  ${lvimRepo_SOURCE_DIR}/ftdetect
  ${lvimRepo_SOURCE_DIR}/snapshots 
  DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/lunarvim)

add_subdirectory(cmake.packaging)
