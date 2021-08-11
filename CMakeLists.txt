cmake_minimum_required(VERSION 3.16)

set(SOL_VERSION 1.0.0)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror")

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

project(sol VERSION ${SOL_VERSION})

set(REQUIRED_QT_VERSION 5.14.0)
set(REQUIRED_KF5_VERSION 5.40.0)

find_package(ECM ${REQUIRED_KF5_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${ECM_MODULE_PATH})

if(UNIX AND NOT APPLE AND NOT ANDROID)
    include(KDEInstallDirs)
    include(KDECMakeSettings)
    include(ECMInstallIcons)
    include(ECMAddAppIcon)
endif()

include(KDECompilerSettings NO_POLICY_SCOPE)
include(KDEClangFormat)
include(ECMSetupVersion)
include(ECMSourceVersionControl)
include(FeatureSummary)
include(ECMQMLModules)

find_package(Qt5 ${REQUIRED_QT_VERSION} REQUIRED NO_MODULE COMPONENTS Widgets Qml Sql WebEngine)
find_package(KF5 ${KF5_VERSION} REQUIRED COMPONENTS I18n CoreAddons)
find_package(MauiKit REQUIRED COMPONENTS FileBrowsing)

if(${ECM_SOURCE_UNDER_VERSION_CONTROL})
execute_process(
  COMMAND git rev-parse --abbrev-ref HEAD
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  OUTPUT_VARIABLE GIT_BRANCH
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

# Get the latest abbreviated commit hash of the working branch
execute_process(
  COMMAND git log -1 --format=%h
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  OUTPUT_VARIABLE GIT_COMMIT_HASH
  OUTPUT_STRIP_TRAILING_WHITESPACE
)

add_definitions(-DGIT_COMMIT_HASH="${GIT_COMMIT_HASH}")
add_definitions(-DGIT_BRANCH="${GIT_BRANCH}")

else()
    add_definitions(-DGIT_COMMIT_HASH="${SOL_VERSION}")
    add_definitions(-DGIT_BRANCH="Stable")
endif()

ecm_setup_version(${SOL_VERSION}
    VARIABLE_PREFIX SOL
    VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/sol_version.h"
    )

add_subdirectory(src)

    install(TARGETS sol ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
    install(FILES org.kde.sol.desktop DESTINATION ${XDG_APPS_INSTALL_DIR})
    install(FILES org.kde.sol.metainfo.xml DESTINATION ${KDE_INSTALL_METAINFODIR})
    #ecm_install_icons(ICONS src/assets/sol.svg DESTINATION share/icons)
    install(FILES src/assets/sol.svg DESTINATION ${KDE_INSTALL_ICONDIR}/hicolor/scalable/apps)

feature_summary(WHAT ALL   FATAL_ON_MISSING_REQUIRED_PACKAGES)
file(GLOB_RECURSE ALL_CLANG_FORMAT_SOURCE_FILES *.cpp *.h)
kde_clang_format(${ALL_CLANG_FORMAT_SOURCE_FILES})
