#include <iostream>
#include <vector>
#include <string>
using namespace std;

#define TABLE_SIZE 10

struct SymbolTableEntry {
    string identifier;
    string type;
    int line_number;
    SymbolTableEntry* next;

    SymbolTableEntry(string id, string t, int line) {
        identifier = id;
        type = t;
        line_number = line;
        next = nullptr;
    }
};

class SymbolTable {
private:
    vector<SymbolTableEntry*> table;

    int hashFunction(const string& id) {
        int hash = 0;
        for (char ch : id) {
            hash += ch;
        }
        return hash % TABLE_SIZE;
    }

public:
    SymbolTable() {
        table.resize(TABLE_SIZE, nullptr);
    }

    void insert(const string& identifier, const string& type, int line_number) {
        int index = hashFunction(identifier);
        SymbolTableEntry* newEntry = new SymbolTableEntry(identifier, type, line_number);

        if (table[index] == nullptr) {
            table[index] = newEntry;
        } else {
            SymbolTableEntry* current = table[index];
            while (current->next != nullptr) {
                current = current->next;
            }
            current->next = newEntry;
        }
        cout << "Inserted identifier \"" << identifier << "\" of type \"" << type << "\" at line " << line_number << endl;
    }

    bool search(const string& identifier) {
        int index = hashFunction(identifier);
        SymbolTableEntry* current = table[index];

        while (current != nullptr) {
            if (current->identifier == identifier) {
                cout << "Identifier \"" << identifier << "\" of type \"" << current->type << "\" found at line " << current->line_number << endl;
                return true;
            }
            current = current->next;
        }
        cout << "Identifier \"" << identifier << "\" not found." << endl;
        return false;
    }

    void display() {
        for (int i = 0; i < TABLE_SIZE; ++i) {
            if (table[i] != nullptr) {
                SymbolTableEntry* current = table[i];
                cout << "Index " << i << ": ";
                while (current != nullptr) {
                    cout << "(" << current->identifier << ", Type: " << current->type << ", Line: " << current->line_number << ") -> ";
                    current = current->next;
                }
                cout << "NULL" << endl;
            }
        }
    }
};

int main() {
    SymbolTable symTable;

    symTable.insert("x", "int", 10);
    symTable.insert("y", "float", 20);
    symTable.insert("isValid", "bool", 30);
    symTable.insert("bar", "float", 40);
    symTable.insert("s", "char", 50);

    symTable.search("x");
    symTable.search("bar");
    symTable.search("s");
    symTable.search("z");
    symTable.search("unknown");

    symTable.display();

    return 0;
}