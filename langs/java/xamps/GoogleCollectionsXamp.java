package com.dburger.gc;

import com.google.common.base.Function;
import com.google.common.base.Joiner;
import com.google.common.base.Objects;
import com.google.common.base.Preconditions;
import com.google.common.collect.BiMap;
import com.google.common.collect.ClassToInstanceMap;
import com.google.common.collect.HashBiMap;
import com.google.common.collect.HashMultimap;
import com.google.common.collect.ImmutableList;
import com.google.common.collect.ImmutableSet;
import com.google.common.collect.Iterables;
import com.google.common.collect.Maps;
import com.google.common.collect.Multimap;
import com.google.common.collect.MutableClassToInstanceMap;
import com.google.common.collect.Ordering;
import com.google.common.collect.Sets;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Set;

class Person {

    private String _name;

    Person(String name) {_name = name;}

    @Override
    public boolean equals(Object other) {
        if (other == this) return true;
        if (!(other instanceof Person)) return false;
        Person that = (Person)other;
        return Objects.equal(_name, that._name);
    }

    @Override
    public int hashCode() {
        // should only be used with multiple objects
        // return Objects.hashCode(_name);
        return _name.hashCode();
    }

    @Override
    public String toString() {return _name;}

    public String getName() {return _name;}

}

class Employee extends Person {

    Employee(String name) {
        super(Preconditions.checkNotNull(name));
    }

}

public class GoogleCollectionsXamp {

    private static final String SEP_EQUAL = "================================";
    private static final String SEP_DASH =  "--------------------------------";

    public void preconditions() {
        // source code was pretty straight forward except for a funky format
        // method
        startPuts("Preconditions can be used instead of asserts");
        try {
            puts("call with null name:");
            exercisePreconditions(null, 13);
        } catch (NullPointerException exc) {
            putsExc(exc);
        }

        try {
            puts("call with illegal age:");
            exercisePreconditions("John", 13);
        } catch (IllegalArgumentException exc) {
            putsExc(exc);
        }
        exercisePreconditionFiltering("bob");
        endPuts();
    }

    private void exercisePreconditions(String name, int age) {
        Preconditions.checkNotNull(name, "name");
        Preconditions.checkArgument(age > 13, "age must be greater than 13");
        puts("got through exercisePreconditions");
    }

    private void exercisePreconditionFiltering(String name) {
        name = Preconditions.checkNotNull(name);
        putf("Preconditions.checkNotNull filtered through %s%n", name);

        try {
            Employee e = new Employee(null);
        } catch (NullPointerException exc) {
            puts("Preconditions.checkNotNull used in super call caused exception");
            putsExc(exc);
        }
    }

    private void getOnlyElement() {
        // pretty straight forward code but did defer to an
        // Iterators.getOnlyElement
        startPuts("this can be used in tests instead of size check +"
                + " fetch first");
        Set<String> strings = new HashSet<String>();
        strings.add("hello world");
        Iterables.getOnlyElement(strings);
        puts("Iterables.getOnlyElement with one element is fine");
        strings.add("goodbye world");
        try {
            Iterables.getOnlyElement(strings);
        } catch (IllegalArgumentException exc) {
            puts("Iterables.getOnlyElement with 2 elements throws exception");
            putsExc(exc);
        }
        strings.clear();
        try {
            Iterables.getOnlyElement(strings);
        } catch (NoSuchElementException exc) {
            puts("Iterables.getOnlyElement with 0 elements throws exception");
            putsExc(exc);
        }
        endPuts();
    }

    private void ordering() {
        // some complex code, CompoundOrdering.java is the bomb
        // really slamming stuff
        startPuts("Ordering has a big bag of tricks, need to look at");
        Integer one = new Integer(1);
        Integer two = new Integer(2);
        puts("old required ternary to get max");
        Integer max = (one.compareTo(two) > 0) ? one : two;

        puts("Ordering.natural().max gives it straight away");
        max = Ordering.natural().max(one, two);
        puts("need to look into this more, this has changed");
        endPuts();
    }

    private void equality() {
        // pretty straight forward code, Objects is small
        startPuts("Objects has equality and hashCode helpers to make bloch"
                + " happy, look at deepEquals and deepHashCode");
        Person p1 = new Person("bob");
        Person p2 = new Person("sam");
        Person p3 = new Person("bob");

        String format = "Person \"%s\" == \"%s\" %b%n";
        putf(format, p1, p2, p1.equals(p2));
        putf(format, p2, p3, p2.equals(p3));
        putf(format, p1, p3, p1.equals(p3));
        endPuts();
    }

    private void immutableList() {
        // interesting code, especially the empty, singleton, and regular
        startPuts("ImmutableList.copyOf makes making immutable copies easy");
        List<String> source = new ArrayList<String>() {{
                add("first");
                add("second");
        }};
        List<String> dest = ImmutableList.copyOf(source);
        try {
            dest.add("nope");
        } catch (UnsupportedOperationException exc) {
            putsExc(exc);
        }
        endPuts();
    }

    private void concat() {
        // wow some surprisingly gnarly code
        startPuts("Iterables.concat concats iterables");
        List<String> namesList = new ArrayList<String>() {{
                add("bob");
                add("jones");
        }};

        Set<String> namesSet = new HashSet<String>() {{
                add("sam");
                add("nunn");
        }};

        for (String name : Iterables.concat(namesList, namesSet)) {
            putf("Iterables.concat added %s%n", name);
        }
        endPuts();
    }

