#set(Boost_DEBUG "ON")
#find_package(Boost 1.65.1 REQUIRED PATHS ${CONDA_PREFIX})

message( STATUS "Boost_INCLUDE_DIRS:         " ${Boost_INCLUDE_DIRS} )

#GIT_VERSION_STRING:=$(shell echo -n '"'`git describe --always --dirty`'"')
add_custom_command (OUTPUT ${CMAKE_CURRENT_SOURCE_DIR}/git_version_string.h
                    COMMAND echo "#ifndef GIT_VERSION_STRING_H" >  ${CMAKE_CURRENT_SOURCE_DIR}/git_version_string.h
                    COMMAND echo "#define GIT_VERSION_STRING_H" >> ${CMAKE_CURRENT_SOURCE_DIR}/git_version_string.h
                    COMMAND echo "#define GIT_VERSION_STRING \"R3.5.4\"" >> ${CMAKE_CURRENT_SOURCE_DIR}/git_version_string.h
                    COMMAND echo "#endif" >> ${CMAKE_CURRENT_SOURCE_DIR}/git_version_string.h
                    COMMENT "Creating git version header ${CMAKE_CURRENT_SOURCE_DIR}"
                    VERBATIM)

add_custom_target (cpsw_ver ALL DEPENDS ${CMAKE_CURRENT_SOURCE_DIR}/git_version_string.h)

add_library(cpsw SHARED
    cpsw_buf.cc
    cpsw_bufq.cc
    cpsw_comm_addr.cc
    cpsw_command.cc
    cpsw_const_sval.cc
    cpsw_entry_adapt.cc
    cpsw_entry.cc
    cpsw_enum.cc
    cpsw_event.cc
    cpsw_hub.cc
    cpsw_mem_dev.cc
    cpsw_mmio_dev.cc
    cpsw_netio_dev.cc
    cpsw_obj_cnt.cc
    cpsw_path.cc
    cpsw_preproc.cc
    cpsw_proto_mod.cc
    cpsw_proto_mod_depack.cc
    cpsw_proto_mod_rssi.cc
    cpsw_proto_mod_srpmux.cc
    cpsw_proto_mod_tcp.cc
    cpsw_proto_mod_tdestmux.cc
    cpsw_proto_mod_udp.cc
    cpsw_proto_stack_builder.cc
    #cpsw_python.cc
    cpsw_rssi.cc
    cpsw_rssi_proto.cc
    cpsw_rssi_states.cc
    cpsw_rssi_timer.cc
    cpsw_sock.cc
    cpsw_srp_addr.cc
    cpsw_stream_adapt.cc
    cpsw_sval.cc
    cpsw_thread.cc
    cpsw_version.cc
    cpsw_yaml.cc
    #cpsw_yaml_xpand.cc
    #cpsw_ypp.cc
)

target_include_directories(cpsw PUBLIC
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/src>
    ${CMAKE_INSTALL_PREFIX}/include
    #${Boost_INCLUDE_DIRS}
)

#target_link_libraries(cpsw
#    #${Boost_LIBRARIES}
#    yaml-cpp
#)

message( STATUS "PREFIX:         " ${CMAKE_INSTALL_PREFIX} )

install(TARGETS cpsw
        DESTINATION lib)

install(DIRECTORY . DESTINATION include
        FILES_MATCHING PATTERN "*.h")
