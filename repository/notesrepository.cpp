#include "notesrepository.h"
#include "services/local/database/localstorage.h"
#include <QSqlQuery>

NotesRepository::NotesRepository(QObject *parent) : QObject(parent) {}

QVariantList NotesRepository::getNotes() {
    QVariantList list;
    QSqlQuery query(LocalStorage::instance().localstorage());
    if (query.exec("SELECT id, note, date FROM notes ORDER BY id DESC")) {
        while (query.next()) {
            QVariantMap item;
            item["id"] = query.value("id").toInt();
            item["note"] = query.value("note").toString();
            item["date"] = query.value("date").toString();
            list.append(item);
        }
    }
    return list;
}