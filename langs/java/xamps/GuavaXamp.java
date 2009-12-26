package com.dburger.guava;

import com.google.common.base.CharMatcher;
import com.google.common.base.Splitter;
import com.google.common.primitives.Ints;

import java.util.List;

public class GuavaXamp {

    public void charmatcher() {
        final String input = "hello 22 world";
        final CharMatcher idMatcher =
                CharMatcher.DIGIT.or(CharMatcher.is('-'));
        String id = idMatcher.retainFrom(input);
        putf("idMatcher retainFrom %s%n", id);
        String notId = idMatcher.removeFrom(input);
        putf("idMatcher removeFrom %s%n", notId);
    }

    public void splitter() {
        String input = "this,is,,,,,the,input";
        Splitter splitter = Splitter.on(",")
                .trimResults()
                .omitEmptyStrings();
        Iterable<String> parts = splitter.split(input);
        for (String part : parts) {
            putf("splitter split out %s%n", part);
        }
        // how to make array from Iterable ?
    }

    public void primitives() {
        int[] nums = {1, 2, 3, 4};
        List<Integer> list = Ints.asList(nums);
        for (Integer i : list) {
            putf("found an %d%n", i);
        }
    }

    public static void putf(String format, Object... args) {
        System.out.format(format, args);
    }

    public static void main(String[] args) {
        GuavaXamp xamp = new GuavaXamp();
        xamp.charmatcher();
        xamp.splitter();
    }

}
