cmake_minimum_required(VERSION 3.0)
set(SOL_VERSION 1.0.0)
project(sol VERSION ${SOL_VERSION})

find_package(ECM 1.7.0 REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${ECM_MODULE_PATH})

find_package(MauiKit REQUIRED)
find_package(Qt5 REQUIRED NO_MODULE COMPONENTS Qml Sql Svg)
find_package(KF5 ${KF5_VERSION} REQUIRED COMPONENTS I18n Notifications Config KIO Attica SyntaxHighlighting)
include(KDEInstallDirs)
include(KDECompilerSettings NO_POLICY_SCOPE)
include(KDECMakeSettings)
include(ECMInstallIcons)
include(ECMAddAppIcon)
include(ECMSetupVersion)
include(FeatureSummary)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(CMAKE_AUTORCC ON)

set(sol_SRCS
    src/main.cpp
    )

set(sol_HDRS
#    src/sol.h
    )

set(sol_ASSETS
    src/qml.qrc
    src/assets/img_assets.qrc
    )

add_executable(sol
    ${sol_SRCS}
    ${sol_HDRS}
    ${sol_ASSETS}
    )

ecm_setup_version(${SOL_VERSION}
    VARIABLE_PREFIX SOL
    VERSION_HEADER "${CMAKE_CURRENT_BINARY_DIR}/sol_version.h"
    )

if (ANDROID)
    find_package(Qt5 REQUIRED COMPONENTS AndroidExtras WebView)

    target_link_libraries(sol MauiKit Qt5::AndroidExtras)
else()
    find_package(Qt5 REQUIRED COMPONENTS WebEngine)

endif()

target_link_libraries(sol MauiKit Qt5::Sql Qt5::Qml Qt5::Svg  KF5::ConfigCore KF5::Notifications KF5::KIOCore KF5::I18n KF5::Attica)

install(TARGETS sol ${KDE_INSTALL_TARGETS_DEFAULT_ARGS})
install(FILES org.kde.sol.desktop DESTINATION ${XDG_APPS_INSTALL_DIR})
#install(FILES org.kde.sol.appdata.xml DESTINATION ${KDE_INSTALL_METAINFODIR})

#TODO: port to ecm_install_icons()
ecm_install_icons(ICONS src/assets/sol.svg
                  DESTINATION share/icons)

feature_summary(WHAT ALL   FATAL_ON_MISSING_REQUIRED_PACKAGES)
