import threading

def functionOne():
    for i in range(1,100):
        print("+")

def functionTwo():
    for i in range(1,100):
        print("-")

t1 = threading.Thread(target=functionOne)
t2 = threading.Thread(target=functionTwo)

t1.start()
t2.start()
t1.join()
t2.join()