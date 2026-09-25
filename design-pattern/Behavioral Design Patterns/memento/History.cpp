#include <vector>
#include "EditorState.cpp"
class History
{
private:
    std::vector<EditorState> states;

public:
    void push(EditorState state)
    {
        states.push_back(state);
    }

    EditorState pop()
    {
        EditorState lastState = states.back();
        states.pop_back();
        return lastState;
    }
};