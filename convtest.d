import std;
void test(T)(T t){
	assert(t.to!dstring.to!T==t,t.to!string);
}
unittest{
	//float.nan.test;
	//float.nan.to!dstring.writeln is nan its the opcompare;
	int.max.test;
	1.test;
	4.20.test;
	true.test;
	false.test;
	enum foobar{foo,bar}
	foobar.bar.test;
	"foo".test;
	//float.max.test;
	//float.max.to!string.to!float.writeln;
	9999999999999999.to!float.test;
	999999999999999999.to!float.test;
	//99999999999999999999.to!float.test;
	//SumType!(int,float)(1).test;
	//Nullable!int(1).test;
	//void().test;
	//ifloat().test;
	//cfloat().test;
	int i;
	//(&i).test;
}