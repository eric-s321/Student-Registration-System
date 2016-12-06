
JC = javac

.SUFFIXES: .java .class

.java.class:
	$(JC) $*.java

CLASSES = \
	TableGetter.java \
	App.java \
	BNumClassIDForm.java \
	BNumClassIDListener.java \
	BNumForm.java \
	BNumListener.java \
	ClassIDForm.java \
	ClassIDFormListener.java \
	DisplayPanel.java \
	MainFrame.java \
	MainMenu.java \
	PrereqForm.java \
	PrereqFormListener.java \
	ViewTableListener.java \
	ViewTablesForm.java 

default: classes

classes: $(CLASSES:.java=.class)

clean:
	$(RM) *.class
