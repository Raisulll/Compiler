//Symbol Table 3
#include <bits/stdc++.h>
using namespace std;

extern FILE *fp;

int hashFunction(string key)
{
  int sum = 0;
  for (int i = 0; i < key.size(); ++i)
  {
    sum += key[i];
  }
  sum = (sum * 52) % 10;
  return sum;
}
class SymbolInfo
{
  string name;
  string type;

public:
  SymbolInfo(string name, string type)
  {
    this->name = name;
    this->type = type;
  }
  void print()
  {
    fprintf(fp, "<%s,%s> ", name.c_str(), type.c_str());
  }
  string getName()
  {
    return name;
  }
};

class SymbolTable
{
  map<int, vector<SymbolInfo>> table;

public:
  void insert(string name, string type)
  {
    int index = hashFunction(name);
    for (auto it : table[index])
    {
      if (it.getName() == type)
      {
        fprintf(fp, "Already Exists\n");
        return;
      }
    }
    SymbolInfo info(name, type);
    table[index].push_back(info);
  }
  void print()
  {
    for (int i = 0; i < 10; i++)
    {
      fprintf(fp, "%d>", i);
      for (auto it : table[i])
      {
        it.print();
      }
      fprintf(fp, "\n");
    }
  }
  bool search(string a)
  {
    int index = hashFunction(a);
    int c = 0;
    for (auto it : table[index])
    {
      if (it.getName() == a)
      {
        return true;
      }
      c++;
    }
    return false;
  }
};

