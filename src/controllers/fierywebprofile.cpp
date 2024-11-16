#include "fierywebprofile.h"


#include <QQuickWindow>
#include <QWebEngineNotification>

#include <QWebEngineUrlRequestInterceptor>
#include <QWebEngineDownloadRequest>

#include "downloadsmanager.h"

class QQuickWebEngineDownloadRequest : public DownloadItem
{
};



FieryWebProfile::FieryWebProfile(QObject *parent)
    : QQuickWebEngineProfile{parent}
{
    connect(this, &QQuickWebEngineProfile::downloadRequested, this, &FieryWebProfile::handleDownload);
    connect(this, &QQuickWebEngineProfile::downloadFinished, this, &FieryWebProfile::handleDownloadFinished);
    connect(this, &QQuickWebEngineProfile::presentNotification, this, &FieryWebProfile::showNotification);

}

QWebEngineUrlRequestInterceptor *FieryWebProfile::urlInterceptor() const
{
    return m_urlInterceptor;
}

void FieryWebProfile::handleDownload(QQuickWebEngineDownloadRequest *downloadItem)
{
        DownloadItem *download = qobject_cast<DownloadItem *>(downloadItem);

    qDebug() << "GOT TO DOWNLOAD HANDLE" << downloadItem->url();

    download->accept();
    download->pause();

    DownloadsManager::instance().add(downloadItem);
}

void FieryWebProfile::handleDownloadFinished(DownloadItem *downloadItem)
{
    Q_EMIT downloadFinished(downloadItem);
}

void FieryWebProfile::showNotification(QWebEngineNotification *webNotification)
{

}

void FieryWebProfile::setUrlInterceptor(QWebEngineUrlRequestInterceptor *newUrlInterceptor)
{
    if (m_urlInterceptor == newUrlInterceptor)
        return;
    m_urlInterceptor = newUrlInterceptor;
    Q_EMIT urlInterceptorChanged();
}
