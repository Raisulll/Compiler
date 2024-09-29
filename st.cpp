//st1
#include<bits/stdc++.h>
using namespace std;

int hashFunction(string key)
{
    int sum=0;
    for(int i=0; i<key.size(); ++i)
    {
        sum+=key[i];
    }
    sum=(sum*52)%10;
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
        cout <<"<"<< name << "," << type << "> ";
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
            if (it.getName() == name)
            {
                cout << "Already Exists" << endl;
                return;
            }
        }
        SymbolInfo info(name, type);
        table[index].push_back(info);
        cout << "Inserted at position " << index << " " << table[index].size() - 1 << endl;
    }
    void del(string a)
    {
        int index = hashFunction(a);
        int ind = -1, cnt = 0;
        for (auto it : table[index])
        {
            if (it.getName() == a)
            {
                ind = cnt;
                break;
            }
            cnt++;
        }
        if (ind == -1)
        {
            cout << "Not found" << endl;
            return;
        }
        table[index].erase(table[index].begin() + ind);
    }
    void print()
    {
        for (int i = 0; i < 10; i++)
        {
            cout << i << ">";
            for (auto it : table[i])
            {
                it.print();
            }
            cout << endl;
        }
    }
    void search(string a)
    {
        int index = hashFunction(a);
        int c=0;
        for (auto it : table[index])
        {
            if (it.getName() == a)
            {
                cout << "Found at "<<index<<" "<<c << endl;
                return;
            }
            c++;
        }
        cout << "Doesn't Exists" << endl;
    }
};
int main()
{
   freopen("in.txt","r",stdin);
   freopen("out.txt","w",stdout);
    SymbolTable table;
    string a;
    while (cin >> a)
    {
        if (a == "I")
        {
            string name, type;
            cin >> name >> type;
            table.insert(name, type);
        }
        else if (a == "D")
        {
            string name;
            cin >> name;
            table.del(name);
        }
        else if (a == "P")
        {
            table.print();
        }
        else if (a == "L")
        {
            string name;
            cin >> name;
            table.search(name);
        }
        else
            break;
    }
}
