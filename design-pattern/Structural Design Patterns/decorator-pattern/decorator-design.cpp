#include <iostream>
#include <string>

class Character
{
public:
    virtual std::string getAbility() const = 0;
    virtual ~Character() {};
};

class Mario : public Character
{
public:
    std::string getAbility() const override
    {
        return "Mario";
    }
};

class CharacterDecorator : public Character
{
protected:
    Character *character;

public:
    CharacterDecorator(Character *c)
    {
        this->character = c;
    }
};

int main()
{

    return 0;
}