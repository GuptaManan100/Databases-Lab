#include <bits/stdc++.h>
using namespace std;
 
#define BSET(a, p) ((a) | (1ll << (p)))
#define BCHK(a, p) ((a) & (1ll << (p)))
#define BXOR(a, p) ((a) ^ (1ll << (p)));
#define BREM(a, p) (BCHK(a, p)?(BXOR(a, p)):(a))
#define BSHO(a, N) (bitset<N>(a))
 
#define fi first
#define sc second 
#define pb push_back
 
#define int ll
#define i32 int32_t
 
#define all(v) (v).begin(),(v).end()

#define TY int
 
typedef long long ll;
typedef long double ld;
typedef pair< int, int > pii;
typedef pair< ll, ll > pll;

class Bucket{
	int localDepth;
	int siz;
	vector<TY> data;

public:
	Bucket(int lc);
	void insert(TY da);
	bool search(TY da);
	int getDepth();
	void setDepth(int de);
	int getSize();
	void erase(TY da);
	void print();
	void clearData();
	vector<TY> getData();
};

vector<TY> Bucket::getData()
{
	return this->data;
}

void Bucket::clearData()
{
	this->data.clear();
	this->siz = 0;
}

Bucket::Bucket(int lc=0)
{
	this->localDepth = lc;
	this->siz = 0;
	this->data.clear();
}

void Bucket::insert(TY da)
{
	this->siz++;
	this->data.pb(da);
}

bool Bucket::search(TY da)
{
	for(int i=0;i< this->siz;i++)
	{
		if((this->data)[i] == da)
			return true;
	}
	return false;
}

int Bucket::getDepth()
{
	return this->localDepth;
}

void Bucket::setDepth(int de)
{
	this->localDepth = de;
}

int Bucket::getSize()
{
	return this->siz;
}

void Bucket::erase(TY da)
{
	if(this->search(da)==false)
		return;
	this->siz--;
	for(auto i=(this->data).begin();i!=(this->data).end();i++)
	{
		if(*i == da)
		{
			(this->data).erase(i);
			return;
		}
	}
}

void Bucket::print()
{
	cout<<"Size: "<<this->siz<<" "<<"Local Depth: "<<this->localDepth<<" Data: ";
	for(int i=0;i< this->siz;i++)
	{
		cout<<(this->data)[i]<<" ";
	}
	cout<<endl;
}


class HashTable
{
	int globalDepth;
	int maxBucketSize;
	vector<Bucket*> directory;
	int hashFunction(TY da);
	int getIndex(int depth, int hash);
	void grow();
	void split(int dirNo);

public:
	HashTable(int bs);
	void insert(TY da);
	bool search(TY da);
	void erase(TY da);
	void display();
};

void HashTable::grow()
{
    for(int i = 0 ; i < 1<<this->globalDepth ; i++ )
        this->directory.push_back(this->directory[i]);
    this->globalDepth++;
}

void HashTable::split(int dirNo)
{
	int ld  = this->directory[dirNo]->getDepth();
	dirNo = this->getIndex(ld,dirNo);
	if(ld==this->globalDepth)
		this->grow();
	vector<TY> temp = this->directory[dirNo]->getData();
	this->directory[dirNo]->clearData();
	this->directory[dirNo]->setDepth(ld+1);

	int newDirNo = dirNo + (1<<ld);
	this->directory[newDirNo] = new Bucket(ld+1);

	int step = 1<<(ld+1);
	for(int i = newDirNo + step; i< 1<<this->globalDepth; i+=step)
	{
		this->directory[i] = this->directory[newDirNo];
	}

	int idx;
	for(auto x: temp)
	{
		idx = getIndex(this->globalDepth,this->hashFunction(x));
		this->directory[idx]->insert(x);
	}
}

HashTable::HashTable(int bs)
{
	this->globalDepth = 0;
	this->maxBucketSize = bs;
	this->directory.clear();
	Bucket *newBucket = new Bucket(0);
	this->directory.pb(newBucket);
}

int HashTable::hashFunction(TY da)
{
	//Change Hash Function According To The Type
	int x = (int) da;
	return x;
}

int HashTable::getIndex(int depth, int hash)
{
	int pow2 = 0;
	int val = 1;
	int andv = 0;
	for(int pow2=0;pow2<depth;pow2++)
	{
		andv+=val;
		val*=2;
	}

	int idx = andv&hash;
	return idx;
}

void HashTable::insert(TY da)
{
	int idx = getIndex(this->globalDepth,this->hashFunction(da));
	while(this->directory[idx]->getSize() == this->maxBucketSize)
	{
		//if(this->globalDepth==5)
		//	return;
		//cout<<idx<<" "<<this->globalDepth<<endl;
		this->split(idx);
		idx = getIndex(this->globalDepth,this->hashFunction(da));
		//this->display();
	}
	this->directory[idx]->insert(da);
}

bool HashTable::search(TY da)
{
	int idx = getIndex(this->globalDepth,this->hashFunction(da));
	return this->directory[idx]->search(da);
}

void HashTable::erase(TY da)
{
	int idx = getIndex(this->globalDepth,this->hashFunction(da));
	this->directory[idx]->erase(da);
}

void HashTable::display()
{
	cout<<"Global Depth: "<<this->globalDepth<<endl;
	for(int i=0;i< 1<<this->globalDepth;i++)
	{
		cout<<i<<" "<<this->directory[i]<<" ";
		this->directory[i]->print();
	}
}

int32_t main()
{
	int maxi;
	cin>>maxi;

	HashTable* ht = new HashTable(maxi);

	int ty;
	TY data;
	while(true)
	{
		cin>>ty;
		if(ty==0)
			break;
		if(ty==1)
		{
			cin>>data;
			ht->insert(data);
		}
		if(ty==2)
		{
			cin>>data;
			if(ht->search(data))
				cout<<"Found"<<endl;
			else
				cout<<"Not Found"<<endl;
		}
		if(ty==3)
		{
			cin>>data;
			ht->erase(data);
		}
		ht->display();
	}
	return 0;
}