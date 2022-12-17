
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

Git(describe --abbrev=0 --tags)
set(LATEST_TAG ${output})

string(REPLACE "." ";" TAG_LIST ${LATEST_TAG})

list(GET TAG_LIST 0 LVIM_VERSION_MAJOR)
list(GET TAG_LIST 0 LVIM_VERSION_MINOR)
list(GET TAG_LIST 0 LVIM_VERSION_PATCH)

set(LVIM_VERSION "${LVIM_BRANCH}/${COMMIT_SHA}")
message("LVIM_VERSION: ${LVIM_VERSION}")
