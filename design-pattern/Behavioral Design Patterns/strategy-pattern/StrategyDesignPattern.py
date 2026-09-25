from abc import ABC, abstractmethod

class DisountType(ABC):
    @abstractmethod
    def discount(self):
        pass

class on_sale_discount(DisountType):
    def discount(self, price):
        return price * 0.25 + 20

class twenty_percent_discount(DisountType):
    def discount(self, price):
        return price * 0.20
    
class Item():
    def __init__(self, price, discount_strategy: DisountType = None):
        self.price = price
        self.discount_strategy = discount_strategy
    
    def price_after_discount(self):
        if self.discount_strategy:
            discount = self.discount_strategy.discount(self.price)
        else:
            discount = 0
        return max(0, self.price - discount)
    
    def __repr__(self):
        return f"Price: {self.price} ,price after discount {self.price_after_discount()}"

item1 = Item(20000)
print(item1)

item2 = Item(20000, on_sale_discount())
print(item2)

item3 = Item(20000, twenty_percent_discount())
print(item3)