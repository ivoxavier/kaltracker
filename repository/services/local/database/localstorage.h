#ifndef LOCALSTORAGE_H
#define LOCALSTORAGE_H

#include <QObject>
#include <QSqlDatabase>

class LocalStorage : public QObject
{
    Q_OBJECT
public:
    static LocalStorage& instance();

    bool initialize();
    QSqlDatabase localstorage() const;
    
    
    Q_INVOKABLE void dropTables();
    Q_INVOKABLE void createTables();

private:
    LocalStorage() = default;

    QSqlDatabase m_localstorage;
};

#endif // LOCALSTORAGE_H