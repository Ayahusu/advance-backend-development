#include <iostream>
#include <thread>

void functionOne(char symbol)
{
    for (int i = 0; i <= 100; i++)
    {
        std::cout << symbol;
    }
}
void functionTwo()
{
    for (int i = 0; i <= 100; i++)
    {
        std::cout << "-";
    }
}
int main()
{
    std::thread workerOne(functionOne, 'o');
    std::thread workerTwo(functionTwo);

    workerOne.join();
    workerTwo.join();
    return 0;
}