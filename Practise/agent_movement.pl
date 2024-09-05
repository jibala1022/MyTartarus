%starting the movement of the agent
:-dynamic jarvis/3.   												%here jarvis is the name of the handler and should be dynamic. /3 defines the number of arguments in the dynamic predicate

% :- use_module(library(prolog_debug)).

node1:-
	consult('platform.pl'),											%this consults the Tartarus platform file, similar to consulting the file in the swi prolog window by File -> consult
	start_tartarus(localhost,60000,1111),							%instantiates a tartarus platform with port number 60000 and the IP as localhost		
	writeln('This is the node1 of the network').						% here the agent is moved to the node2 whose ip is localhost and port is 60001	

node2:-
	consult('platform.pl'),											%this consults the Tartarus platform file, similar to consulting the file in the swi prolog window by File -> consult
	get_public_key(localhost,60001).

node3:-
	consult('platform.pl'),
	writeln('Creating agent at node 60000'),
	create_mobile_agent(ironman,(localhost,60000),jarvis,[1111]),	%this creates a mobile agent with the name "ironman" at the current port and IP address (60000 and localhost) with the handler as "jarvis" and the tokens associated with agent being 1111
	writeln('Agent is moving securely to node 60001'),	
	agent_move_secure(ironman,(localhost,60001)).

node4:-
	consult('platform.pl'),
	writeln('Creating agent at node 60000'),
	create_mobile_agent(ironman,(localhost,60000),jarvis,[1111]),	%this creates a mobile agent with the name "ironman" at the current port and IP address (60000 and localhost) with the handler as "jarvis" and the tokens associated with agent being 1111
	writeln('Agent is moving to node 60001'),	
	agent_move(ironman,(localhost,60001)).


%handler for the agent
jarvis(guid,(IP,Port),main):-        								%this handler is executed when the agent moves to the other node. Note: first argument is a keyword, "guid" ; second argument is (IP,Port) - this whole thing in parathesis is one argument ; the third argument is a keyword "main"
	writeln('I am agent from the other node and right now on ':IP :Port).    %this is to print a message