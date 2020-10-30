
import base64, psycopg2, pandas as pd, psycopg2.extras

class HandlePostgres:

    def __init__(self, config):
        self.db = config.get('DataBase', 'db')
        self.user = config.get('DataBase', 'user')
        self.password = str((base64.b64decode(config.get('DataBase', 'password'))), encoding='utf-8')
        self.host = config.get('DataBase', 'host')
        self.port = config.get('DataBase', 'port')
        self.conn = None
        self.cur = None

    def conn_postgres(self):
        """连接数据库"""
        self.conn = psycopg2.connect(database=(self.db), user=(self.user), password=(self.password), host=(self.host), port=(self.port))
        self.cur = self.conn.cursor(cursor_factory=(psycopg2.extras.DictCursor))

    def search_as_df(self, sql):
        """执行查询sql"""
        df = pd.read_sql(sql, self.conn)
        return df

    def batch_execute(self, sql, values):
        """批量执行sql"""
        try:
            self.cur.executemany(sql, values)
            self.conn.commit()
        except Exception as e:
            self.conn.rollback()
            raise e

    def close_postgres(self):
        """关闭数据库连接"""
        self.cur.close()
        self.conn.close()
