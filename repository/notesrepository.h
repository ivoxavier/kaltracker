#ifndef NOTESREPOSITORY_H
#define NOTESREPOSITORY_H

#include <QObject>
#include <QString>

class NotesRepository : public QObject
{
    Q_OBJECT
public:
    explicit NotesRepository(QObject *parent = nullptr);

    Q_INVOKABLE bool saveNote(const QString &note, const QString &date);
    Q_INVOKABLE bool deleteNote(int id);
    Q_INVOKABLE bool deleteAllNotes();
    Q_INVOKABLE QVariantList getNotes(const QString &date = "");
};

#endif // NOTESREPOSITORY_H