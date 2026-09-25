#include <iostream>
#include <mutex>

class Singleton
{
private:
    static Singleton *instance;
    // static mutex mtx;

    Singleton()
    {
        std::cout << "Singleton Constructor called. New Object is Created" << std::endl;
    }

public:
    static Singleton *getInstance()
    {
        // if (instance == nullptr)
        // {
        //     lock_gurd<mutex> lock(mtx);
        //     if (instance == nullptr)
        //     {
        //         instance = new Singleton();
        //     }
        // }
        return instance;
    }
};

// Singleton *Singleton::instance = nullptr;

// Egger Initialization
Singleton *Singleton::instance = new Singleton();

int main()
{
    Singleton *s1 = Singleton::getInstance();
    Singleton *s2 = Singleton::getInstance();
    std::cout << (s1 == s2) << std::endl;

    return 0;
}