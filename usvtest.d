import std;
import usv;
unittest{
	"a␟b␞c␟d␝e␟f␞g␟h␜i␟j␞k␟l␝m␟n␞o␟p".map!classify.each!writeln;
}
unittest{
	foreach(c;filebydchar("example.usv")){
		if(c==unitseperator){','.write; continue;}
		if(c==recordseperator){writeln;continue;}
		if(c==groupseperator){writeln;"---".writeln;continue;}
		if(c==fileseperator){writeln;"===".writeln;continue;}
		c.write;
}}
unittest{
	reusablebuffer!int foo;
	foo~=1;
	foo~=2;
	foo.get.writeln;
	foo.nuke;
	foo.get.writeln;
	foo~=3;
	foo.get.writeln;
}
unittest{
	"a␟b".__splitter!0.each!writeln;
}
unittest{
	auto foo="hello,bye;foo,bar".splitter(',').map!(a=>a.splitter(';'));
}
unittest{
	foreach(a;"a␟b␞c␟d␝e␟f␞g␟h".__splitter!2){
	foreach(b;a){
	foreach(c;b){
		c.write;
		','.write;
	}
		';'.write;
	}
		writeln;
	}
}
unittest{
	"----".writeln;
	"example1.usv".parseUSV.each!writeln;
}
unittest{
	"----".writeln;
	"example1.usv".parseUSV!0.each!writeln;
}
unittest{
	"----".writeln;
	"example1.usv".parseUSV!1.front.each!writeln;
}
unittest{
	"----".writeln;
	"example1.usv".parseUSV!2.front.front.each!writeln;
}
unittest{
	foreach(a;"example.usv".parseUSV!2){
	foreach(b;a){
	foreach(c;b){
		c.write;
		','.write;
	}
		';'.write;
	}
		writeln;
	}
}
unittest{
	"---".writeln;
	struct vec2{
		int x;
		int y;
	}
	typedepth!vec2.writeln;
	typedepth!(vec2[]).writeln;
	typedepth!(vec2[3]).writeln;
	typedepth!(vec2[][]).writeln;
}
unittest{
	struct vec2{int x;int y;}
	["1","2"].map!(a=>a).__fromstring!(vec2).writeln;
	[["1","2"],["3","4"]].map!(a=>a.map!(a=>a)).__fromstring!(vec2[2]).writeln;
	[["1","2"],["3","4"]].map!(a=>a.map!(a=>a)).__fromstring!(vec2[]).writeln;
}
unittest{
	"example.usv".USVto!(string[][][][]).writeln;
	"example1.usv".USVto!(string[]).writeln;
}