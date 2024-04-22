#ifndef SURF_H
#define SURF_H

#include <QObject>
#include <QUrl>

class surf : public QObject
{
    Q_OBJECT
public:
    explicit surf(QObject *parent = nullptr);

public Q_SLOTS:
    static QUrl formatUrl(const QUrl &url);

};

#endif // SURF_H
