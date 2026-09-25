#include <iostream>
#include <string>

class IReports
{
public:
    virtual std::string getJSONData(std::string &data) = 0;
    virtual ~IReports() {}
};

class XmlDataProvider
{
public:
    std::string getXmlData(std::string &data)
    {
        size_t sep = data.find(':');
        std::string name = data.substr(0, sep);
        std::string id = data.substr(sep + 1);

        return "<user>"
               "<name>" +
               name + "<name>"
                      "<id>" +
               id + "<id>"
                    "</user>";
    }
};
int main()
{

    return 0;
}