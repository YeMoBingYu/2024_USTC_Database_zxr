import pymysql

# fronten/connect.py
# 数据库链接
def connect():
    conn = pymysql.connect(host='localhost', user='root', password='20040223zzz', database='library')
    cursor = conn.cursor()
    print('链接成功')
    return cursor, conn
