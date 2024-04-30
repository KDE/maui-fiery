# Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
# Copyright 2018-2020 Nitrux Latinoamericana S.C.
#
# SPDX-License-Identifier: GPL-3.0-or-later
remove_definitions(-DQT_NO_CAST_FROM_ASCII -DQT_STRICT_ITERATORS -DQT_NO_CAST_FROM_BYTEARRAY -DQT_NO_URL_CAST_FROM_STRING)

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
    controllers/fierywebprofile.cpp)

set(fiery_ASSETS
    assets/img_assets.qrc)

qt_add_resources(fiery_QML_QRC qml.qrc)

add_executable(${PROJECT_NAME}
    ${fiery_SRCS}
    ${fiery_QML_QRC}
    ${fiery_ASSETS})

target_link_libraries(${PROJECT_NAME}
    PRIVATE
    MauiKit4
    MauiKit4::FileBrowsing
    Qt6::Widgets
    Qt6::Sql
    Qt6::Qml
    KF6::I18n
    KF6::CoreAddons

    Qt::CorePrivate
    Qt::WebEngineCore
    Qt::WebEngineQuick
    Qt::WebEngineQuickPrivate)
