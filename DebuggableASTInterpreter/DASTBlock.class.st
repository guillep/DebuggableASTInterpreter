Class {
	#name : #DASTBlock,
	#superclass : #DASTClosure,
	#category : #'DebuggableASTInterpreter-Closures'
}

{ #category : #'accessing method dictionary' }
DASTBlock class >> lookupSelector: selector [
	" Hack for accessing method definition of BlockClosure while not inheriting from it"
	| method |
	method := super lookupSelector: selector.
	method ifNotNil: [ ^ method ].
	
	^ BlockClosure lookupSelector: selector
	
	
]

{ #category : #accessing }
DASTBlock >> ensure: aBlock [
	"Evaluate a termination block after evaluating the receiver, regardless of
	 whether the receiver's evaluation completes.  N.B.  This method is *not*
	 implemented as a primitive.  Primitive 198 always fails.  The VM uses prim
	 198 in a context's method as the mark for an ensure:/ifCurtailed: activation."

	| complete returnValue |
	<primitive: 198>
	returnValue := self value "self valueNoContextSwitch".
	complete ifNil:[
		complete := true.
		aBlock value.
	].
	^ returnValue
]

{ #category : #accessing }
DASTBlock >> initializeWith: aRBNode [
	self assert: aRBNode isBlock.
	(aRBNode body statements isEmpty) ifTrue: [ aRBNode body addNode: (RBLiteralValueNode value: nil) ].
	super initializeWith:  aRBNode
]

{ #category : #accessing }
DASTBlock >> isBlock [ 
	^true
]

{ #category : #accessing }
DASTBlock >> isMessageValue [
	^ false
]

{ #category : #accessing }
DASTBlock >> isPrimitive [ 
	"A block always has code inside, and cannot have a primitive declaration "
	^ false
]

{ #category : #accessing }
DASTBlock >> methodClass [
	^ nodeAST methodNode methodClass
]

{ #category : #accessing }
DASTBlock >> outerContext [
	^ outerContext 
]

{ #category : #accessing }
DASTBlock >> outerContext: aDASTContext [
	outerContext := aDASTContext
]

{ #category : #accessing }
DASTBlock >> primitive [ 
	"A block always has code inside, and cannot have a primitive declaration "
	^ 0
]

{ #category : #accessing }
DASTBlock >> selector [
	 
	^ 'value' "nodeAST sourceCode"
]

{ #category : #accessing }
DASTBlock >> value: anArg [
	| block |
	block := Smalltalk compiler
		source: self sourceCode;
		context: self outerContext;
		receiver: self outerContext receiver;
		evaluate.
	^ block value: anArg
]
