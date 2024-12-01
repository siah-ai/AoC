
/*
Online Java - IDE, Code Editor, Compiler

Online Java is a quick and easy tool that helps you to build, compile, test your programs online.
*/
import java.lang.Math;
import java.util.*; 
public class Main
{
    public static void main(String[] args) {
        //Paste all the numbers in 
        Scanner in = new Scanner (System.in);
        System.out.println("Please feed me the numbers, mommy (✿◡‿◡)");
        String snackies = in.nextLine().trim();
       
        String[] aocInputs = snackies.split("\\s+");
        ArrayList<Integer> list1 = new ArrayList<>();
        ArrayList<Integer> list2 = new ArrayList<>();
       
        for ( int ii=0; ii<aocInputs.length; ii+=2 ) {
            list1.add(Integer.parseInt(aocInputs[ii]));
            list2.add(Integer.parseInt(aocInputs[ii+1]));
        }
        
        Collections.sort(list1);
        Collections.sort(list2);
        
        int sum = 0;
        for ( int jj : list1 ) {
            int diff = Math.abs(jj - list2.get(list1.indexOf(jj)));
            sum += diff;
        }
        System.out.println("Sum is " + sum);
    }
}
