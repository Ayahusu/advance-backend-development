from abc import ABC, abstractmethod

class Burger(ABC):
    @abstractmethod
    def prepare(self):
        pass


class BasicBurger(Burger):
    def prepare(self):
        print("Basic burger is prepared")

class StandardBurger(Burger):
    def prepare(self):
        print("Standard burger is prepared")

class PreminumBurger(Burger):
    def prepare(self):
        print("Preminum burger is created")

class BurgerFactory():
    def createBurger(self, type:str)-> Burger:
        if type.lower() == 'basic':
            return BasicBurger()
        elif type.lower() == 'standard':
            return StandardBurger()
        elif type.lower() == 'premium':
            return PreminumBurger()
        else:
            print('Invalid Burger')

def main():
    type = "Standard"

    obj = BurgerFactory()
    burger = obj.createBurger(type)
    if burger:
        burger.prepare();

if __name__ == "main":
    main()
