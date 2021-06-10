#include "historymodel.h"
#include <MauiKit/Core/utils.h>
#include "controllers/dbactions.h"

HistoryModel::HistoryModel()
{
    this->setList();

    connect(DBActions::getInstance(), &DBActions::historyUrlInserted, [this](UrlData data)
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

const FMH::MODEL_LIST &HistoryModel::items() const
{
    return m_list;
}

void HistoryModel::appendUrl(const QUrl &url, const QString &title)
{
    DBActions::getInstance()->addToHistory({url, title});
}

void HistoryModel::updateIcon(const QUrl &url, const QString &icon)
{
    qDebug() << "icon for " << url.toString() << icon;

    DBActions::getInstance()->urlIcon(url, icon);
}

void HistoryModel::setList()
{
    this->m_list.clear();
    emit this->preListChanged();
    this->m_list << DBActions::getInstance()->getHistory();
    qDebug() << "GOT HISTORY" << this->m_list;
    emit this->postListChanged();
}
