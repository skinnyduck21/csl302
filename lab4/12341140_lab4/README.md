There are 9 files in this folder

(i) q1_head.l
Consists of the lex code for head command

(ii) q1_tail.l
Consists of the lex code for tail commnd

(iii) q1_cat.l
Consits of the lex code for cat command

(iv) q1_cp.l
Consists of the lex code for cp command

(v) q1_file1.txt
Consists of simple text to test the code of q1.l

(vi) q1_file2.txt
Consists of simple text to test the code of q1.l. It consists of different text than q1_file1.txt initially but after running cp command(given below) it will copy the contents of q1_file1.txt

(vii) q2.l
Consists of the lex code for question 2

(viii) q2_file.txt
Consists of both valid and invalid paths to test the code of q2.l

(ix) README.md
It is the present file


--Commands to run q1_head.l

lex q1_head.l
gcc lex.yy.c
./a.out

Then in the running process, enter this:

head q1_file1.txt

Press Control + C to stop the execution

--Commands to run q1_tail.l

lex q1_tail.l
gcc lex.yy.c
./a.out

Then in the running process, enter this:

tail q1_file1.txt

Press Control + C to stop the execution

--Commands to run q1_cat.l

lex q1_cat.l
gcc lex.yy.c
./a.out

Then in the running process, enter this:

cat q1_file1.txt

Press Control + C to stop the execution

Commands to run q1_cp.l

lex q1_cp.l
gcc lex.yy.c
./a.out

Then in the running process, enter this:

cp q1_file1.txt q1_file2.txt

Press Control + C to stop the execution

Question 2:
Use the following commands to run the q2.l

lex q2.l
gcc lex.yy.c
./a.out < q2_file.txt


This will print VALID PATH or INVALID PATH depending on whether the path written in file q2_file.txt is correct or not
