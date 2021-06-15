#include "dbactions.h"

#include <QDateTime>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>

DBActions *DBActions::m_instance = nullptr;

void DBActions::addToHistory(const UrlData &data)
{
    auto mData = data.toMap();
    mData.insert("adddate",  QDateTime::currentDateTime().toString(Qt::TextDate));
    if(this->insert("HISTORY", mData))
    {
        emit this->historyUrlInserted(data);
    }
}

void DBActions::addBookmark(const UrlData &data)
{
    auto mData = data.toMap();
    mData.insert("adddate",  QDateTime::currentDateTime().toString(Qt::TextDate));
    if(this->insert("BOOKMARKS", mData))
    {
        emit this->bookmarkInserted(data);
    }
}

void DBActions::urlIcon(const QUrl &url, const QString &icon)
{
    if(!this->insert("ICONS", {{"url", url.toString()}, {"icon", icon}}))
    {
        this->update("ICONS", {{FMH::MODEL_KEY::ICON, icon}}, {{"url", url}});
    }

    emit this->iconInserted(url, icon);
}

FMH::MODEL_LIST DBActions::getHistory() const
{
return FMH::toModelList(this->get("select * from HISTORY h inner join ICONS i where i.url = h.url"));
}

FMH::MODEL_LIST DBActions::getBookmarks() const
{
    return FMH::toModelList(this->get("select * from BOOKMARKS b inner join ICONS i where i.url = b.url"));
}

bool DBActions::isBookmark(const QUrl &url)
{
    return checkExistance("BOOKMARKS", "url", url.toString());
}

DBActions::DBActions(QObject *parent) : DB(parent)
{
    connect(qApp, &QCoreApplication::aboutToQuit, []()
    {
        qDebug() << "Lets remove Tagging singleton instance";
        delete m_instance;
        m_instance = nullptr;
    });
}

const QVariantList DBActions::get(const QString &queryTxt, std::function<bool(QVariantMap &item)> modifier) const
{
    QVariantList mapList;

    auto query = this->getQuery(queryTxt);

    if (query.exec()) {
        const auto keys = FMH::MODEL_NAME.keys();

        while (query.next()) {
            QVariantMap data;
            for (const auto &key : keys) {

                if (query.record().indexOf(FMH::MODEL_NAME[key]) > -1) {
                    data[FMH::MODEL_NAME[key]] = query.value(FMH::MODEL_NAME[key]).toString();
                }
            }

            if (modifier) {
                if (!modifier(data))
                {
                    continue;
                }
            }

            mapList << data;
        }

    } else
    {
        qDebug() << query.lastError() << query.lastQuery();
    }

    return mapList;
}
