
MACRO(SUBDIRLIST result curdir)
	FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
	SET(dirlist "")
	FOREACH(child ${children})
		IF(IS_DIRECTORY ${curdir}/${child})
			LIST(APPEND dirlist ${child})
		ENDIF()
	ENDFOREACH()
	SET(${result} ${dirlist})
ENDMACRO()

SUBDIRLIST(SUBDIRS "${CMAKE_CURRENT_SOURCE_DIR}")
string(REGEX REPLACE "CMakeFiles;" "" SUBDIRS "${SUBDIRS}")

FOREACH(subdir ${SUBDIRS})
	if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/cmake.conf")
		set(${subdir}_build_dir "${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/build_dir")
		file(MAKE_DIRECTORY ${${subdir}_build_dir})

		include(${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/cmake.conf)

		set(${subdir}_downloaded_target ${CMAKE_SOURCE_DIR}/download/${subdir}-${${subdir}_version}*)
		add_custom_target(${subdir}_download COMMAND /bin/bash -c \"if ! ls ${${subdir}_downloaded_target} &>/dev/null\; then wget ${${subdir}_download_url}\; fi\"
			WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/download
		)

		if(NOT DEFINED ${subdir}_extract_command)
			set(${subdir}_extract_command tar -zxf ${${subdir}_downloaded_target})
		endif()
		add_custom_target(${subdir}_extract COMMAND /bin/bash -c \"[ -d '${subdir}-${${subdir}_version}' ] || ${${subdir}_extract_command}\"
			WORKING_DIRECTORY ${${subdir}_build_dir}
			DEPENDS ${subdir}_download
		)

		FILE(GLOB ${subdir}_patch_files ${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/patches/*)
		add_custom_target(${subdir}_patch COMMAND if test -f '../.patch.done'\; then exit 0\; fi\; cd ${${subdir}_build_dir}/${subdir}-${${subdir}_version} && for p in `ls ${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/patches/`\; do echo \$\$p && patch < ${CMAKE_CURRENT_SOURCE_DIR}/${subdir}/patches/\$\$p\; done && touch ../.patch.done
			WORKING_DIRECTORY ${${subdir}_build_dir}/${subdir}-${${subdir}_version}	
			DEPENDS ${subdir}_extract
		)

		add_custom_target(${subdir}_configure COMMAND /bin/bash -c \"[ -f '../.configure.done' ] && exit 0 ||  ${SETUP_COMMAND}\; ${${subdir}_configure_command} && touch ../.configure.done\"
			WORKING_DIRECTORY ${${subdir}_build_dir}/${subdir}-${${subdir}_version}
			DEPENDS ${subdir}_patch
		)

		if(NOT DEFINED ${subdir}_build_command)
			set(${subdir}_build_command make)
		endif()
		add_custom_target(${subdir}_build COMMAND /bin/bash -c \"[ -f '../.build.done' ] && exit 0 || ${SETUP_COMMAND}\; ${${subdir}_build_command} && touch ../.build.done\"
			WORKING_DIRECTORY ${${subdir}_build_dir}/${subdir}-${${subdir}_version}
			DEPENDS ${subdir}_configure
		)

		if(NOT DEFINED ${subdir}_install_command)
			set(${subdir}_install_command make install DESTDIR=${CMAKE_SOURCE_DIR}/target)
		endif()
		add_custom_target(${subdir}_install COMMAND /bin/bash -c \"[ -f "../.install.done" ] && exit 0 || ${SETUP_COMMAND}\; ${${subdir}_install_command} && touch ../.install.done \"
			WORKING_DIRECTORY ${${subdir}_build_dir}/${subdir}-${${subdir}_version}
			DEPENDS ${subdir}_build
		)

		add_dependencies(${subdir} ${subdir}_install)
	endif()
ENDFOREACH()

add_custom_target(everything ALL DEPENDS ruby)