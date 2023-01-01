enum dchar[] magicvalues=['␟','␞','␝','␜','␛'];
enum unitseperator=magicvalues[0];
enum recordseperator=magicvalues[1];
enum groupseperator=magicvalues[2];
enum fileseperator=magicvalues[3];
enum escseperator=magicvalues[4];

struct filebydchar{
	dstring me; alias me this;
	this(string s){
		import std.file;
		import std.conv;
		me=readText(s).to!dstring;
	}
	int i;
	dchar front(){
		return me[i];
	}
	void popFront(){
		i++;
	}
	bool empty(){
		return i>=me.length-1;
	}
}

int classify(dchar c){
	switch(c){
		static foreach(i,mv;magicvalues){
			case mv: return i;
		}
		default: return -1;
}}

struct reusablebuffer(T){
	int length;
	T[] buffer;
	void nuke(){
		length=0;
	}
	auto get(){
		return buffer[0..length];
	}
	alias get this;
	void opOpAssign(string s="~")(T t){
		if(length<buffer.length){
			buffer[length]=t;
			length++;
		} else {
			buffer~=t;
			length++;
	}}
}
import std.algorithm:map,splitter;
auto __splitter(int i:0,R)(R r){
	return r.splitter(magicvalues[0]);
}
auto __splitter(int i,R)(R r){
	return r.splitter(magicvalues[i]).map!(a=>a.__splitter!(i-1));
}
auto splitbuffer(R,E)(R r,E e){
	struct splitbuffer_{
		R r;
		E e;
		reusablebuffer!E buf;
		E[] front(){
			return buf.get;
		}
		void popFront(){
			buf.nuke;
			if(!r.empty&&r.front==e){r.popFront;}
			if(r.empty){empty=true; return;}
			while(r.front!=e && !r.empty){
				buf~=r.front;
				r.popFront;
			}
			if(r.empty&&r.front!=e){
				buf~=r.front;
			}//sometimes I feel like off by one errors are just piling on more and more logic till it seems to go away
		}
		bool empty=false;
	}
	auto out_=splitbuffer_(r,e);
	out_.popFront;
	return out_;
}
auto parseUSV(int i:0=0)(string s){
	return filebydchar(s).splitbuffer(magicvalues[0]);
}
auto parseUSV(int i)(string s){
	return filebydchar(s).splitbuffer(magicvalues[i]).map!(a=>a.__splitter!(i-1));
}
import std.meta;
import std.traits;
import std.algorithm: max;
int typedepth(T)() if(is(T==struct)){
	return max(staticMap!(typedepth,Fields!T))+1;
}
int typedepth(T)() if(isArray!T){
	return typedepth!(typeof(T.init[0]))+1;
}
int typedepth(T)() if(isBasicType!T){
	return 1;
}
int typedepth(T:string)(){
	return 1;
}
int typedepth(T:dstring)(){
	return 1;
}
dstring __tostring(T)(T t) if(isBasicType!T){
	import std.conv;
	return t.to!dstring;
}
T __fromstring(T,R)(R r) if(isBasicType!T || is(T==dstring) || is(T==string)){
	import std.conv;
	import std.array;
	return r.to!T;
}
T __fromstring(T,R)(R r) if(is(T==struct)){
	T out_;
	static foreach(s;FieldNameTuple!T){{
		if(r.empty){goto exit;}
		alias T_=typeof(mixin("T."~s));
		mixin("out_."~s)=r.front.__fromstring!(T_);
		r.popFront;
	}}
	exit:
	return out_;
}
T __fromstring(T,R)(R r) if(isStaticArray!T){
	T out_;
	alias T_=typeof(T.init[0]);
	foreach(ref e;out_){
		if(r.empty){goto exit;}
		e=r.front.__fromstring!(T_);
		r.popFront;
	}
	exit:
	return out_;
}
T __fromstring(T,R)(R r) if(isDynamicArray!T && !is(T==dstring)&& !is(T==string)){
	T out_;
	alias T_=typeof(T.init[0]);
	foreach(e;r){
		out_~=e.__fromstring!(T_);
	}
	return out_;
}
auto USVto(T)(string file){
	return file
		.parseUSV!(typedepth!T-1)
		.__fromstring!T;
}