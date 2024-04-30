#pragma once

#include <MauiKit4/Core/mauilist.h>
#include <QObject>


class BookMarksModel : public MauiList
{
    Q_OBJECT
public:
    BookMarksModel();
    const FMH::MODEL_LIST &items() const override final;

private:
    void setList();
    FMH::MODEL_LIST m_list;

public Q_SLOTS:
    void insertBookmark(const QUrl &url, const QString &title) const;
    bool isBookmark(const QUrl &url);

};
