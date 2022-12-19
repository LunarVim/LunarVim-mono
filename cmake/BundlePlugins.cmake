set(XDG_ROOT ${CMAKE_BINARY_DIR}/xdg_root)
set(ENV{XDG_DATA_HOME} ${XDG_ROOT}/share)
set(ENV{XDG_CONFIG_HOME} ${XDG_ROOT}/.config)
set(ENV{XDG_CACHE_HOME} ${XDG_ROOT}/.cache)

set(ENV{LUNARVIM_RUNTIME_DIR} $ENV{XDG_DATA_HOME}/lunarvim)
set(ENV{LUNARVIM_CONFIG_DIR} $ENV{XDG_CONFIG_HOME}/lvim)
set(ENV{LUNARVIM_CACHE_DIR} $ENV{XDG_CACHE_HOME}/lvim)

set(ENV{LUNARVIM_BASE_DIR} ${lvimRepo_SOURCE_DIR})

file(REMOVE_RECURSE ${XDG_ROOT})

set(INIT_LUA_PATH ${lvimRepo_SOURCE_DIR}/init.lua)

if(WIN32)
  string(REPLACE "/" "\\" INIT_LUA_PATH "${INIT_LUA_PATH}")
  string(REPLACE "/" "\\" ENV{XDG_DATA_HOME} "$ENV{XDG_DATA_HOME}")
  string(REPLACE "/" "\\" ENV{XDG_CONFIG_HOME} "$ENV{XDG_CONFIG_HOME}")
  string(REPLACE "/" "\\" ENV{XDG_CACHE_HOME} "$ENV{XDG_CACHE_HOME}")
  string(REPLACE "/" "\\" ENV{LUNARVIM_RUNTIME_DIR} "$ENV{LUNARVIM_RUNTIME_DIR}")
  string(REPLACE "/" "\\" ENV{LUNARVIM_CONFIG_DIR} "$ENV{LUNARVIM_CONFIG_DIR}")
  string(REPLACE "/" "\\" ENV{LUNARVIM_CACHE_DIR} "$ENV{LUNARVIM_CACHE_DIR}")
  string(REPLACE "/" "\\" ENV{LUNARVIM_BASE_DIR} "$ENV{LUNARVIM_BASE_DIR}")
endif()


message("downloading plugins...")
message("nvim -u ${INIT_LUA_PATH} --headless -c autocmd User PackerComplete quitall -c PackerInstall")
execute_process( 
  COMMAND "nvim" "-u" "${INIT_LUA_PATH}" "--headless" "-c" "autocmd User PackerComplete quitall" "-c" "PackerInstall"
  TIMEOUT 100
  RESULT_VARIABLE exit_code
  OUTPUT_VARIABLE output
  ERROR_VARIABLE stderr
  OUTPUT_STRIP_TRAILING_WHITESPACE)

if(NOT exit_code EQUAL 0 )
  message(FATAL_ERROR "nvim output: ${exit_code} ${output} ${stderr}")
else()
  message("nvim output: ${exit_code} ${output} ${stderr}")
  message("download complete")
  install(DIRECTORY 
    "$ENV{LUNARVIM_RUNTIME_DIR}/site/pack/packer/"
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/lunarvim/plugins/)
endif()


message("nvim -u ${INIT_LUA_PATH} --headless -c autocmd User PackerComplete quitall -c PackerInstall")
execute_process( 
  COMMAND "nvim" "-u" "${INIT_LUA_PATH}" "--headless" "-c" "autocmd User PackerComplete quitall" "-c" "lua print(os.getenv(\"LUNARVIM_BASE_DIR\"))"  "-c" "PackerInstall"
  TIMEOUT 50
  RESULT_VARIABLE exit_code
  OUTPUT_VARIABLE output
  ERROR_VARIABLE stderr
  OUTPUT_STRIP_TRAILING_WHITESPACE)

if(NOT exit_code EQUAL 0 )
  message(FATAL_ERROR "nvim output: ${exit_code} ${output} ${stderr}")
else()
  message("nvim output: ${exit_code} ${output} ${stderr}")
  message("download complete")
  install(DIRECTORY 
    "$ENV{LUNARVIM_RUNTIME_DIR}/site/pack/packer/"
    DESTINATION ${CMAKE_INSTALL_DATAROOTDIR}/lunarvim/plugins/)
endif()
