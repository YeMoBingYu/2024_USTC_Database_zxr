import sys
import time
from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtWidgets import QApplication, QMainWindow, QMessageBox
from connect import *
from manager import Ui_Mangager
from reader import Ui_Reader
from login import Ui_Login
from manager_register import Ui_Manager_Register
from reader_register import Ui_Reader_Register

# 链接数据库
cursor, conn = connect() # 连接数据库

# 读者的界面类
class Readerui(QtWidgets.QMainWindow, Ui_Reader):
    def __init__(self, parent=None, rid=None):
        super(Readerui, self).__init__(parent)
        self.rid=rid
        self.setupUi(self)

#  图书管理员的界面类
class Managerui(QtWidgets.QMainWindow, Ui_Mangager):
    def __init__(self, parent=None, mid=None):
        super(Managerui, self).__init__(parent)
        self.mid = mid
        self.setupUi(self)

# 读者注册界面
class Reader_register_ui(QtWidgets.QMainWindow, Ui_Reader_Register):
    def __init__(self, parent=None):
        super(Reader_register_ui, self).__init__(parent)
        self.setupUi(self)

# 管理员注册界面
class Manager_register_ui(QtWidgets.QMainWindow, Ui_Manager_Register):
    def __init__(self, parent=None):
        super(Manager_register_ui, self).__init__(parent)
        self.setupUi(self)


# 程序首页（登录界面）
class MyMainForm(QMainWindow, Ui_Login):
    def __init__(self, parent=None):
        super(MyMainForm, self).__init__(parent)
        self.setupUi(self)
        self.pushButton.clicked.connect(self.login)
        self.pushButton_2.clicked.connect(self.rregister)
        self.pushButton_3.clicked.connect(self.mregister)

    #登录界面
    def login(self):
        id_ = self.lineEdit_2.text()
        password = self.lineEdit.text()
        if id_ == '' or password == '':
            QMessageBox.warning(self, "警告", "请输入用户名/密码", QMessageBox.Yes)
        else:
            # 读者登录
            if self.comboBox.currentText() == '借阅者':
                sql = 'select * from readers where 读者号= "%s" and 密码="%s"' % (id_, password)
                res = cursor.execute(sql)
                if res:
                    # 读者的UI
                    self.read = Readerui(rid=id_)
                    self.read.show()
                    self.close()
                else:
                    QMessageBox.warning(self, "警告", "密码错误，请重新输入！", QMessageBox.Yes)
            # 图书管理员登录
            elif self.comboBox.currentText() == '管理员':
                sql = 'select * from workers where 管理号= "%s" and 密码="%s"' % (id_, password)
                res = cursor.execute(sql)
                if res:
                    self.manager = Managerui(mid=id_)
                    self.manager.show()
                    self.close()
                else:
                    QMessageBox.warning(self, "警告", "密码错误，请重新输入！", QMessageBox.Yes)
    
    #管理者注册
    def mregister(self):
        self.register_m = Manager_register_ui()
        self.register_m.show()
        self.close()
    
    #借阅者注册
    def rregister(self):
        self.register_r = Reader_register_ui()
        self.register_r.show()
        self.close()

# 固定的，PyQt5程序都需要QApplication对象。sys.argv为命令行参数列表，确保程序可以双击运行
app = QApplication(sys.argv)
# 初始化
myWin = MyMainForm()
# 将窗口控件显示在屏幕上
myWin.show()
# 程序运行，sys.exit方法确保程序完整退出。
sys.exit(app.exec_())
