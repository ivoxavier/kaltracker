/*
 * 2022-2023  Ivo Xavier
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * kaltracker is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */








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