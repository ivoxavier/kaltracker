#include "ingestionrepository.h"
#include "services/local/database/localstorage.h"

#include <QSqlQuery>
#include <QSqlError>
#include <QDebug>
#include <QDateTime>

IngestionRepository::IngestionRepository(QObject *parent) : QObject(parent)
{
}

bool IngestionRepository::saveIngestion(const IngestionModel &ingestion)
{
    QSqlQuery query(LocalStorage::instance().localstorage());

    query.prepare(
        "INSERT INTO ingestions "
        "(id_user, name, nutriscore, cal, fat, carbo, protein, meal, date) "
        "VALUES "
        "(:id_user, :name, :nutriscore, :cal, :fat, :carbo, :protein, :meal, :date)"
    );

    query.bindValue(":id_user", ingestion.userId);
    query.bindValue(":name", ingestion.name);
    query.bindValue(":nutriscore", ingestion.nutriscore);
    query.bindValue(":cal", ingestion.calories);
    query.bindValue(":fat", ingestion.fat);
    query.bindValue(":carbo", ingestion.carbs);
    query.bindValue(":protein", ingestion.protein);
    query.bindValue(":meal", ingestion.mealType);
    query.bindValue(":date", ingestion.date);

    if (!query.exec()) {
        qWarning() << "IngestionRepository: Failed to save ingestion:" << query.lastError().text();
        return false;
    }

    return query.numRowsAffected() > 0;
}

bool IngestionRepository::saveIngestion(const QVariantMap &data)
{
    IngestionModel model;
    model.userId = data.value("userId", 1).toInt();
    model.name = data.value("name").toString();
    model.nutriscore = data.value("nutriscore").toString();
    model.calories = data.value("calories", 0).toInt();
    model.fat = data.value("fat", 0.0).toDouble();
    model.carbs = data.value("carbs", 0.0).toDouble();
    model.protein = data.value("protein", 0.0).toDouble();
    model.mealType = data.value("mealType", 0).toInt();
    model.date = data.value("date", QDateTime::currentDateTime().toString("yyyy-MM-dd")).toString();

    return saveIngestion(model);
}

bool IngestionRepository::saveIngestionsList(const QVariantList &list, int mealType, const QString &date)
{
    bool allSuccess = true;
    for (const QVariant &item : list) {
        QVariantMap data = item.toMap();
        IngestionModel model;
        
        model.userId = 1;
        model.name = data.value("product_name").toString();
        model.nutriscore = data.value("nutriscore_grade").toString();
        model.calories = data.value("energy_kcal_100g", 0).toInt();
        model.fat = data.value("fat_100g", 0.0).toDouble();
        model.carbs = data.value("carbohydrates_100g", 0.0).toDouble();
        model.protein = data.value("proteins_100g", 0.0).toDouble();
        model.mealType = mealType;
        model.date = date;

        if (!saveIngestion(model)) {
            allSuccess = false;
        }
    }
    return allSuccess;
}

bool IngestionRepository::deleteAllIngestions()
{
    QSqlQuery query(LocalStorage::instance().localstorage());
    if (!query.exec("DELETE FROM ingestions")) {
        qWarning() << "IngestionRepository: Failed to delete all ingestions:" << query.lastError().text();
        return false;
    }
    return true;
}

bool IngestionRepository::deleteTodayIngestions()
{
    QSqlQuery query(LocalStorage::instance().localstorage());
    if (!query.exec("DELETE FROM ingestions WHERE date = date('now')")) {
        qWarning() << "IngestionRepository: Failed to delete today's ingestions:" << query.lastError().text();
        return false;
    }
    return true;
}

bool IngestionRepository::deleteMonthYearIngestion(const QString &month, const QString &year)
{
    QSqlQuery query(LocalStorage::instance().localstorage());
    
    QString formattedMonth = month.length() == 1 ? "0" + month : month;

    query.prepare("DELETE FROM ingestions WHERE strftime('%m', date) = :month AND strftime('%Y', date) = :year");
    query.bindValue(":month", formattedMonth);
    query.bindValue(":year", year);

    if (!query.exec()) {
        qWarning() << "IngestionRepository: Failed to delete month/year ingestions:" << query.lastError().text();
        return false;
    }
    qDebug() << "Ingestions removed from option month_year";
    return true;
}

