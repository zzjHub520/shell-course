import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class Main {
    public static void main(String[] args) throws Exception {
        List<String> strList = readLine("input/shell 进阶.txt");

        List<String> resultString = new ArrayList<String>();
        for (int i = 0; i < strList.size(); i += 3) {
            String s = strList.get(i) + "\t" + strList.get(i + 2) + " " + strList.get(i + 1);
            System.out.println(s);
//            System.out.println(strList.get(i));
        }
    }

    public static List<String> readLine(String fileName) throws Exception {
        FileInputStream fis = new FileInputStream(fileName);
        //filename eg."src\\1.txt"
        List<String> st = new ArrayList<String>();
        try (BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(fis))) {
            String myLine = null;

            while ((myLine = bufferedReader.readLine()) != null) {
                st.add(myLine);
            }
            //进行你想进行的操作
            fis.close();
            bufferedReader.close();
        }
        return st;
    }

    public static void write(String filename, String[] str) throws IOException {

        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filename))) {
            for (int i = 0; i < str.length; i++) {
                bw.write(str[i]);
                bw.newLine();
            }
        }
    }

    private static void test(String s) throws Exception {
        String str = "src\\2.txt";
        File newFile = new File(str);
        try {
            FileOutputStream out = new FileOutputStream(newFile, true);
            StringBuffer sb = new StringBuffer();
            sb.append(s);
            out.write(s.toString().getBytes("UTF-8"));
            out.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

}
