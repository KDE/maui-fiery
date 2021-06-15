#include "bookmarksmodel.h"

#include "controllers/dbactions.h"

BookMarksModel::BookMarksModel()
{
    this->setList();

    connect(DBActions::getInstance(), &DBActions::bookmarkInserted, [this](UrlData data)
    {
        emit this->preItemAppended();
        this->m_list << data.toModel();
        emit this->postItemAppended();
    });

    connect(DBActions::getInstance(), &DBActions::iconInserted, [this](QUrl, QString)
    {
//        auto index = this->indexOf(FMH::MODEL_KEY::URL, url.toString());

//        qDebug() << "icon saved for " << url.toString() << index;
//qDebug() << m_list;
//        if(index > -1 && index < this->m_list.size())
//        {
//            auto item = this->m_list[index];
//            item.insert(FMH::MODEL_KEY::ICON, icon);
//            emit this->updateModel(mappedIndex(index), {FMH::MODEL_KEY::ICON});
//        }
//        qDebug() << m_list;

        this->setList();
    });
}

const FMH::MODEL_LIST &BookMarksModel::items() const
{
    return m_list;
}

void BookMarksModel::setList()
{
    this->m_list.clear();
    emit this->preListChanged();
    this->m_list << DBActions::getInstance()->getBookmarks();
    qDebug() << "GOT BOOKMARKS" << this->m_list;
    emit this->postListChanged();
}

void BookMarksModel::insertBookmark(const QUrl &url, const QString &title) const
{
    DBActions::getInstance()->addBookmark({url, title});
}

bool BookMarksModel::isBookmark(const QUrl &url)
{
    return DBActions::getInstance()->isBookmark(url);
}