bool IngestionRepository::deleteIngestion(int id)
{
    QSqlQuery query(LocalStorage::instance().localstorage());
    query.prepare("DELETE FROM ingestions WHERE id = :id");
    query.bindValue(":id", id);

    if (!query.exec()) {
        qWarning() << "IngestionRepository: Failed to delete ingestion:" << query.lastError().text();
        return false;
    }
    return true;
}

int IngestionRepository::checkOldest()
{
    QSqlQuery query(LocalStorage::instance().localstorage());
    if (!query.exec("SELECT COUNT(*) AS oldest FROM ingestions WHERE date < strftime('%Y', date('now'))")) {
        qWarning() << "IngestionRepository: Failed to check oldest:" << query.lastError().text();
        return 0;
    }

    if (query.next()) {
        return query.value("oldest").toInt();
    }
    return 0;
}

bool IngestionRepository::autoClean()
{
    QSqlQuery query(LocalStorage::instance().localstorage());
    if (!query.exec("DELETE FROM ingestions WHERE date < strftime('%Y', date('now'))")) {
        qWarning() << "IngestionRepository: Failed to auto clean:" << query.lastError().text();
        return false;
    }
    return true;
}

bool IngestionRepository::deleteSpecificTodayIngestion(int id)
{
    return deleteIngestion(id);
}

int IngestionRepository::getTotalCalConsumed(const QString &date) {
    QSqlQuery query(LocalStorage::instance().localstorage());
    query.prepare("SELECT SUM(cal) AS totalcal FROM ingestions WHERE date = :date");
    query.bindValue(":date", date);
    if (query.exec() && query.next()) return query.value("totalcal").toInt();
    return 0;
}

int IngestionRepository::getTotalCalRemaining(const QString &date) {
    QSqlQuery query(LocalStorage::instance().localstorage());
    query.prepare("WITH dif AS (SELECT (u.rec_cal - SUM(i.cal)) AS remaining FROM ingestions i, user u WHERE i.id_user = u.id AND i.date = :date) SELECT remaining FROM dif");
    query.bindValue(":date", date);
    if (query.exec() && query.next() && !query.value("remaining").isNull()) {
        return query.value("remaining").toInt();
    }
    return 0;
}

int IngestionRepository::getTotalFoodsConsumed(const QString &date) {
    QSqlQuery query(LocalStorage::instance().localstorage());
    query.prepare("SELECT COUNT(id) AS totalFoods FROM ingestions WHERE date = :date");
    query.bindValue(":date", date);
    if (query.exec() && query.next()) return query.value("totalFoods").toInt();
    return 0;
}

int IngestionRepository::getMealCalories(const QString &date, int mealType) {
    QSqlQuery query(LocalStorage::instance().localstorage());
    query.prepare("SELECT SUM(cal) AS totalcal FROM ingestions WHERE date = :date AND meal = :meal");
    query.bindValue(":date", date);
    query.bindValue(":meal", mealType);
    if (query.exec() && query.next()) return query.value("totalcal").toInt();
    return 0;
}

double IngestionRepository::getMacroConsumed(const QString &date, const QString &macroType) {
    QSqlQuery query(LocalStorage::instance().localstorage());
    QString safeMacro = (macroType == "fat" || macroType == "carbo" || macroType == "protein") ? macroType : "fat";
    query.prepare(QString("SELECT SUM(%1) as totalMacro FROM ingestions i, user u WHERE i.id_user = u.id AND i.date = :date").arg(safeMacro));
    query.bindValue(":date", date);
    if (query.exec() && query.next()) return query.value("totalMacro").toDouble();
    return 0.0;
}

QVariantList IngestionRepository::getMealIngestions(const QString &date, int mealType) {
    QVariantList list;
    QSqlQuery query(LocalStorage::instance().localstorage());
    query.prepare("SELECT id, name, nutriscore, cal, fat, carbo, protein FROM ingestions WHERE date = :date AND meal = :meal");
    query.bindValue(":date", date);
    query.bindValue(":meal", mealType);
    if (query.exec()) {
        while (query.next()) {
            QVariantMap item;
            item["id"] = query.value("id").toInt();
            item["name"] = query.value("name").toString();
            item["nutriscore"] = query.value("nutriscore").toString();
            item["cal"] = query.value("cal").toInt();
            item["fat"] = query.value("fat").toDouble();
            item["carbo"] = query.value("carbo").toDouble();
            item["protein"] = query.value("protein").toDouble();
            list.append(item);
        }
    }
    return list;
}

