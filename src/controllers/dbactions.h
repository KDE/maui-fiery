#ifndef DBACTIONS_H
#define DBACTIONS_H

#include <QObject>
#include <QThread>
#include <QDebug>
#include <QCoreApplication>

#include "db/db.h"

struct UrlData
{
    QUrl url;
    QString title;

    QVariantMap toMap() const
    {
        return {{"url", url.toString()}, {"title", title}};
    }

    FMH::MODEL toModel() const
    {
        return {{FMH::MODEL_KEY::URL, url.toString()}, {FMH::MODEL_KEY::TITLE, title}};
    }
};

class DBActions : public DB
{
    Q_OBJECT
public:
    static DBActions *getInstance()
    {
        qWarning() << "GETTIG TAGGING INSTANCE" << QThread::currentThread() << qApp->thread();

        if (QThread::currentThread() != qApp->thread()) {
            qWarning() << "Can not get Tagging instance from a thread different than the mian one  " << QThread::currentThread() << qApp->thread();
            return nullptr;
        }

        if (m_instance)
            return m_instance;

        m_instance = new DBActions;
        return m_instance;
    }

    void addToHistory(const UrlData &data);
    void addBookmark(const UrlData &data);

    void urlIcon(const QUrl &url, const QString &icon);

    FMH::MODEL_LIST getHistory() const;
    FMH::MODEL_LIST getBookmarks() const;

    bool isBookmark(const QUrl &url);

private:
    static DBActions *m_instance;

    explicit DBActions(QObject *parent = nullptr);
    DBActions(const DBActions &) = delete;
    DBActions &operator=(const DBActions &) = delete;
    DBActions(DBActions &&) = delete;
    DBActions &operator=(DBActions &&) = delete;

    const QVariantList get(const QString &query, std::function<bool(QVariantMap &item)> modifier = nullptr) const;

signals:
    void historyUrlInserted(UrlData data);
    void bookmarkInserted(UrlData data);
    void iconInserted(QUrl url, QString icon);

};

#endif // DBACTIONS_H
