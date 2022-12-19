set(XDG_ROOT ${CMAKE_BINARY_DIR}/xdg_root)
set(LVIM_XDG_DATA_HOME ${XDG_ROOT}/share)
set(LVIM_XDG_CONFIG_HOME ${XDG_ROOT}/.config)
set(LVIM_XDG_CACHE_HOME ${XDG_ROOT}/.cache)

set(LUNARVIM_RUNTIME_DIR ${LVIM_XDG_DATA_HOME}/lunarvim)
set(LUNARVIM_CONFIG_DIR ${LVIM_XDG_CONFIG_HOME}/lvim)
set(LUNARVIM_CACHE_DIR ${LVIM_XDG_CACHE_HOME}/lvim)

set(LUNARVIM_BASE_DIR ${lvimRepo_SOURCE_DIR})

set(INIT_LUA_PATH ${lvimRepo_SOURCE_DIR}/init.lua)

if(WIN32)
  string(REPLACE "/" "\\" INIT_LUA_PATH "${INIT_LUA_PATH}")
  string(REPLACE "/" "\\" LVIM_XDG_DATA_HOME "${LVIM_XDG_DATA_HOME}")
  string(REPLACE "/" "\\" LVIM_XDG_CONFIG_HOME "${LVIM_XDG_CONFIG_HOME}")
  string(REPLACE "/" "\\" LVIM_XDG_CACHE_HOME "${LVIM_XDG_CACHE_HOME}")
  string(REPLACE "/" "\\" LUNARVIM_RUNTIME_DIR "${LUNARVIM_RUNTIME_DIR}")
  string(REPLACE "/" "\\" LUNARVIM_CONFIG_DIR "${LUNARVIM_CONFIG_DIR}")
  string(REPLACE "/" "\\" LUNARVIM_CACHE_DIR "${LUNARVIM_CACHE_DIR}")
  string(REPLACE "/" "\\" LUNARVIM_BASE_DIR "${LUNARVIM_BASE_DIR}")
endif()

set(ENV{XDG_DATA_HOME} "${XDG_DATA_HOME}")
set(ENV{XDG_CONFIG_HOME} "${XDG_CONFIG_HOME}")
set(ENV{XDG_CACHE_HOME} "${XDG_CACHE_HOME}")
set(ENV{LUNARVIM_RUNTIME_DIR} "${LUNARVIM_RUNTIME_DIR}")
set(ENV{LUNARVIM_CONFIG_DIR} "${LUNARVIM_CONFIG_DIR}")
set(ENV{LUNARVIM_CACHE_DIR} "${LUNARVIM_CACHE_DIR}")
set(ENV{LUNARVIM_BASE_DIR} "${LUNARVIM_BASE_DIR}")

file(REMOVE_RECURSE ${XDG_ROOT})

message("downloading plugins...")
message("nvim -u ${INIT_LUA_PATH} --headless -c autocmd User PackerComplete quitall -c PackerInstall")
execute_process( 
  COMMAND "${CMAKE_BINARY_DIR}/bin/${LVIM_BIN_NAME}" "--headless" "-c" "lua =lvim.plugins" "-c" "autocmd User PackerComplete quitall" "-c" "PackerInstall"
  TIMEOUT 300
  RESULT_VARIABLE exit_code
  OUTPUT_VARIABLE output
  ERROR_VARIABLE stderr
  OUTPUT_STRIP_TRAILING_WHITESPACE)

if(NOT exit_code EQUAL 0 )
  # message(FATAL_ERROR "nvim output: ${exit_code} ${output} ${stderr}")
  message("nvim output: ${exit_code} ${output} ${stderr}")
else()
  message("nvim output: ${exit_code} ${output} ${stderr}")
  message("download complete")
  install(DIRECTORY 
    "$ENV{LUNARVIM_RUNTIME_DIR}/site/pack/packer/"
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/lunarvim/plugins/)
endif()
