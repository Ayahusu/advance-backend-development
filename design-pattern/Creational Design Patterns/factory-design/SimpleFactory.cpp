#include <iostream>
#include <string>

class Burger
{
public:
    virtual void prepare() = 0;
    virtual ~Burger() {}
};

class BasicBurger : public Burger
{
public:
    void prepare() override
    {
        std::cout << "Basic burger prepared";
    }
};

class StandardBurger : public Burger
{
public:
    void prepare() override
    {
        std::cout << "Standard Burger Prepared";
    }
};

class PremiumBurger : public Burger
{
public:
    void prepare() override
    {
        std::cout << "Premium burger prepared";
    }
};
class BurgerFactory
{
public:
    Burger *createBurger(std::string &type)
    {
        if (type == "basic")
        {
            return new BasicBurger();
        }
        else if (type == "standard")
        {
            return new StandardBurger();
        }
        else if (type == "premium")
        {
            return new PremiumBurger();
        }
        else
        {
            std::cout << "Invalid Burger Type" << "\n";
            return nullptr;
        }
    }
};

int main()
{
    std::string type = "standard";

    BurgerFactory *orderBurger = new BurgerFactory();
    Burger *burger = orderBurger->createBurger(type);

    burger->prepare();

    return 0;
}