#pragma once

#include <QObject>
#include <QAbstractListModel>

class DownloadsManager;
class DownloadsModel : public QAbstractListModel
{
    Q_OBJECT

public:
    enum Roles
    {
        Name,
        Url,
        Directory,
        State,
        Icon,
        Download,
        FilePath
    };

    explicit DownloadsModel(DownloadsManager *parent);

           // QAbstractItemModel interface
public:
    int rowCount(const QModelIndex &parent) const override final;
    QVariant data(const QModelIndex &index, int role) const override final;
    QHash<int, QByteArray> roleNames() const override final;

private:
    DownloadsManager *m_manager;
};

