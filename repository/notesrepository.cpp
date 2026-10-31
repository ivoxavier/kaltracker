#include "notesrepository.h"
#include "services/local/database/localstorage.h"
#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>

NotesRepository::NotesRepository(QObject *parent) : QObject(parent)
{
}

bool NotesRepository::saveNote(const QString &note, const QString &date)
{
    QSqlQuery query(LocalStorage::instance().localstorage());
    
    query.prepare("INSERT INTO notes (id_user, note, date) VALUES (1, :note, :date)");
    query.bindValue(":note", note);
    query.bindValue(":date", date);
    
    if (!query.exec()) {
        qWarning() << "NotesRepository: Failed to save note:" << query.lastError().text();
        return false;
    }
    return true;
}

bool NotesRepository::deleteNote(int id)
{
    QSqlQuery query(LocalStorage::instance().localstorage());
    
    query.prepare("DELETE FROM notes WHERE id = :id");
    query.bindValue(":id", id);
    
    if (!query.exec()) {
        qWarning() << "NotesRepository: Failed to delete note:" << query.lastError().text();
        return false;
    }
    return true;
}

bool NotesRepository::deleteAllNotes()
{
    QSqlQuery query(LocalStorage::instance().localstorage());
    
    if (!query.exec("DELETE FROM notes")) {
        qWarning() << "NotesRepository: Failed to delete all notes:" << query.lastError().text();
        return false;
    }
    return true;
}

QVariantList NotesRepository::getNotes(const QString &date)
{
    QVariantList notesList;
    QSqlQuery query(LocalStorage::instance().localstorage());
    

    if (date.isEmpty()) {
        query.prepare("SELECT id, note, date FROM notes WHERE id_user = 1 ORDER BY id DESC");
    } else {
        query.prepare("SELECT id, note, date FROM notes WHERE id_user = 1 AND date = :date ORDER BY id DESC");
        query.bindValue(":date", date);
    }
    
    if (!query.exec()) {
        qWarning() << "NotesRepository: Failed to get notes:" << query.lastError().text();
        return notesList;
    }
    
    
    while (query.next()) {
        QVariantMap note;
        note["id"] = query.value("id").toInt();
        note["note"] = query.value("note").toString();
        note["date"] = query.value("date").toString();
        
        notesList.append(note);
    }
    
    return notesList;
}