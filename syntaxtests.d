import std;
auto spiltbuffer(R,E)(R r,E e){
	struct spiltbuffer_{
		R r;
		E e;
		E[] buf;
		alias front=buf;
		void popFront(){
			buf=[];
			r.popFront;
			while(r.front!=e && !r.empty){
				buf~=r.front;
				r.popFront;
			}
		}
		bool empty(){return r.empty;}
	}
	auto out_=spiltbuffer_(r,e);
	out_.popFront;
	return out_;
}
struct rand{
	int front;
	void popFront(){
		front=uniform(0,16);
		front.writeln;
	}
	enum empty=false;
}
unittest{
	rand()
	.spiltbuffer(15)
	.take(2)
	.map!(a=>a.splitter!"a%b==0"(5))
	.map!(a=>a.map!(a=>a.splitter!"a%b==0"(3)))
	.each!writeln;
}