QVariantList IngestionRepository::getTodayIngestions(const QString &date) {
    QVariantList list;
    QSqlQuery query(LocalStorage::instance().localstorage());
    query.prepare("SELECT id, date, name, cal FROM ingestions WHERE date = :date");
    query.bindValue(":date", date);
    if (query.exec()) {
        while (query.next()) {
            QVariantMap item;
            item["id"] = query.value("id").toInt();
            item["cal"] = query.value("cal").toInt();
            item["name"] = query.value("name").toString();
            item["date"] = query.value("date").toString();
            list.append(item);
        }
    }
    return list;
}

QVariantList IngestionRepository::getAverageCalories(const QString &year) {
    QVariantList list;
    QSqlQuery query(LocalStorage::instance().localstorage());
    query.prepare("SELECT strftime('%m', date) AS month, AVG(cal) AS average FROM ingestions WHERE strftime('%Y', date) = :year GROUP BY month ORDER BY month DESC");
    query.bindValue(":year", year);
    if (query.exec()) {
        while (query.next()) {
            QVariantMap item;
            item["month"] = query.value("month").toString();
            item["average"] = query.value("average").toDouble();
            list.append(item);
        }
    }
    return list;
}

QVariantList IngestionRepository::getAllFoodsMonth(const QString &month) {
    QVariantList list;
    QSqlQuery query(LocalStorage::instance().localstorage());
    QString formattedMonth = month.length() == 1 ? "0" + month : month;
    query.prepare("SELECT date, name, cal FROM ingestions WHERE strftime('%m', date) = :month");
    query.bindValue(":month", formattedMonth);
    if (query.exec()) {
        while (query.next()) {
            QVariantMap item;
            item["date"] = query.value("date").toString();
            item["name"] = query.value("name").toString();
            item["cal"] = query.value("cal").toInt();
            list.append(item);
        }
    }
    return list;
}

// --- Métodos para a tabela user_foods_list ---

bool IngestionRepository::saveUserFood(const QString &name, const QString &nutriscore, 
                                       int cal, double fat, double carbo, double protein) 
{
    QSqlQuery query(LocalStorage::instance().localstorage());
    
    query.prepare("INSERT INTO user_foods_list "
                  "(id_user, name, nutriscore, cal, fat, carbo, protein) "
                  "VALUES (1, :name, :nutriscore, :cal, :fat, :carbo, :protein)");
                  
    query.bindValue(":name", name);
    query.bindValue(":nutriscore", nutriscore);
    query.bindValue(":cal", cal);
    query.bindValue(":fat", fat);
    query.bindValue(":carbo", carbo);
    query.bindValue(":protein", protein);

    if (!query.exec()) {
        qWarning() << "IngestionRepository: Failed to save user food:" << query.lastError().text();
        return false;
    }
    return true;
}

int IngestionRepository::isUniqueUserFood(const QString &name) 
{
    QSqlQuery query(LocalStorage::instance().localstorage());
    query.prepare("SELECT id FROM user_foods_list WHERE name = :name");
    query.bindValue(":name", name);
    
    if (query.exec() && query.next()) {
        return query.value("id").toInt();
    }
    
    return 0; // Retorna 0 se não existir (o SQLite começa os IDs no 1)
}

QVariantList IngestionRepository::getUserFoods() 
{
    QVariantList list;
    QSqlQuery query(LocalStorage::instance().localstorage());
    
    if (query.exec("SELECT id, name, nutriscore, cal, fat, carbo, protein FROM user_foods_list")) {
        while (query.next()) {
            QVariantMap item;
            
            item["id"] = query.value("id").toInt();
            item["product_name"] = query.value("name").toString();
            item["nutriscore_grade"] = query.value("nutriscore").toString();
            item["energy_kcal_100g"] = query.value("cal").toInt();
            item["fat_100g"] = query.value("fat").toDouble();
            item["carbohydrates_100g"] = query.value("carbo").toDouble();
            item["proteins_100g"] = query.value("protein").toDouble();
            
            list.append(item);
        }
    } else {
        qWarning() << "IngestionRepository: Failed to get user foods:" << query.lastError().text();
    }
    
    return list;
}

bool IngestionRepository::deleteUserFood(int id) 
{
    QSqlQuery query(LocalStorage::instance().localstorage());
    query.prepare("DELETE FROM user_foods_list WHERE id = :id");
    query.bindValue(":id", id);
    
    if (!query.exec()) {
        qWarning() << "IngestionRepository: Failed to delete user food:" << query.lastError().text();
        return false;
    }
    return true;
}