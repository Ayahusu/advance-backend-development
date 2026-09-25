from abc import ABC, abstractmethod


# Observer Interface
class ISubscriber(ABC):
    @abstractmethod
    def update(self, message: str):
        pass


# Subject Interface
class IChannel(ABC):
    @abstractmethod
    def subscribe(self, subscriber: ISubscriber):
        pass

    @abstractmethod
    def unsubscribe(self, subscriber: ISubscriber):
        pass

    @abstractmethod
    def notify_subscribers(self, message: str):
        pass


# Concrete Subject
class Channel(IChannel):
    def __init__(self, name: str):
        self._name = name
        self._subscribers = set()  # prevents duplicates automatically
        self._latest_video = ""

    def subscribe(self, subscriber: ISubscriber):
        self._subscribers.add(subscriber)

    def unsubscribe(self, subscriber: ISubscriber):
        self._subscribers.discard(subscriber)

    def notify_subscribers(self, message: str):
        for subscriber in self._subscribers:
            subscriber.update(message)

    def upload_video(self, title: str):
        self._latest_video = title
        message = f"\nCheckout our new Video: {title}\n"
        print(f"\n[{self._name} uploaded \"{title}\"]")
        self.notify_subscribers(message)

    def get_video_data(self):
        return self._latest_video


# Concrete Observer
class Subscriber(ISubscriber):
    def __init__(self, name: str):
        self._name = name

    def update(self, message: str):
        print(f"Hey {self._name},{message}")


# ---- Main ----
if __name__ == "__main__":
    channel = Channel("CoderArmy")

    subs1 = Subscriber("Varun")
    subs2 = Subscriber("Tarun")

    channel.subscribe(subs1)
    channel.subscribe(subs2)

    channel.upload_video("Observer Pattern Tutorial")

    channel.unsubscribe(subs1)

    channel.upload_video("Decorator Pattern Tutorial")