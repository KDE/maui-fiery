# Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
# Copyright 2018-2020 Nitrux Latinoamericana S.C.
#
# SPDX-License-Identifier: GPL-3.0-or-later

set(fiery_SRCS
    main.cpp
    models/historymodel.cpp
    controllers/downloadsmanager.cpp
    controllers/dbactions.cpp
    db/db.cpp
    models/downloadsmodel.cpp
    models/recentmodel.cpp
    models/bookmarksmodel.cpp
    controllers/surf.cpp
    controllers/fierywebprofile.cpp
    controllers/qquickwebenginedownloaditem.cpp
)

set(fiery_ASSETS
    assets/img_assets.qrc
)

if(QUICK_COMPILER)
    qtquick_compiler_add_resources(fiery_QML_QRC qml.qrc)
else()
    qt5_add_resources(fiery_QML_QRC qml.qrc)
endif()

add_executable(${PROJECT_NAME}
    ${fiery_SRCS}
    ${fiery_QML_QRC}
    ${fiery_ASSETS})

target_link_libraries(${PROJECT_NAME}
    PRIVATE
    MauiKit
    MauiKit::FileBrowsing
    Qt5::Widgets
    Qt5::WebEngine
    Qt5::Sql
    Qt5::Qml
    KF5::I18n
    KF5::CoreAddons
    Qt5::WebEnginePrivate)
