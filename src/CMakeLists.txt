# Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
# Copyright 2018-2020 Nitrux Latinoamericana S.C.
#
# SPDX-License-Identifier: GPL-3.0-or-later

set(sol_SRCS
    main.cpp
    models/historymodel.cpp
    controllers/downloadsmanager.cpp
    controllers/dbactions.cpp
    db/db.cpp
    models/downloadsmodel.cpp
    models/recentmodel.cpp
    models/bookmarksmodel.cpp
    controllers/surf.cpp
    )

set(sol_ASSETS
    qml.qrc
    assets/img_assets.qrc
    )

add_executable(${PROJECT_NAME}  ${sol_SRCS}
    ${sol_ASSETS})

target_link_libraries(${PROJECT_NAME} MauiKit MauiKit::FileBrowsing Qt5::Widgets Qt5::WebEngine Qt5::Sql Qt5::Qml KF5::I18n KF5::CoreAddons)
