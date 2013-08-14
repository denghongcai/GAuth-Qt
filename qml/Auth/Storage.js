//storage.js
// 首先创建一个helper方法连接数据库
function getDatabase() {
    return openDatabaseSync("QGAuthenticatorr", "1.0", "StorageDatabase", 100000);
}

// 程序打开时，初始化表
function initialize() {
    var db = getDatabase();
    db.transaction(
                function(tx) {
                    // 如果secret表不存在，则创建一个
                    // 如果表存在，则跳过此步
                    tx.executeSql('CREATE TABLE IF NOT EXISTS secret(id TEXT UNIQUE, key TEXT)');
                });
}

// 插入数据
function insertData(id, key) {
    var db = getDatabase();
    var res = "";
    db.transaction(function(tx) {
                       var rs = tx.executeSql('INSERT OR REPLACE INTO secret VALUES (?,?);', [id,key]);
                       //console.log(rs.rowsAffected)
                       if (rs.rowsAffected > 0) {
                           res = "OK";
                       } else {
                           res = "Error";
                       }
                   }
                   );
    return res;
}

// 获取数据
function selectData() {
    var db = getDatabase();
    var res = [];
    db.transaction(function(tx) {
                       var rs = tx.executeSql('SELECT id,key FROM secret');
                       if (rs.rows.length > 0) {
                           for(var i = 0;i < rs.rows.length;i++){
                               res[i] = [rs.rows.item(i).id, rs.rows.item(i).key];
                           }
                       } else {
                           res = "Unknown";
                       }
                   })
    return res;
}
