
macro(Git)
  execute_process(COMMAND
    git ${ARGV}
    WORKING_DIRECTORY "${lvimRepo_SOURCE_DIR}"
    RESULT_VARIABLE exit_code
    OUTPUT_VARIABLE output
    ERROR_VARIABLE stderr
    OUTPUT_STRIP_TRAILING_WHITESPACE)
  if(NOT exit_code EQUAL 0 )
    message(FATAL_ERROR "${stderr} (${GIT_EXECUTABLE} ${ARGV})")
  endif()
endmacro()

Git(log --pretty=format:%h -1)
set(COMMIT_SHA ${output})

if(NOT DEFINED TAG_NAME AND DEFINED ENV{TAG_NAME})
  set(TAG_NAME $ENV{TAG_NAME})
endif()
if(NOT DEFINED TAG_NAME OR TAG_NAME STREQUAL "master")
  Git(tag --sort=refname -l "*.*.*[0-9]")
  set(TAG_NAME "${output}")
  string(REGEX REPLACE "^.*\n" "" TAG_NAME "${TAG_NAME}")
endif()

string(REPLACE "." ";" TAG_LIST ${TAG_NAME})

list(GET TAG_LIST 0 LVIM_VERSION_MAJOR)
list(GET TAG_LIST 1 LVIM_VERSION_MINOR)
list(GET TAG_LIST 2 LVIM_VERSION_PATCH)


if(LVIM_BRANCH STREQUAL "master")
  set(LVIM_VERSION_PRERELEASE "-dev")
else()
  set(LVIM_VERSION_PRERELEASE "")
endif()

set(LVIM_VERSION "${LVIM_BRANCH}/${COMMIT_SHA}")
set(LVIM_SEM_VERSION "${TAG_NAME}${LVIM_VERSION_PRERELEASE}+${COMMIT_SHA}")
message("LVIM_VERSION: tag:${TAG_NAME} version:${LVIM_VERSION} sem:${LVIM_SEM_VERSION}")

file(WRITE "${CMAKE_BINARY_DIR}/version.txt" "${LVIM_VERSION}")
file(WRITE "${CMAKE_BINARY_DIR}/sem_version.txt" "${LVIM_SEM_VERSION}")
