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

qt_add_resources(fiery_ASSETS
    assets/img_assets.qrc
    assets.qrc)

qt_add_executable(${PROJECT_NAME}
    ${fiery_SRCS}
    ${fiery_ASSETS})

qt_add_qml_module(${PROJECT_NAME} URI app.maui.fiery
    NO_PLUGIN
    QML_FILES
    main.qml
    views/widgets/SettingsDialog.qml
    views/browser/BrowserView.qml
    views/history/HistoryView.qml
    views/browser/BrowserLayout.qml
    views/browser/Browser.qml
    views/widgets/NavigationBar.qml
    views/browser/ActionsMenu.qml
    views/home/HomeView.qml
    views/AppView.qml)

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