    private void multimap() {
        // complex stuff here
        startPuts("Multimap allows multiple values per key");
        Multimap<String, Person> multimap = HashMultimap.create();
        Person p1 = new Person("sam");
        Person p2 = new Person("bob");
        Person p3 = new Person("con");
        multimap.put("key1", p1);
        multimap.put("key1", p2);
        multimap.put("key2", p3);
        puts(multimap.toString());
        multimap.remove("key1", p1);
        puts(multimap.toString());
        endPuts();
    }

    private void joiner() {
        // nice - I like the AbstractList subclass used to make a quick
        // Iterable from a couple of arguments and an array
        startPuts("Join.join joins");
        String[] names = new String[] {"bob", "john", "james"};
        Joiner join = Joiner.on(" and ");
        puts(join.join(names));
        endPuts();
    }

    private void verbosity() {
        // as expected and in Effective Java / Bloch
        startPuts("Has less verbose factories for generics");
        // Map<String, Person> peopleMap = new HashMap<String, Person>();
        Map<String, Person> peopleMap = Maps.newHashMap();
        Set<Person> peopleSet = Sets.newLinkedHashSet();
        // also has factories for Lists, Multimaps, and Multisets
        endPuts();
    }

    // ridiculous example
    public static Comparator<Person> createPersonComparator() {
        return Ordering.natural()
                .onResultOf(new Function<Person, String>() {
                        public String apply(Person person) {
                            return person.getName();
                        }
                 });
    }

    private void comparators() {
        // nice stuff
        startPuts("Has help for creating comparators");
        Person p1 = new Person("bob");
        Person p2 = new Person("sam");
        Person p3 = new Person("bob");

        // Person[] persons = new Person[] {p1, p2, p3};
        // Arrays.sort(persons, createPersonComparator());

        List<Person> persons = Arrays.asList(p1, p2, p3);
        Collections.sort(persons, createPersonComparator());
        endPuts();
    }

    private void bimap() {
        // nice, nice - but what is the inverse a StandardBiMap rather than
        // just a plain Map?
        startPuts("BiMaps work in both directions");
        BiMap<String, Integer> stringMap = HashBiMap.create();
        stringMap.put("pee", 1);
        stringMap.put("poo", 2);
        putf("from %d got %s%n", 2, stringMap.inverse().get(2));
        endPuts();
    }

    private static interface MyMarker { /* marker interface */ }
    private static class MyImpl1 implements MyMarker { }
    private static class MyImpl2 implements MyMarker { }

    private void classmaps() {
        // clever forever especially that cast
        startPuts("ClassToInstanceMaps are away to avoid key collisions"
                + " when you don't know what people might want to put in a"
                + " map");
        MyImpl1 myImpl1 = new MyImpl1();
        MyImpl2 myImpl2 = new MyImpl2();
        ClassToInstanceMap<MyMarker> map = MutableClassToInstanceMap.create();
        // map.putInstance(myImpl1.getClass(), myImpl1);
        map.putInstance(MyImpl1.class, myImpl1);
        map.putInstance(MyImpl2.class, myImpl2);
        puts(map.toString());
        endPuts();
    }

    private void immutableset() {
        // rather clever stuff like ImmutableList
        startPuts("ImmutableSet is fast and gauranteed immutable -"
                + " Collections.unmodifiableSet is a view to a changable"
                + " set");
        Set<String> myStrings = new HashSet<String>(Arrays.asList("hello",
                "world"));
        // quick defensive copy
        Set<String> myImmutableStringsSet = ImmutableSet.copyOf(myStrings);
        puts(myImmutableStringsSet.toString());
        // also could be used for static constants, here not static
        final Set<String> myStuffs = ImmutableSet.of("first", "second");
        puts(myStuffs.toString());
        endPuts();
    }

    private void setops() {
        // like the Iterators.filter, all nice
        startPuts("Sets contains single line union, difference, and"
                + " intersection methods");
        final Set<String> first = ImmutableSet.of("first", "second");
        final Set<String> second = ImmutableSet.of("second", "third");
        puts("union: " + Sets.union(first, second));
        puts("difference: " + Sets.difference(first, second));
        puts("intersection: " + Sets.intersection(first, second));
        puts("copy of inter: "
                + Sets.intersection(first, second).immutableCopy());
        endPuts();
    }

    public static void startPuts(String msg) {
        puts(SEP_EQUAL);
        puts(msg);
        puts(SEP_DASH);
    }

    public static void endPuts(String msg) {
        puts(msg);
        endPuts();
    }

    public static void endPuts() {
        puts(SEP_EQUAL);
    }

    public static void puts(String msg) {
        System.out.println(msg);
    }

    public static void putf(String format, Object... args) {
        System.out.format(format, args);
    }

    public static void putsExc(Exception exc) {
        putf("caught %s%n", exc.getClass().getName());
        exc.printStackTrace();
    }

    public static void main(String[] args) {
        System.out.println("we are running");
        GoogleCollectionsXamp xamp = new GoogleCollectionsXamp();
        xamp.preconditions();
        xamp.getOnlyElement();
        xamp.ordering();
        xamp.equality();
        xamp.immutableList();
        xamp.concat();
        xamp.multimap();
        xamp.joiner();
        xamp.verbosity();
        xamp.comparators();
        xamp.bimap();
        xamp.classmaps();
        xamp.immutableset();
        xamp.setops();

        puts("made it out");
    }

}
