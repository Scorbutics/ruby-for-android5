
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

		set(${subdir}_downloaded_target ${CMAKE_SOURCE_DIR}/download/${subdir}-${${subdir}_version}.tar.gz)
		add_custom_target(${subdir}_download COMMAND [ -f "${${subdir}_downloaded_target}" ] || wget ${${subdir}_download_url}
			WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/download
		)

		add_custom_target(${subdir}_extract COMMAND [ -d "${subdir}-${${subdir}_version}" ] || tar -zxf ${${subdir}_downloaded_target}
			WORKING_DIRECTORY ${${subdir}_build_dir}
			DEPENDS ${subdir}_download
		)

		add_custom_target(${subdir}_configure COMMAND [ ! -f "${${subdir}_build_dir}/.configure.done" ] || ${SETUP_COMMAND} && ${${subdir}_configure_command} && touch ${${subdir}_build_dir}/.configure.done
			WORKING_DIRECTORY ${${subdir}_build_dir}/${subdir}-${${subdir}_version}
			DEPENDS ${subdir}_extract
		)

		if(NOT DEFINED ${subdir}_build_command)
			set(${subdir}_build_command make)
		endif()
		add_custom_target(${subdir}_build COMMAND [ ! -f "${${subdir}_build_dir}/.build.done" ] || ${SETUP_COMMAND} && ${${subdir}_build_command} && touch ${${subdir}_build_dir}/.build.done
			WORKING_DIRECTORY ${${subdir}_build_dir}/${subdir}-${${subdir}_version}
			DEPENDS ${subdir}_configure
		)

		if(NOT DEFINED ${subdir}_install_command)
			set(${subdir}_install_command make install DESTDIR=${CMAKE_SOURCE_DIR}/target)
		endif()
		add_custom_target(${subdir}_install COMMAND [ ! -f "${${subdir}_build_dir}/.install.done" ] || ${SETUP_COMMAND} && ${${subdir}_install_command} && touch ${${subdir}_build_dir}/.install.done
			WORKING_DIRECTORY ${${subdir}_build_dir}/${subdir}-${${subdir}_version}
			DEPENDS ${subdir}_build
		)

		add_dependencies(${subdir} ${subdir}_install)
	endif()
ENDFOREACH()

add_custom_target(everything ALL DEPENDS gdbm)