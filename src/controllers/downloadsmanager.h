#pragma once

#include <QObject>

#include "models/downloadsmodel.h"
#include <QWebEngineDownloadRequest>

using DownloadItem = QWebEngineDownloadRequest;

class DownloadsManager : public QObject
{
//    Q_DISABLE_COPY_MOVE(DownloadsManager)
    Q_OBJECT

    Q_PROPERTY(DownloadsModel* model READ model CONSTANT FINAL)

public:
    enum State {
        DownloadRequested,
        DownloadInProgress,
        DownloadCompleted,
        DownloadCancelled,
        DownloadInterrupted,
    }; Q_ENUM(State)

    DownloadsModel *model() const;
    static DownloadsManager &instance();

public Q_SLOTS:
    void add(DownloadItem *download);
    void remove(int index);

    DownloadItem *item(int index);
    int count() const;

private:
    DownloadsModel *m_model;
    QVector<DownloadItem*> m_downloads;

    explicit DownloadsManager(QObject *parent = nullptr);
    ~DownloadsManager();

Q_SIGNALS:
    void newDownload(DownloadItem *download);

};
