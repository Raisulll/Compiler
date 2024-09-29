#include <bits/stdc++.h>
extern FILE *fp;
using namespace std;

class SymbolInfo
{
  string name;
  string type;

public:
  SymbolInfo()
  {
    name = "";
    type = "";
  }
  SymbolInfo(string name, string type)
  {
    this->name = name;
    this->type = type;
  }
  void setSymbol(string name, string type)
  {
    this->name = name;
    this->type = type;
  }
  string getName()
  {
    return name;
  }
  string getType()
  {
    return type;
  }
  void printInfo()
  {
    cout << "N: " << name << " T: " << type << endl;
  }
};

class SymbolTable
{
  map<int, vector<SymbolInfo>> table;

public:
  void insertSymbol(SymbolInfo symbol)
  {
    int index = HashFunction(symbol.getName());
    table[index].push_back(symbol);
    // cout<<"Inserted at position "<<index<<","<<table[index].size()-1<<endl;
  }
  void deleteSymbol(string name)
  {
    int index = HashFunction(name);
    for (int i = 0; i < table[index].size(); i++)
    {
      if (table[index][i].getName() == name)
      {
        table[index].erase(table[index].begin() + i, table[index].begin() + i + 1);
        break;
      }
    }
  }
  void printTable()
  {
    for (auto i : table)
    {
      fprintf(fp, "%d --> ", i.first);
      for (auto j : i.second)
      {
        fprintf(fp, "<%s,%s> ", j.getName().c_str(), j.getType().c_str());
      }
      fprintf(fp, "\n");
    }
  }
  bool lookupSymbolInfo(string name)
  {
    int cnt = 0;
    for (auto i : table)
    {

      for (auto j : i.second)
      {

        if (name == j.getName())
        {
          // cout<<name<<"------"<<j.getName()<<endl;
          return true;
        }
      }
    }
    return false;
  }
  int HashFunction(string name)
  {
    int sum = 0;
    sum = name[0];
    sum = sum * 62;
    return sum % 10;
  }
};

// int main()
// {
//     freopen("input.txt", "r", stdin);
//     freopen("output.txt", "w", stdout);
//     SymbolTable st;
//     string command;
//     while(cin>>command)
//     {
//         if(command == "I")
//         {
//             string name, type;
//             cin>>name>>type;
//             SymbolInfo symbol(name, type);
//             st.insertSymbol(symbol);
//             fflush(stdout);
//         }
//         else if(command == "D")
//         {
//             string name;
//             cin>>name;
//             st.deleteSymbol(name);
//             fflush(stdout);
//         }
//         else if(command == "P")
//         {
//             st.printTable();
//             fflush(stdout);
//         }
//         else if(command == "L")
//         {
//             string name;
//             cin>>name;
//             st.lookupSymbolInfo(name);
//             fflush(stdout);
//         }
//     }

// }
