#include "fierywebprofile.h"

#include "qquickwebenginedownloaditem.h"

#include <QQuickWindow>
#include <QWebEngineNotification>

#include <QWebEngineUrlRequestInterceptor>

#include "downloadsmanager.h"

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

void FieryWebProfile::handleDownload(DownloadItem *downloadItem)
{
    qDebug() << "GOT TO DOWNLOAD HANDLE" << downloadItem->url();

    downloadItem->accept();
    downloadItem->pause();

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
    emit urlInterceptorChanged();
}
