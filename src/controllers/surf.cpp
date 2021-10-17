#include "surf.h"

surf::surf(QObject *parent) : QObject(parent)
{

}

QUrl surf::formatUrl(const QUrl &url)
{
    return QUrl::fromUserInput(url.toString());
}
