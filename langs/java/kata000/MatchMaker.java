import java.util.Arrays;
import java.util.ArrayList;
import java.util.List;

public class MatchMaker {

    // damn sloppy

    private static class Match implements Comparable<Match> {

        private String _name;
        private int _sf;

        public Match(String name, int sf) {
            _name = name;
            _sf = sf;
        }

        public String getName() {return _name;}

        public int compareTo(Match other) {
            return other._sf - _sf;
        }

    }

    public String[] getBestMatches(String[] members, String currentMember,
            int sf) {
        String[] member = null;
        List<String[]> explodedMembers = new ArrayList<String[]>();
        for (int i = 0; i < members.length; i++) {
            String[] explodedMember = members[i].split(" ");
            if (explodedMember[0].equals(currentMember)) {
                member = explodedMember;
            }
            explodedMembers.add(explodedMember);
        }

        List<Match> matches = new ArrayList<Match>();
        for (String[] explodedMember: explodedMembers) {
            if (member[0].equals(explodedMember[0])) continue;
            if (!(member[1].equals(explodedMember[2]) &&
                    member[2].equals(explodedMember[1]))) continue;
            int msf = 0;
            for (int i = 3; i < member.length; i++) {
                if (member[i].equals(explodedMember[i])) msf++;
            }
            if (msf >= sf) {
                Match m = new Match(explodedMember[0], msf);
                matches.add(m);
            }
        }

        Match[] matchArr = matches.toArray(new Match[0]);
        Arrays.sort(matchArr);
        String[] matchess = new String[matchArr.length];
        for (int i = 0; i < matchArr.length; i++) {
            matchess[i] = matchArr[i].getName();
        }

        return matchess;
    }

    public static void main(String[] args) {
        String[] input = new String[] {"BETTY F M A A C C",
                                       "TOM M F A D C A",
                                       "SUE F M D D D D",
                                       "ELLEN F M A A C A",
                                       "JOE M F A A C A",
                                       "ED M F A D D A",
                                       "SALLY F M C D A B",
                                       "MARGE F M A A C C"};
        MatchMaker mm = new MatchMaker();
        System.out.println(Arrays.toString(mm.getBestMatches(input, "BETTY", 2)));
    }

}
