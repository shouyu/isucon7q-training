import MySQLdb
import pathlib

def dump():
    conn = MySQLdb.connect(host='127.0.0.1', user='root', passwd='',
                           db='isubata',
                           port=3306)
    cursor = conn.cursor()

    sql = "select name, data from image"
    cursor.execute(sql)
    
    image_path = pathlib.Path('webapp/public/icons')
    image_path.mkdir(parents=True, exist_ok=True)
    
    for name, data in cursor:
        print(name, image_path / name)
        with open(image_path / name, 'wb') as f:
            f.write(data)


if __name__ == '__main__':
    dump()