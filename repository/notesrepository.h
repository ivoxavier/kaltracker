#ifndef NOTESREPOSITORY_H
#define NOTESREPOSITORY_H

#include <QObject>
#include <QVariantList>
#include <QVariantMap>

class NotesRepository : public QObject
{
    Q_OBJECT
public:
    explicit NotesRepository(QObject *parent = nullptr);
    Q_INVOKABLE QVariantList getNotes();
};

#endif // NOTESREPOSITORY_H