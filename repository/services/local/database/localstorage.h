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