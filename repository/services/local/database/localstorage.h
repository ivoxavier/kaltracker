#ifndef LOCALSTORAGE_H
#define LOCALSTORAGE_H

#include <QSqlDatabase>

class LocalStorage
{
public:
    static LocalStorage& instance();

    bool initialize();
    QSqlDatabase localstorage() const;

private:
    LocalStorage() = default;

    QSqlDatabase m_localstorage;
};

#endif // LOCALSTORAGE_H
