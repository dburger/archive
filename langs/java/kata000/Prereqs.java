import java.util.Arrays;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.HashSet;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Prereqs {

    private static class Course implements Comparable<Course> {

        private static final Pattern COURSE_MATCHER
                = Pattern.compile("([A-Z]{3,4})(\\d{3})");

        private String _name;
        private String _department;
        private int _number;

        public Course(String name) {
            Matcher m = COURSE_MATCHER.matcher(name);
            if (!m.matches()) throw new IllegalArgumentException();
            _name = name;
            _department = m.group(1);
            _number = Integer.parseInt(m.group(2));
        }

        public String getDepartment() {return _department;}
        public int getNumber() {return _number;}

        // contract for equals

        @Override
        public boolean equals(Object other) {
            if (other == this) return true;
            if (!(other instanceof Course)) return false;
            Course course = (Course)other;
            return course._name.equals(_name);
        }

        // override hashCode if override equals

        @Override
        public int hashCode() {return _name.hashCode();}

        // consider comparable

        @Override
        public int compareTo(Course course) {
            if (course._name.equals(_name)) return 0;
            if (course._number != _number) return _number - course._number;
            return _department.compareTo(course._department);
        }

        @Override
        public String toString() {
            return _name;
        }

    }

    private void loadSpecs(String[] specs, Map<Course, Set<Course>> reqMap) {
        for (String spec: specs) {
            String[] parts = spec.split(" ");
            Course course = new Course(parts[0].substring(0, parts[0].length() - 1));
            Set<Course> prereqs = reqMap.get(course);
            if (prereqs == null) {
                prereqs = new HashSet<Course>();
            } else {
                // spec twice, ok ?
            }
            for (int i = 1; i < parts.length; i++) {
                prereqs.add(new Course(parts[i]));
            }
            reqMap.put(course, prereqs);
        }
    }

    private Course[] getCandidates(Map<Course, Set<Course>> reqMap) {
        List<Course> candidates = new ArrayList<Course>();
        Set<Map.Entry<Course, Set<Course>>> s = reqMap.entrySet();
        for (Map.Entry<Course, Set<Course>> me: s) {
            if (me.getValue().size() == 0) candidates.add(me.getKey());
        }
        return candidates.toArray(new Course[0]);
    }

    private void courseCleared(Course course, Map<Course, Set<Course>> reqMap) {
        Set<Map.Entry<Course, Set<Course>>> s = reqMap.entrySet();
        for (Map.Entry<Course, Set<Course>> me: s) {
            me.getValue().remove(course);
        }
    }

    public String[] orderClasses(String[] specs) {
        try {
            Map<Course, Set<Course>> reqMap = new HashMap<Course, Set<Course>>();
            loadSpecs(specs, reqMap);
            List<String> order = new ArrayList<String>();
            while (reqMap.size() != 0) {
                Course[] candidates = getCandidates(reqMap);
                if (candidates.length == 0) throw new IllegalArgumentException();
                Arrays.sort(candidates);
                for (Course c: candidates) {
                    order.add(c.toString());
                    reqMap.remove(c);
                    courseCleared(c, reqMap);
                }
            }

            return order.toArray(new String[0]);
        } catch (IllegalArgumentException exc) {
            return new String[0];
        }
    }

    public static void main(String[] args) {
        String[] specs = new String[] {"CSE122: MTH100", "MTH100: MTH180", "MTH180:"};
        Prereqs p = new Prereqs();
        System.out.println(Arrays.toString(p.orderClasses(specs)));
    }

}
