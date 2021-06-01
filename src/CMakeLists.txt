# Copyright 2018-2020 Camilo Higuita <milo.h@aol.com>
# Copyright 2018-2020 Nitrux Latinoamericana S.C.
#
# SPDX-License-Identifier: GPL-3.0-or-later

set(sol_SRCS
    main.cpp
    models/historymodel.cpp
    controllers/downloadsmanager.cpp
    models/downloadsmodel.cpp
    models/recentmodel.cpp
    models/bookmarksmodel.cpp
    )

set(sol_ASSETS
    qml.qrc
    assets/img_assets.qrc
    )

if(ANDROID)
    add_library(${PROJECT_NAME} SHARED  ${sol_SRCS}
        ${sol_ASSETS})
else()
    add_executable(${PROJECT_NAME}  ${sol_SRCS}
        ${sol_ASSETS})
endif()


target_link_libraries(${PROJECT_NAME} MauiKit Qt5::Sql Qt5::Qml Qt5::Svg KF5::ConfigCore KF5::Notifications KF5::KIOCore KF5::I18n)
