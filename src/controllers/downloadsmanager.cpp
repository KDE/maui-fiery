#include "downloadsmanager.h"
#include <QDebug>
#include <QUrl>

DownloadsManager::DownloadsManager(QObject *parent) : QObject(parent)
    ,m_model(new DownloadsModel(this))
{

}

DownloadsManager &DownloadsManager::instance()
{
    static DownloadsManager instance;
    return instance;
}

void DownloadsManager::add(DownloadItem *download)
{
    qDebug() << "ADD NEW DOWNLOAD";
    m_downloads << download;
    Q_EMIT newDownload(download);
}

void DownloadsManager::remove(int index)
{
    if(index < 0 || index >= m_downloads.count())
        return;

    m_downloads.at(index)->cancel();
    m_downloads.erase(m_downloads.begin() + index);
}

DownloadItem *DownloadsManager::item(int index)
{
    if(index < 0 || index >= m_downloads.count())
        return nullptr;

    return m_downloads.at(index);
}

int DownloadsManager::count() const
{
    return m_downloads.count();
}

DownloadsManager::~DownloadsManager()
{
//    qDeleteAll(m_downloads);
}

DownloadsModel *DownloadsManager::model() const
{
    return m_model;
}
