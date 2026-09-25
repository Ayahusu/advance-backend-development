#include <iostream>
#include <string>
#include "EditorState.cpp"

class Editor
{
private:
    std::string content;

public:
    void setContent(std::string content)
    {
        this->content = content;
    }

    std::string getContent()
    {
        return content;
    }

    EditorState createState()
    {
        return EditorState(content);
    }

    void restore(EditorState state)
    {
        content = state.getContent();
    }
};
