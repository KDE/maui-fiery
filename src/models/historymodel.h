#pragma once

#include <MauiKit4/Core/mauilist.h>

class HistoryModel : public MauiList
{
    Q_OBJECT

public:
    HistoryModel();

    const FMH::MODEL_LIST &items() const override final;

private:
    FMH::MODEL_LIST m_list;

    void setList();

public Q_SLOTS:
    void appendUrl(const QUrl &url, const QString &title);
    void updateIcon(const QUrl &url, const QString &icon);

};
