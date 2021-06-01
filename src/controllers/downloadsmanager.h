#ifndef DOWNLOADSMANAGER_H
#define DOWNLOADSMANAGER_H

#include <QObject>

class DownloadsManager : public QObject
{
    Q_OBJECT
public:
    explicit DownloadsManager(QObject *parent = nullptr);

signals:

};

#endif // DOWNLOADSMANAGER_H
