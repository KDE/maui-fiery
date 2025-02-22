#pragma once

#include <QObject>
#include <QQuickItem>
#include <QQuickWebEngineProfile>
#include <QWebEngineUrlRequestInterceptor>
#include <QWebEngineDownloadRequest>

using DownloadItem = QWebEngineDownloadRequest;

class QWebEngineNotification;
class QQuickItem;
class QWebEngineUrlRequestInterceptor;

class FieryWebProfile : public QQuickWebEngineProfile
{
    Q_OBJECT
    Q_PROPERTY(QWebEngineUrlRequestInterceptor *urlInterceptor WRITE setUrlInterceptor READ urlInterceptor NOTIFY urlInterceptorChanged)

public:
    explicit FieryWebProfile(QObject *parent = nullptr);

    QWebEngineUrlRequestInterceptor *urlInterceptor() const;

    void setUrlInterceptor(QWebEngineUrlRequestInterceptor *newUrlInterceptor);

Q_SIGNALS:
    void urlInterceptorChanged();
    void downloadFinished(DownloadItem *download);

private:

    void handleDownload(QQuickWebEngineDownloadRequest *downloadItem);
    void handleDownloadFinished(DownloadItem *downloadItem);
    void showNotification(QWebEngineNotification *webNotification);


         // A valid property needs a read function, and there is no getter in QQuickWebEngineProfile
         // so store a pointer ourselves
    QWebEngineUrlRequestInterceptor *m_urlInterceptor;

};

