#include <iostream>
#include <string>

class EditorState
{
private:
    std::string content;

public:
    EditorState(std::string content)
    {
        this->content = content;
    }

    std::string getContent()
    {
        return content;
    }
};
