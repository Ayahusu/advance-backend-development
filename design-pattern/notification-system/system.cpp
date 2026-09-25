#include <iostream>
#include <string>

// Notification System

class INotification
{
public:
    virtual std::string getContent() const = 0;
    virtual ~INotification();
};

// Concrete Notification : simple text notification
class SimpleNotification : public INotification
{
private:
    std::string text;

public:
    SimpleNotification(const std::string &msg)
    {
        text = msg;
    }
    std::string getContent() const override
    {
        return text;
    }
};

// Abstract Decorator: wraps a notification object

class INotificationDecorator : public INotification
{
protected:
    INotification *notification;

public:
    INotificationDecorator(INotification *n)
    {
        notification = n;
    }

    virtual ~INotificationDecorator()
    {
        delete notification;
    }
};

class Timestamps : public INotificationDecorator
{
public:
    Timestamps(INotification *n) : INotificationDecorator(n) {}

    std::string getContent() const override
    {
        return "[2025-12-1 14:30:02]" + notification->getContent();
    }
};
int main()
{
    return 0;
}